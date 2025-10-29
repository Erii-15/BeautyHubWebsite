using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;

namespace WebApplication1
{
    public partial class Payment : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlLoginNotice.Visible = !IsLoggedIn();
                BindCart();
            }
        }

        private bool IsLoggedIn()
        {
            return Session["CustomerID"] != null;
        }

        private void BindCart()
        {
            var cart = Session["Cart"] as List<Contact.Product>;

            if (cart == null || !cart.Any() || !IsLoggedIn())
            {
                pnlCartSummary.Visible = false;
                lblMessage.Text = !IsLoggedIn() ? "Please log in to see your cart." : "🛒 Your cart is empty.";
                return;
            }

            pnlCartSummary.Visible = true;
            rptCart.DataSource = cart;
            rptCart.DataBind();

            decimal total = cart.Sum(p => p.Promotion ? p.PromotionPrice * p.Quantity : p.Price * p.Quantity);
            lblTotal.Text = total.ToString("F2");
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            if (!IsLoggedIn())
            {
                Response.Redirect("~/Account/Login");
                return;
            }

            var cart = Session["Cart"] as List<Contact.Product>;
            if (cart == null || !cart.Any())
            {
                lblMessage.Text = "🛒 Your cart is empty!";
                return;
            }

            int customerId = Convert.ToInt32(Session["CustomerID"]);
            string paymentType = rblPaymentType.SelectedValue;
            string notes = "Website Sale";

            string connStr = "Server=146.230.177.46;Database=WstGrp14;User ID=WstGrp14;Password=ajqbd;";
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // 1️⃣ Insert Sale
                    string saleQuery = @"INSERT INTO SaleNEW (CustomerID, SaleDate, TotalAmount, PaymentType, Notes)
                                         VALUES (@CustomerID, @SaleDate, @TotalAmount, @PaymentType, @Notes);
                                         SELECT SCOPE_IDENTITY();";

                    decimal totalAmount = cart.Sum(p => p.Promotion ? p.PromotionPrice * p.Quantity : p.Price * p.Quantity);

                    SqlCommand cmdSale = new SqlCommand(saleQuery, conn, transaction);
                    cmdSale.Parameters.AddWithValue("@CustomerID", customerId);
                    cmdSale.Parameters.AddWithValue("@SaleDate", DateTime.Now);
                    cmdSale.Parameters.AddWithValue("@TotalAmount", totalAmount);
                    cmdSale.Parameters.AddWithValue("@PaymentType", paymentType);
                    cmdSale.Parameters.AddWithValue("@Notes", notes);

                    int saleId = Convert.ToInt32(cmdSale.ExecuteScalar());

                    // 2️⃣ Insert SaleItem and Update Stock
                    foreach (var item in cart)
                    {
                        decimal itemPrice = item.Promotion ? item.PromotionPrice : item.Price;

                        SqlCommand cmdItem = new SqlCommand(@"INSERT INTO SaleItemNEW
                            (SaleID, ProductID, Quantity, PriceAtSale, TotalItemPrice)
                            VALUES (@SaleID, @ProductID, @Quantity, @PriceAtSale, @TotalItemPrice)", conn, transaction);

                        cmdItem.Parameters.AddWithValue("@SaleID", saleId);
                        cmdItem.Parameters.AddWithValue("@ProductID", item.ProductID);
                        cmdItem.Parameters.AddWithValue("@Quantity", item.Quantity);
                        cmdItem.Parameters.AddWithValue("@PriceAtSale", itemPrice);
                        cmdItem.Parameters.AddWithValue("@TotalItemPrice", itemPrice * item.Quantity);

                        cmdItem.ExecuteNonQuery();

                        SqlCommand cmdUpdateStock = new SqlCommand(
                            "UPDATE ProductNEW SET QuantityInStock = QuantityInStock - @Qty WHERE ProductID = @ProductID",
                            conn, transaction);

                        cmdUpdateStock.Parameters.AddWithValue("@Qty", item.Quantity);
                        cmdUpdateStock.Parameters.AddWithValue("@ProductID", item.ProductID);
                        cmdUpdateStock.ExecuteNonQuery();
                    }

                    transaction.Commit();

                    Session["Cart"] = null;
                    lblMessage.Text = "✅ Your order has been placed successfully!";
                    pnlCartSummary.Visible = false;
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    lblMessage.Text = "❌ Error placing order: " + ex.Message;
                }
            }
        }

        // Helper function for repeater to calculate total per item
        public string GetItemTotal(object dataItem)
        {
            var item = (Contact.Product)dataItem;
            decimal total = item.Promotion ? item.PromotionPrice * item.Quantity : item.Price * item.Quantity;
            return total.ToString("F2");
        }
    }
}
