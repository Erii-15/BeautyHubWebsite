using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class Contact : Page
    {
        public class Product
        {
            public int ProductID { get; set; }
            public string ProductName { get; set; }
            public string Description { get; set; }
            public string Category { get; set; }
            public decimal Price { get; set; }
            public bool Promotion { get; set; }
            public decimal PromotionPrice { get; set; }
            public int QuantityInStock { get; set; }
            public string ImageUrl { get; set; }
            public int Quantity { get; set; } = 1; // quantity user wants
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindProducts();
            }
        }

        private void BindProducts()
        {
            rptProducts.DataSource = GetProducts();
            rptProducts.DataBind();
            BindCategories();
        }

        private List<Product> GetProducts()
        {
            List<Product> products = new List<Product>();
            string connectionString = "Server=146.230.177.46;Database=WstGrp14;User ID=WstGrp14;Password=ajqbd;";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT ProductID, ProductName, Description, Price, Category, Promotion, PromotionPrice, QuantityInStock, Image FROM ProductNEW WHERE QuantityInStock>0 and isActive=1";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        products.Add(new Product
                        {
                            ProductID = Convert.ToInt32(reader["ProductID"]),
                            ProductName = reader["ProductName"]?.ToString() ?? "",
                            Description = reader["Description"]?.ToString() ?? "",
                            Price = Convert.ToDecimal(reader["Price"]),
                            Category = reader["Category"]?.ToString() ?? "",
                            Promotion = reader["Promotion"] != DBNull.Value && Convert.ToBoolean(reader["Promotion"]),
                            PromotionPrice = reader["PromotionPrice"] != DBNull.Value ? Convert.ToDecimal(reader["PromotionPrice"]) : 0m,
                            QuantityInStock = reader["QuantityInStock"] != DBNull.Value ? Convert.ToInt32(reader["QuantityInStock"]) : 0,
                            ImageUrl = reader["Image"]?.ToString() ?? "https://via.placeholder.com/300x200?text=No+Image"
                        });
                    }
                }
            }

            return products;
        }

        private void BindCategories()
        {
            string connectionString = "Server=146.230.177.46;Database=WstGrp14;User ID=WstGrp14;Password=ajqbd;";
            List<string> categories = new List<string>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT DISTINCT Category FROM ProductNEW WHERE Category IS NOT NULL";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                        categories.Add(reader["Category"].ToString());
                }
            }

            ddlProdCat.DataSource = categories;
            ddlProdCat.DataBind();
            ddlProdCat.Items.Insert(0, new ListItem("All", "all"));
        }

        protected void FilterProducts(object sender, EventArgs e)
        {
            var allProducts = GetProducts();

            // Category filter
            string selectedCategory = ddlProdCat.SelectedValue;
            if (!string.IsNullOrEmpty(selectedCategory) && selectedCategory != "all")
                allProducts = allProducts.Where(p => p.Category.Equals(selectedCategory, StringComparison.OrdinalIgnoreCase)).ToList();

            // Search filter
            string searchText = txtProdSearch.Text?.Trim().ToLower();
            if (!string.IsNullOrEmpty(searchText))
                allProducts = allProducts.Where(p => p.ProductName.ToLower().Contains(searchText)).ToList();

            // Sort filter
            switch (ddlSort.SelectedValue)
            {
                case "price-asc":
                    allProducts = allProducts.OrderBy(p => p.Promotion ? p.PromotionPrice : p.Price).ToList();
                    break;
                case "price-desc":
                    allProducts = allProducts.OrderByDescending(p => p.Promotion ? p.PromotionPrice : p.Price).ToList();
                    break;
                case "name-asc":
                    allProducts = allProducts.OrderBy(p => p.ProductName).ToList();
                    break;
                case "name-desc":
                    allProducts = allProducts.OrderByDescending(p => p.ProductName).ToList();
                    break;
                default:
                    break; // popular
            }

            rptProducts.DataSource = allProducts;
            rptProducts.DataBind();
        }

        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "AddToCart") return;

            int productId = Convert.ToInt32(e.CommandArgument);
            var selectedProduct = GetProducts().FirstOrDefault(p => p.ProductID == productId);
            if (selectedProduct == null) return;

            if (selectedProduct.QuantityInStock <= 0)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('{selectedProduct.ProductName} is out of stock!');", true);
                return;
            }

            // Retrieve cart from session
            List<Product> cart = Session["Cart"] as List<Product> ?? new List<Product>();

            // Check if product already in cart
            var cartItem = cart.FirstOrDefault(p => p.ProductID == productId);
            if (cartItem != null)
            {
                if (cartItem.Quantity < selectedProduct.QuantityInStock)
                    cartItem.Quantity++;
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Cannot add more than available stock!');", true);
                    return;
                }
            }
            else
            {
                cart.Add(selectedProduct);
            }

            Session["Cart"] = cart;

            // Popup
            ScriptManager.RegisterStartupScript(this, this.GetType(), "showPopup",
                $"showAddedPopup('{selectedProduct.ProductName.Replace("'", "\\'")}');", true);
        }
    }
}
