using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class _Default : System.Web.UI.Page
    {

        private const string CONN = "Server=146.230.177.46;Database=WstGrp14;User ID=WstGrp14;Password=ajqbd;";

        // ---- ViewModels ----
        private class ServiceVm
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

        private class ProductVm
        {
            public int ProductID { get; set; }
            public string ProductName { get; set; }
            public string Description { get; set; }
            public decimal Price { get; set; }
            public bool Promotion { get; set; }
            public decimal PromotionPrice { get; set; }
            public string ImageUrl { get; set; } 
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindFeaturedServices();
                BindFeaturedProducts();
            }
        }
        // ---- Data binding ----
        private void BindFeaturedServices()
        {
            var items = new List<ServiceVm>();
            using (var conn = new SqlConnection(CONN))
            using (var cmd = new SqlCommand(@"
                SELECT TOP 3
                    ServiceID, ServiceName, Description, Price, Promotion,
                    PromotionPrice, DurationMinutes, ImagePath
                FROM ServiceNEW
                WHERE IsActive = 1
                ORDER BY
                    CASE WHEN Promotion=1 THEN 0 ELSE 1 END,  -- promos first
                    ServiceID ASC;", conn))
            {
                conn.Open();
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        items.Add(new ServiceVm
                        {
                            ServiceID = Convert.ToInt32(r["ServiceID"]),
                            ServiceName = r["ServiceName"]?.ToString() ?? "",
                            Description = r["Description"]?.ToString() ?? "",
                            Price = r["Price"] != DBNull.Value ? Convert.ToDecimal(r["Price"]) : 0m,
                            Promotion = r["Promotion"] != DBNull.Value && Convert.ToBoolean(r["Promotion"]),
                            PromotionPrice = r["PromotionPrice"] != DBNull.Value ? Convert.ToDecimal(r["PromotionPrice"]) : 0m,
                            DurationMinutes = r["DurationMinutes"] != DBNull.Value ? Convert.ToInt32(r["DurationMinutes"]) : 0,
                            ImagePath = r["ImagePath"] != DBNull.Value ? r["ImagePath"].ToString() : null
                        });
                    }
                }
            }

            rptFeaturedServices.DataSource = items;
            rptFeaturedServices.DataBind();
        }

        private void BindFeaturedProducts()
        {
            var items = new List<ProductVm>();
            using (var conn = new SqlConnection(CONN))
            using (var cmd = new SqlCommand(@"
                SELECT TOP 3
                    ProductID, ProductName, Description, Price, Promotion,
                    PromotionPrice, Image
                FROM ProductNEW
                WHERE isActive = 1 AND QuantityInStock > 0
                ORDER BY
                    CASE WHEN Promotion=1 THEN 0 ELSE 1 END,
                    ProductID ASC;", conn))
            {
                conn.Open();
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        items.Add(new ProductVm
                        {
                            ProductID = Convert.ToInt32(r["ProductID"]),
                            ProductName = r["ProductName"]?.ToString() ?? "",
                            Description = r["Description"]?.ToString() ?? "",
                            Price = r["Price"] != DBNull.Value ? Convert.ToDecimal(r["Price"]) : 0m,
                            Promotion = r["Promotion"] != DBNull.Value && Convert.ToBoolean(r["Promotion"]),
                            PromotionPrice = r["PromotionPrice"] != DBNull.Value ? Convert.ToDecimal(r["PromotionPrice"]) : 0m,
                            ImageUrl = r["Image"] != DBNull.Value ? r["Image"].ToString() : null
                        });
                    }
                }
            }

            rptFeaturedProducts.DataSource = items;
            rptFeaturedProducts.DataBind();
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