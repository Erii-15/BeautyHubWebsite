using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication1.Account
{
    public partial class Login : Page
    {
        protected void LogIn(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            string username = Username.Text.Trim();
            string password = Password.Text.Trim();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT CustomerID FROM CustomerNEW WHERE Username = @Username AND Password = @Password";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.HasRows)
                {
                    reader.Read();
                    int customerId = Convert.ToInt32(reader["CustomerID"]);

                    // Store CustomerID in session
                    Session["CustomerID"] = customerId;

                    // Optionally, store other user details in session
                    Session["Username"] = username;

                    // Redirect to home page or dashboard
                    Response.Redirect("~/Default.aspx");
                }
                else
                {
                    // Display error message
                    FailureText.Text = "Invalid username or password.";
                    ErrorMessage.Visible = true;
                }
            }
        }

    }

    // Optional: helper to hash password (if DB stores hashed passwords)
    // private string ComputeSha256Hash(string rawData)
    // {
    //     using (var sha256 = System.Security.Cryptography.SHA256.Create())
    //     {
    //         byte[] bytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(rawData));
    //         StringBuilder builder = new StringBuilder();
    //         for (int i = 0; i < bytes.Length; i++)
    //         {
    //             builder.Append(bytes[i].ToString("x2"));
    //         }
    //         return builder.ToString();
    //     }
    // }
}

