using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication1.Account
{
    public partial class Register : Page
    {
        protected void CreateUser_Click(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            string firstName = FirstName.Text.Trim();
            string lastName = LastName.Text.Trim();
            string phone = Phone.Text.Trim();
            string email = Email.Text.Trim();
            string notes = "website user";
            string username = Username.Text.Trim();
            string password = Password.Text.Trim(); // optional: hash if needed

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO CustomerNEW (FirstName, LastName, Phone, Email,Notes, Username, Password, IsActive) " +
                               "VALUES (@FirstName, @LastName, @Phone, @Email,@Notes, @Username, @Password, 1)";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@FirstName", firstName);
                cmd.Parameters.AddWithValue("@LastName", lastName);
                cmd.Parameters.AddWithValue("@Phone", phone);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Notes", notes);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password);

                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();

                    // Redirect to login page after successful registration
                    Response.Redirect("~/Account/Login.aspx");
                }
                catch (Exception ex)
                {
                    ErrorMessage.Text = "Error: " + ex.Message;
                }
            }
        }
    }
}
