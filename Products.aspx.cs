using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    // This page displays all available products and allows users to add them to the cart.
    public partial class Contact : Page
    {
        // Inner class representing a Product object
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
            public int Quantity { get; set; } = 1; // default to 1 item when added to cart
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // This runs only when the page is first loaded — not on every button click.
            if (!IsPostBack)
            {
                BindProducts();
            }
        }

        // Retrieves the product list from the database and binds it to the Repeater
        private void BindProducts()
        {
            rptProducts.DataSource = GetProducts();
            rptProducts.DataBind();
            BindCategories();
        }

        // Fetch all products from database
        private List<Product> GetProducts()
        {
            List<Product> products = new List<Product>();

            // Your database connection string
            string connectionString = "Server=146.230.177.46;Database=WstGrp14;User ID=WstGrp14;Password=ajqbd;";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT ProductID, ProductName, Description, Price, Category, Promotion, PromotionPrice, QuantityInStock, Image FROM ProductNEW";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    // Loop through database rows and convert each into a Product object
                    while (reader.Read())
                    {
                        products.Add(new Product
                        {
                            ProductID = reader["ProductID"] != DBNull.Value ? Convert.ToInt32(reader["ProductID"]) : 0,
                            ProductName = reader["ProductName"]?.ToString() ?? "",
                            Description = reader["Description"]?.ToString() ?? "",
                            Price = reader["Price"] != DBNull.Value ? Convert.ToDecimal(reader["Price"]) : 0m,
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
                    {
                        categories.Add(reader["Category"].ToString());
                    }
                }
            }

            // Bind to DropDown
            ddlProdCat.DataSource = categories;
            ddlProdCat.DataBind();

            // Add "All" at the top
            ddlProdCat.Items.Insert(0, new System.Web.UI.WebControls.ListItem("All", "all"));
        }

        protected void FilterProducts(object sender, EventArgs e)
        {
            var allProducts = GetProducts();

            // ===== Category filter =====
            string selectedCategory = ddlProdCat.SelectedValue;
            if (!string.IsNullOrEmpty(selectedCategory) && selectedCategory != "all")
            {
                allProducts = allProducts
                    .Where(p => !string.IsNullOrEmpty(p.Category)
                                && p.Category.Equals(selectedCategory, StringComparison.OrdinalIgnoreCase))
                    .ToList();
            }

            // ===== Search filter =====
            string searchText = txtProdSearch.Text?.Trim().ToLower();
            if (!string.IsNullOrEmpty(searchText))
            {
                allProducts = allProducts
                    .Where(p => !string.IsNullOrEmpty(p.ProductName)
                                && p.ProductName.ToLower().Contains(searchText))
                    .ToList();
            }

            // ===== Sort filter =====
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
                    break; // "popular" - no sorting
            }

            // ===== Bind to repeater =====
            rptProducts.DataSource = allProducts;
            rptProducts.DataBind();
        }




        // Event fired when an "Add to Cart" button is clicked inside the Repeater
        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                int productId = Convert.ToInt32(e.CommandArgument);

                // Find the product that was clicked
                var selectedProduct = GetProducts().Find(p => p.ProductID == productId);

                if (selectedProduct != null)
                {
                    // Retrieve the user's cart from the Session, or create a new one
                    List<Product> cart = Session["Cart"] as List<Product> ?? new List<Product>();

                    // Add the product to the cart
                    cart.Add(selectedProduct);

                    // Save it back into Session
                    Session["Cart"] = cart;

                    // Trigger a nice popup (instead of an ugly alert)
                    ScriptManager.RegisterStartupScript(this, GetType(), "showPopup",
                        "showAddedPopup('" + selectedProduct.ProductName.Replace("'", "\\'") + "');", true);
                }
            }
        }
    }
}
