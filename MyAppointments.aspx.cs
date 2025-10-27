using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class MyAppointments : System.Web.UI.Page
    {

        private const string CONN = "Server=146.230.177.46;Database=WstGrp14;User ID=WstGrp14;Password=ajqbd;";
        // view model for binding
        public class AppointmentVm
        {
            public int AppointmentID { get; set; }
            public DateTime Date { get; set; }
            public TimeSpan StartTime { get; set; }
            public TimeSpan EndTime { get; set; }
            public string ServiceName { get; set; }
            public string StaffName { get; set; }
            public int Rating { get; set; }

            public string ImagePath { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // must be logged in
            if (Session["CustomerID"] == null)
            {
                string returnUrl = Server.UrlEncode(Request.RawUrl);
                Response.Redirect("~/Account/Login.aspx?returnUrl=" + returnUrl, true);
                return;
            }

            if (!IsPostBack)
            {
                BindAppointments();
            }
        }

        private void BindAppointments()
        {
            int custId = Convert.ToInt32(Session["CustomerID"]);

            // get server time for consistent "past vs upcoming" logic
            DateTime serverNow;
            using (var conn = new SqlConnection(CONN))
            using (var cmdNow = new SqlCommand("SELECT GETDATE()", conn))
            {
                conn.Open();
                serverNow = (DateTime)cmdNow.ExecuteScalar();
            }

            DateTime nowDate = serverNow.Date;
            TimeSpan nowTime = serverNow.TimeOfDay;

            // grab all appts for this customer
            var appts = LoadAppointmentsForCustomer(custId);

            // split into upcoming vs past using end time math
            var upcomingList = new List<AppointmentVm>();
            var pastList = new List<AppointmentVm>();

            foreach (var a in appts)
            {
                bool isUpcoming =
                    (a.Date > nowDate) ||
                    (a.Date == nowDate && a.EndTime > nowTime);

                if (isUpcoming)
                    upcomingList.Add(a);
                else
                    pastList.Add(a);
            }

            // bind
            rptUpcoming.DataSource = upcomingList;
            rptUpcoming.DataBind();
            pnlUpcomingEmpty.Visible = (upcomingList.Count == 0);

            rptPast.DataSource = pastList;
            rptPast.DataBind();
            pnlPastEmpty.Visible = (pastList.Count == 0);
        }

        private List<AppointmentVm> LoadAppointmentsForCustomer(int customerId)
        {
            var list = new List<AppointmentVm>();

            using (var conn = new SqlConnection(CONN))
            using (var cmd = new SqlCommand(@"
                SELECT 
                    a.AppointmentID,
                    a.Date,
                    a.Time,
                    a.Rating,
                    s.ServiceName,
                    s.DurationMinutes,
                    s.ImagePath,
                    COALESCE(NULLIF(LTRIM(RTRIM(CONCAT(st.FirstName,' ',st.LastName))),''), 
                             CAST(st.StaffID AS varchar(20))) AS StaffName
                FROM AppointmentNEW a
                JOIN ServiceNEW s ON s.ServiceID = a.ServiceID
                JOIN StaffNEW st ON st.StaffID = a.StaffID
                WHERE a.CustomerID = @cust
                ORDER BY a.Date DESC, a.Time DESC;", conn))
            {
                cmd.Parameters.AddWithValue("@cust", customerId);
                conn.Open();

                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        DateTime d = Convert.ToDateTime(r["Date"]).Date;
                        TimeSpan start = (TimeSpan)r["Time"];
                        int dur = Convert.ToInt32(r["DurationMinutes"]);
                        TimeSpan end = start.Add(TimeSpan.FromMinutes(dur));

                        list.Add(new AppointmentVm
                        {
                            AppointmentID = Convert.ToInt32(r["AppointmentID"]),
                            Date = d,
                            StartTime = start,
                            EndTime = end,
                            Rating = r["Rating"] != DBNull.Value ? Convert.ToInt32(r["Rating"]) : 0,
                            ServiceName = r["ServiceName"]?.ToString() ?? "",
                            StaffName = r["StaffName"]?.ToString() ?? "",
                            ImagePath = r["ImagePath"]?.ToString() ?? ""

                        });
                    }
                }
            }

            return list;
        }

        // Handle rating submission
        protected void rptPast_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Rate")
            {
                // which appointment row
                int apptId = Convert.ToInt32(e.CommandArgument);

                // find the rating dropdown in this row
                DropDownList ddl = (DropDownList)e.Item.FindControl("ddlRating");
                if (ddl == null) return;

                int newRating = Convert.ToInt32(ddl.SelectedValue);
                if (newRating < 1 || newRating > 5)
                {
                    // invalid selection or "Select…"
                    // no SweetAlert here since this is a postback-only page,
                    // but we COULD add ClientScript alert if you want
                    return;
                }

                int custId = Convert.ToInt32(Session["CustomerID"]);

                // update DB safely (only this user's appt)
                using (var conn = new SqlConnection(CONN))
                using (var cmd = new SqlCommand(@"
                    UPDATE AppointmentNEW
                    SET Rating = @rating
                    WHERE AppointmentID = @id
                      AND CustomerID = @cust;", conn))
                {
                    cmd.Parameters.AddWithValue("@rating", newRating);
                    cmd.Parameters.AddWithValue("@id", apptId);
                    cmd.Parameters.AddWithValue("@cust", custId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // refresh lists so UI updates
                BindAppointments();
            }
        }

        // helper so we can show stars nicely in markup
        protected string RenderStars(int rating)
        {
            if (rating < 1) rating = 1;
            if (rating > 5) rating = 5;
            // simple: return ★★★☆☆ style
            string filled = new string('★', rating);
            string empty = new string('☆', 5 - rating);
            return filled + empty;
        }

        protected string ResolveImageUrl(object pathObj)
        {
            string path = pathObj as string;
            if (string.IsNullOrWhiteSpace(path))
                return "https://via.placeholder.com/150x100?text=No+Image";

            if (path.StartsWith("http", StringComparison.OrdinalIgnoreCase))
                return path;

            if (path.StartsWith("~") || path.StartsWith("/"))
                return ResolveUrl(path);

            return ResolveUrl("~/Images/" + path);
        }



    }
}