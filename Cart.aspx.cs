using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class Cart : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlLoginNotice.Visible = !IsLoggedIn(); // show login notice if not logged in
                BindCart();
            }
        }

        private bool IsLoggedIn()
        {
            return Session["CustomerID"] != null; // same login check as Products
        }

        private void BindCart()
        {
            List<Contact.Product> cart = Session["Cart"] as List<Contact.Product> ?? new List<Contact.Product>();

            // Hide cart grid and checkout if not logged in
            CartGrid.Visible = btnCheckout.Visible = IsLoggedIn() && cart.Any();
            lblEmpty.Visible = !IsLoggedIn() || !cart.Any(); // show empty / login notice

            if (!cart.Any() || !IsLoggedIn()) return;

            CartGrid.DataSource = cart;
            CartGrid.DataBind();

            decimal total = cart.Sum(p => p.Promotion ? p.PromotionPrice * p.Quantity : p.Price * p.Quantity);
            lblTotal.Text = "Total: R" + total.ToString("F2");
        }

        protected void CartGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (!IsLoggedIn())
            {
                Response.Redirect("~/Account/Login");
                return;
            }

            int productId = Convert.ToInt32(e.CommandArgument);
            List<Contact.Product> cart = Session["Cart"] as List<Contact.Product>;
            if (cart == null) return;

            var item = cart.FirstOrDefault(p => p.ProductID == productId);
            if (item == null) return;

            switch (e.CommandName)
            {
                case "RemoveItem":
                    cart.Remove(item);
                    break;
                case "IncreaseQty":
                    if (item.Quantity < item.QuantityInStock)
                        item.Quantity++;
                    break;
                case "DecreaseQty":
                    if (item.Quantity > 1)
                        item.Quantity--;
                    break;
            }

            Session["Cart"] = cart;
            BindCart();
        }
    }
}
