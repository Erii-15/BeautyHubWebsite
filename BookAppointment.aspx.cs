using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class BookAppointment : System.Web.UI.Page
    {
        private const string CONN = "Server=146.230.177.46;Database=WstGrp14;User ID=WstGrp14;Password=ajqbd;";

        public class ServiceVm
        {
            public int ServiceID { get; set; }
            public string ServiceName { get; set; }
            public string Description { get; set; }
            public decimal Price { get; set; }
            public bool Promotion { get; set; }
            public decimal PromotionPrice { get; set; }
            public int DurationMinutes { get; set; }
        }

        // ---------- Page lifecycle ----------
        protected void Page_Load(object sender, EventArgs e)
        {
            // Require login
            
            if (!IsLoggedIn())
            {
                string returnUrl = Server.UrlEncode(Request.RawUrl);
                Response.Redirect($"~/Account/Login?returnUrl={returnUrl}", endResponse: true);
                return;
            }
            
            if (!IsPostBack)
            {
                // serviceId via querystring
                if (!int.TryParse(Request.QueryString["serviceId"], out int serviceId))
                {
                    Notify("error", "Missing service", "No service ID was provided.");
                    return;
                }

                hfServiceID.Value = serviceId.ToString();

                // Load service + staff
                var svc = GetServiceById(serviceId);
                if (svc == null)
                {
                    Notify("error", "Unavailable", "This service is not available.");
                    return;
                }

                // Show service summary
                pnlService.Visible = true;
                lblSvcName.Text = svc.ServiceName;
                lblSvcDesc.Text = svc.Description;
                lblSvcPrice.Text = ((svc.Promotion && svc.PromotionPrice > 0) ? svc.PromotionPrice : svc.Price).ToString("F2");
                lblSvcDur.Text = svc.DurationMinutes.ToString();

                BindStaff();
                pnlForm.Visible = true;
            }
        }

        // ---------- Events ----------
        protected void btnBook_Click(object sender, EventArgs e)
        {

            
            if (!IsLoggedIn())
            {
                string returnUrl = Server.UrlEncode(Request.RawUrl);
                Response.Redirect($"~/Account/Login?returnUrl={returnUrl}", endResponse: true);
                return;
            }
            

            // Validate form
            if (string.IsNullOrWhiteSpace(hfServiceID.Value) ||
                string.IsNullOrWhiteSpace(ddlStaff.SelectedValue) ||
                string.IsNullOrWhiteSpace(txtDate.Text) ||
                string.IsNullOrWhiteSpace(txtTime.Text))
            {
                Notify("warning", "Missing information", "Please fill all fields.");
                return;
            }

            int customerId = ResolveCustomerId();
            int serviceId = int.Parse(hfServiceID.Value);
            int staffId = int.Parse(ddlStaff.SelectedValue);
            DateTime date = DateTime.Parse(txtDate.Text).Date;
            TimeSpan start = TimeSpan.Parse(txtTime.Text);
            string comment = string.IsNullOrWhiteSpace(txtComment.Text) ? null : txtComment.Text;


            // --- Business hours check: 7 AM to 5 PM ---
            if (start < TimeSpan.FromHours(7) || start >= TimeSpan.FromHours(17))
            {
                Notify("warning", "Outside working hours",
                    "Appointments can only be booked between 7:00 AM and 5:00 PM.");
                return;
            }


            var svc = GetServiceById(serviceId);
            if (svc == null || svc.DurationMinutes <= 0)
            {
                Notify("error", "Invalid service", "This service is inactive or has no duration.");
                return;
            }

            TimeSpan end = start.Add(TimeSpan.FromMinutes(svc.DurationMinutes));
            if (end > TimeSpan.FromHours(24))
            {
                Notify("warning", "Ends past midnight", "Please choose an earlier time.");
                return;
            }

            using (var conn = new SqlConnection(CONN))
            {
                conn.Open();

                // server time
                DateTime serverNow;
                using (var cmdNow = new SqlCommand("SELECT GETDATE()", conn))
                    serverNow = (DateTime)cmdNow.ExecuteScalar();

                DateTime serverToday = serverNow.Date;
                TimeSpan serverTime = serverNow.TimeOfDay;

                if (date < serverToday || (date == serverToday && start <= serverTime))
                {
                    Notify("warning", "Past time", "You can’t book in the past.");
                    return;
                }

                using (var tx = conn.BeginTransaction(System.Data.IsolationLevel.Serializable))
                {
                    try
                    {
                        // Block if *this customer* already has an overlapping appointment at this time
                        var custSlots = new List<(DateTime d, TimeSpan st, int dur)>();
                        using (var cmdCust = new SqlCommand(@"
    SELECT a.Date, a.Time, s.DurationMinutes
    FROM AppointmentNEW a
    JOIN ServiceNEW s ON s.ServiceID = a.ServiceID
    WHERE a.CustomerID = @cust
      AND a.Status IN ('Scheduled','Confirmed','InProgress');", conn, tx))
                        {
                            cmdCust.Parameters.AddWithValue("@cust", customerId);
                            using (var r = cmdCust.ExecuteReader())
                            {
                                while (r.Read())
                                {
                                    var d = Convert.ToDateTime(r["Date"]).Date;
                                    var st = (TimeSpan)r["Time"];
                                    var dur = Convert.ToInt32(r["DurationMinutes"]);
                                    custSlots.Add((d, st, dur));
                                }
                            }
                        }

                        // Only care about appointments on the SAME DATE as the requested booking.
                        // And only if they OVERLAP in time.
                        bool customerConflict = custSlots.Any(x =>
                        {
                            if (x.d != date) return false; // different day is fine

                            var existStart = x.st;
                            var existEnd = existStart.Add(TimeSpan.FromMinutes(x.dur));

                            // does (existStart, existEnd) overlap (start, end)?
                            return Overlaps(existStart, existEnd, start, end);
                        });

                        if (customerConflict)
                        {
                            Notify("info", "Existing booking",
                                "You already have an appointment that conflicts with this time.");
                            tx.Rollback();
                            return;
                        }


                        // Check staff overlap on that date
                        var staffSlots = new List<(TimeSpan st, int dur)>();
                        using (var cmdStaff = new SqlCommand(@"
                            SELECT a.Time, s.DurationMinutes
                            FROM AppointmentNEW a
                            JOIN ServiceNEW s ON s.ServiceID = a.ServiceID
                            WHERE a.StaffID = @staff
                              AND a.Date    = @date
                              AND a.Status IN ('Scheduled','Confirmed','InProgress');", conn, tx))
                        {
                            cmdStaff.Parameters.AddWithValue("@staff", staffId);
                            cmdStaff.Parameters.AddWithValue("@date", date);
                            using (var r = cmdStaff.ExecuteReader())
                            {
                                while (r.Read())
                                {
                                    var st = (TimeSpan)r["Time"];
                                    var dur = Convert.ToInt32(r["DurationMinutes"]);
                                    staffSlots.Add((st, dur));
                                }
                            }
                        }

                        bool conflict = staffSlots.Any(x =>
                        {
                            var existingStart = x.st;
                            var existingEnd = existingStart.Add(TimeSpan.FromMinutes(x.dur));
                            return Overlaps(existingStart, existingEnd, start, end);
                        });

                        if (conflict)
                        {
                            Notify("error", "Staff busy", "The selected staff member is already booked at that time.");
                            tx.Rollback();
                            return;
                        }

                        // Insert
                        using (var cmdIns = new SqlCommand(@"
                            INSERT INTO AppointmentNEW 
                                (CustomerID, StaffID, ServiceID, Date, Time, Status, Comment, Rating)
                            VALUES 
                                (@c, @s, @svc, @d, @t, @status, @comment, @rating);", conn, tx))
                        {
                            cmdIns.Parameters.AddWithValue("@c", customerId);
                            cmdIns.Parameters.AddWithValue("@s", staffId);
                            cmdIns.Parameters.AddWithValue("@svc", serviceId);
                            cmdIns.Parameters.AddWithValue("@d", date);
                            var pTime = cmdIns.Parameters.Add("@t", System.Data.SqlDbType.Time);
                            pTime.Value = start;
                            cmdIns.Parameters.AddWithValue("@status", "Scheduled");
                            cmdIns.Parameters.AddWithValue("@comment", (object)comment ?? DBNull.Value);
                            cmdIns.Parameters.AddWithValue("@rating", 0); // NOT NULL col
                            cmdIns.ExecuteNonQuery();
                        }

                        tx.Commit();
                        Notify("success", "Booked!", "Appointment booked successfully.");

                        // Clear
                        txtDate.Text = txtTime.Text = txtComment.Text = string.Empty;
                        ddlStaff.ClearSelection();
                        if (ddlStaff.Items.Count > 0) ddlStaff.Items[0].Selected = true;
                    }
                    catch (Exception ex)
                    {
                        try { tx.Rollback(); } catch { }
                        Notify("error", "Booking failed", ex.Message);
                    }
                }
            }
        }

        // ---------- Data helpers ----------
        private ServiceVm GetServiceById(int serviceId)
        {
            using (var conn = new SqlConnection(CONN))
            using (var cmd = new SqlCommand(@"
                SELECT ServiceID, ServiceName, Description, Price, Promotion,
                       PromotionPrice, DurationMinutes
                FROM ServiceNEW
                WHERE ServiceID = @id AND IsActive = 1;", conn))
            {
                cmd.Parameters.AddWithValue("@id", serviceId);
                conn.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        return new ServiceVm
                        {
                            ServiceID = Convert.ToInt32(r["ServiceID"]),
                            ServiceName = r["ServiceName"]?.ToString() ?? "",
                            Description = r["Description"]?.ToString() ?? "",
                            Price = r["Price"] != DBNull.Value ? Convert.ToDecimal(r["Price"]) : 0m,
                            Promotion = r["Promotion"] != DBNull.Value && Convert.ToBoolean(r["Promotion"]),
                            PromotionPrice = r["PromotionPrice"] != DBNull.Value ? Convert.ToDecimal(r["PromotionPrice"]) : 0m,
                            DurationMinutes = r["DurationMinutes"] != DBNull.Value ? Convert.ToInt32(r["DurationMinutes"]) : 0
                        };
                    }
                }
            }
            return null;
        }

        private void BindStaff()
        {
            ddlStaff.Items.Clear();
            ddlStaff.Items.Add(new ListItem("-- Select --", ""));

            using (SqlConnection conn = new SqlConnection(CONN))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT 
                    StaffID,
                    CASE 
                        WHEN LTRIM(RTRIM(CONCAT(ISNULL(FirstName, ''), ' ', ISNULL(LastName, '')))) <> ''
                            THEN LTRIM(RTRIM(CONCAT(ISNULL(FirstName, ''), ' ', ISNULL(LastName, ''))))
                        ELSE CAST(StaffID AS varchar(20))
                    END AS DisplayName
                FROM StaffNEW
                WHERE IsActive = 1
                ORDER BY DisplayName;", conn))
            {
                conn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        ddlStaff.Items.Add(new ListItem(
                            r["DisplayName"].ToString(),
                            r["StaffID"].ToString()
                        ));
                    }
                }
            }
        }

        // ---------- Utility ----------
        private bool IsLoggedIn() => Session["CustomerID"] != null;

        private int ResolveCustomerId() => Convert.ToInt32(Session["CustomerID"]);

        private static bool Overlaps(TimeSpan startA, TimeSpan endA, TimeSpan startB, TimeSpan endB)
            => !(endA <= startB || endB <= startA);

        private void Notify(string icon, string title, string message)
        {
            string safeTitle = (title ?? "").Replace("'", "\\'");
            string safeMsg = (message ?? "").Replace("'", "\\'");
            string js = $@"
                Swal.fire({{
                    icon: '{icon}',
                    title: '{safeTitle}',
                    text: '{safeMsg}',
                    confirmButtonColor: '#00a077'
                }});";
            ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), js, true);
        }
    }
}
