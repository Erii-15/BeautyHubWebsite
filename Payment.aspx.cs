using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication1
{
    public partial class Checkout : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCart();
            }
        }

        private void BindCart()
        {
            var cart = Session["Cart"] as List<Contact.Product>;
            if (cart != null && cart.Count > 0)
            {
                rptCart.DataSource = cart;
                rptCart.DataBind();

                decimal total = 0;
                foreach (var item in cart)
                {
                    total += item.Promotion ? item.PromotionPrice * item.Quantity : item.Price * item.Quantity;
                }
                lblTotal.Text = total.ToString("F2");
            }
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            var cart = Session["Cart"] as List<Contact.Product>;
            if (cart == null || cart.Count == 0)
            {
                lblMessage.Text = "Cart is empty!";
                return;
            }

            // int? customerId = Session["CustomerID"] as int?;

            //if (customerId == null)
            //{
            //    lblMessage.Text = "You must be logged in to place an order.";
            //    return;
            //}
            int? customerId = 223046;



            string paymentType = rblPaymentType.SelectedValue; // Assume you added a RadioButtonList for payment type
            string notes = "Website Sale";

            string connStr = "Server=146.230.177.46;Database=WstGrp14;User ID=WstGrp14;Password=ajqbd;";
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // 1. Insert SaleNEW
                    string saleQuery = @"INSERT INTO SaleNEW (CustomerID, SaleDate, TotalAmount, PaymentType, Notes)
                                         VALUES (@CustomerID, @SaleDate, @TotalAmount, @PaymentType, @Notes);
                                         SELECT SCOPE_IDENTITY();";

                    decimal totalAmount = 0;
                    foreach (var item in cart)
                        totalAmount += item.Promotion ? item.PromotionPrice * item.Quantity : item.Price * item.Quantity;

                    SqlCommand cmdSale = new SqlCommand(saleQuery, conn, transaction);
                    cmdSale.Parameters.AddWithValue("@CustomerID", customerId);     
                    cmdSale.Parameters.AddWithValue("@SaleDate", DateTime.Now);
                    cmdSale.Parameters.AddWithValue("@TotalAmount", totalAmount);
                    cmdSale.Parameters.AddWithValue("@PaymentType", paymentType);
                    cmdSale.Parameters.AddWithValue("@Notes", notes);
                    int saleId = Convert.ToInt32(cmdSale.ExecuteScalar());

                    // 2. Insert SaleItemNEW and update stock
                    foreach (var item in cart)
                    {
                        string itemQuery = @"INSERT INTO SaleItemNEW (SaleID, ProductID, Quantity, PriceAtSale, TotalItemPrice)
                         VALUES (@SaleID, @ProductID, @Quantity, @PriceAtSale, @TotalItemPrice)";
                        SqlCommand cmdItem = new SqlCommand(itemQuery, conn, transaction);
                        decimal itemPrice = item.Promotion ? item.PromotionPrice : item.Price;

                        cmdItem.Parameters.AddWithValue("@SaleID", saleId);
                        cmdItem.Parameters.AddWithValue("@ProductID", item.ProductID);
                        cmdItem.Parameters.AddWithValue("@Quantity", item.Quantity);
                        cmdItem.Parameters.AddWithValue("@PriceAtSale", itemPrice);   
                        cmdItem.Parameters.AddWithValue("@TotalItemPrice", itemPrice * item.Quantity);

                        cmdItem.ExecuteNonQuery();

                        // Update stock
                        string updateStock = "UPDATE ProductNEW SET QuantityInStock = QuantityInStock - @Qty WHERE ProductID = @ProductID";
                        SqlCommand cmdUpdate = new SqlCommand(updateStock, conn, transaction);
                        cmdUpdate.Parameters.AddWithValue("@Qty", item.Quantity);
                        cmdUpdate.Parameters.AddWithValue("@ProductID", item.ProductID);
                        cmdUpdate.ExecuteNonQuery();
                    }

                    transaction.Commit();
                    Session["Cart"] = null;
                    lblMessage.Text = "✅ Order placed successfully!";
                    BindCart();
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    lblMessage.Text = "❌ Error placing order: " + ex.Message;
                }
            }
        }
    }
}
