using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class Services : System.Web.UI.Page
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
            public string ImagePath { get; set; }
        }

        private class UpcomingVm
        {
            public DateTime Date { get; set; }
            public TimeSpan Start { get; set; }
            public int DurationMinutes { get; set; }
            public string ServiceName { get; set; }
            public string StaffName { get; set; }
        }



        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindServices(); 
                
                rptServices.DataSource = GetServices();
                rptServices.DataBind();

                pnlLoginNotice.Visible = !IsLoggedIn();
            }


        }

        private void BindServices()
        {
            List<ServiceVm> services = new List<ServiceVm>();

            using (SqlConnection conn = new SqlConnection(CONN))
            {
                string query = @"SELECT ServiceID, ServiceName, Description, Price, Promotion, 
                                PromotionPrice, DurationMinutes 
                         FROM ServiceNEW 
                         WHERE IsActive = 1";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        services.Add(new ServiceVm
                        {
                            ServiceID = Convert.ToInt32(reader["ServiceID"]),
                            ServiceName = reader["ServiceName"].ToString(),
                            Description = reader["Description"].ToString(),
                            Price = reader["Price"] != DBNull.Value ? Convert.ToDecimal(reader["Price"]) : 0m,
                            Promotion = reader["Promotion"] != DBNull.Value && Convert.ToBoolean(reader["Promotion"]),
                            PromotionPrice = reader["PromotionPrice"] != DBNull.Value ? Convert.ToDecimal(reader["PromotionPrice"]) : 0m,
                            DurationMinutes = reader["DurationMinutes"] != DBNull.Value ? Convert.ToInt32(reader["DurationMinutes"]) : 0
                        });
                    }
                }
            }

            rptServices.DataSource = services;
            rptServices.DataBind();
        }




        private bool IsLoggedIn()
        {
            // when you hook up auth, set Session["CustomerID"] on login
            return Session["CustomerID"] != null;
        }

        private decimal EffectivePrice(ServiceVm s)
        {
            return (s.Promotion && s.PromotionPrice > 0) ? s.PromotionPrice : s.Price;
        }

        protected void FilterServices(object sender, EventArgs e)
        {
            
            var services = GetServices(); 

            // 2) Search by name 
            string q = (txtSvcSearch.Text ?? "").Trim().ToLower();
            if (!string.IsNullOrEmpty(q))
            {
                services = services
                    .Where(s => (s.ServiceName ?? "").ToLower().Contains(q))
                    .ToList();
            }

            // 3) Sort
            switch (ddlSvcSort.SelectedValue)
            {
                case "price-asc":
                    services = services.OrderBy(s => EffectivePrice(s)).ToList();
                    break;

                case "price-desc":
                    services = services.OrderByDescending(s => EffectivePrice(s)).ToList();
                    break;

                case "dur-asc":
                    services = services.OrderBy(s => s.DurationMinutes).ToList();
                    break;

                case "dur-desc":
                    services = services.OrderByDescending(s => s.DurationMinutes).ToList();
                    break;

                case "name-asc":
                    services = services.OrderBy(s => s.ServiceName).ToList();
                    break;

                default:
                    
                    break;
            }

            rptServices.DataSource = services;
            rptServices.DataBind();

        
            
        }

        private List<ServiceVm> GetServices()
        {
            var list = new List<ServiceVm>();
            using (var conn = new SqlConnection(CONN))
            using (var cmd = new SqlCommand(@"
        SELECT ServiceID, ServiceName, Description, Price, Promotion,
               PromotionPrice, DurationMinutes, ImagePath
        FROM ServiceNEW
        WHERE IsActive = 1;", conn))
            {
                conn.Open();
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        list.Add(new ServiceVm
                        {
                            ServiceID = Convert.ToInt32(r["ServiceID"]),
                            ServiceName = r["ServiceName"]?.ToString() ?? "",
                            Description = r["Description"]?.ToString() ?? "",
                            Price = r["Price"] != DBNull.Value ? Convert.ToDecimal(r["Price"]) : 0m,
                            Promotion = r["Promotion"] != DBNull.Value && Convert.ToBoolean(r["Promotion"]),
                            PromotionPrice = r["PromotionPrice"] != DBNull.Value ? Convert.ToDecimal(r["PromotionPrice"]) : 0m,
                            DurationMinutes = r["DurationMinutes"] != DBNull.Value ? Convert.ToInt32(r["DurationMinutes"]) : 0,
                            // IMPORTANT: DBNull-safe mapping (do NOT call .ToString() on DBNull)
                            ImagePath = r["ImagePath"] != DBNull.Value ? Convert.ToString(r["ImagePath"]) : null
                        });
                    }
                }
            }
            return list;
        }


        protected string GetImageUrl(object pathObj)
        {
            var path = pathObj as string;

            if (string.IsNullOrWhiteSpace(path))
                return "https://via.placeholder.com/600x360?text=No+Image";

            if (path.StartsWith("http", StringComparison.OrdinalIgnoreCase))
                return path;

            if (path.StartsWith("~") || path.StartsWith("/"))
                return ResolveUrl(path);

            return ResolveUrl("~/" + path);
        }


    }
}