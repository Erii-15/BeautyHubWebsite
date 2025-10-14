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
                BindCart();
            }
        }

        private void BindCart()
        {
            List<Contact.Product> cart = Session["Cart"] as List<Contact.Product> ?? new List<Contact.Product>();
            CartGrid.DataSource = cart;
            CartGrid.DataBind();

            decimal total = cart.Sum(p => p.Promotion ? p.PromotionPrice * p.Quantity : p.Price * p.Quantity);
            lblTotal.Text = "Total: R" + total.ToString("F2");
        }

        protected void CartGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);
            List<Contact.Product> cart = Session["Cart"] as List<Contact.Product>;

            if (cart == null) return;

            var item = cart.FirstOrDefault(p => p.ProductID == productId);
            if (item == null) return;

            switch (e.CommandName)
            {
                case "RemoveItem":
                    cart.Remove(item);
                    Session["Cart"] = cart;
                    BindCart();
                    break;

                case "IncreaseQty":
                    item.Quantity++;
                    Session["Cart"] = cart;
                    BindCart();
                    break;

                case "DecreaseQty":
                    if (item.Quantity > 1)
                    {
                        item.Quantity--;
                        Session["Cart"] = cart;
                        BindCart();
                    }
                    break;
            }
        }
    }
}
