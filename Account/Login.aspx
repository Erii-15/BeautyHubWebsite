<%@ Page Title="Log in" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Login.aspx.cs" Inherits="WebApplication1.Account.Login" Async="true" %>

<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <style>
        body {
            background: linear-gradient(135deg, #ffb6c1, #ff69b4, #ff1493);
            background-size: 300% 300%;
            animation: gradientMove 10s ease infinite;
        }

        @keyframes gradientMove {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .login-card {
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            width: 400px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .login-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }

        .btn-pink {
            background-color: #ff69b4;
            border: none;
            color: white;
            transition: background 0.3s ease, box-shadow 0.3s ease;
        }

        .btn-pink:hover {
            background-color: #ff1493;
            box-shadow: 0 0 15px rgba(255, 105, 180, 0.5);
        }

        .form-control:focus {
            border-color: #ff69b4;
            box-shadow: 0 0 5px rgba(255, 105, 180, 0.4);
        }

        .text-pink {
            color: #ff1493;
        }

        .small-link:hover {
            text-decoration: underline;
            color: #ff1493;
        }

        .text-danger {
            color: red;
        }
    </style>

    <div class="d-flex align-items-center justify-content-center vh-100">
        <div class="login-card p-4">
            <div class="text-center mb-4">
                <i class="bi bi-heart-fill text-pink" style="font-size: 3rem;"></i>
                <h3 class="mt-2 fw-bold text-pink">Welcome Back</h3>
                <p class="text-muted small">Log in to your account</p>
            </div>

            <!-- Error Message -->
            <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
                <div class="alert alert-danger text-center py-2">
                    <asp:Label runat="server" ID="FailureText" Text="" />
                </div>
            </asp:PlaceHolder>

            <!-- Username -->
            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="Username" CssClass="form-label fw-semibold">Username</asp:Label>
                <asp:TextBox runat="server" ID="Username" CssClass="form-control" placeholder="Enter your username" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Username" CssClass="text-danger small"
                    ErrorMessage="Username is required." />
            </div>

            <!-- Password -->
            <div class="mb-3 position-relative">
                <asp:Label runat="server" AssociatedControlID="Password" CssClass="form-label fw-semibold">Password</asp:Label>
                <div class="input-group">
                    <asp:TextBox runat="server" ID="Password" CssClass="form-control" TextMode="Password" placeholder="Enter your password" />
                    <button type="button" id="togglePassword" class="btn btn-outline-secondary">
                        <i class="bi bi-eye" id="toggleIcon"></i>
                    </button>
                </div>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" CssClass="text-danger small"
                    ErrorMessage="Password is required." />
            </div>

            <!-- Remember Me -->
            <div class="form-check mb-3">
                <asp:CheckBox runat="server" ID="RememberMe" CssClass="form-check-input" />
                <asp:Label runat="server" AssociatedControlID="RememberMe" CssClass="form-check-label">Remember me</asp:Label>
            </div>

            <!-- Log In Button -->
            <asp:Button runat="server" OnClick="LogIn" Text="Log In" CssClass="btn btn-pink w-100 fw-semibold mb-3" />

            <!-- Register Link -->
            <div class="text-center">
                <p class="small mb-1">
                    Don't have an account?
                    <asp:HyperLink runat="server" ID="RegisterHyperLink" NavigateUrl="~/Account/Register.aspx" CssClass="small-link fw-semibold text-pink">Register</asp:HyperLink>
                </p>
            </div>

            <hr class="my-4" />

            <!-- Social Login -->
            <div class="text-center">
                <p class="text-muted small mb-2">Or sign in with</p>
                <uc:OpenAuthProviders runat="server" ID="OpenAuthLogin" />
            </div>
        </div>
    </div>

    <!-- Password Show/Hide Script -->
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            const togglePassword = document.getElementById("togglePassword");
            const passwordField = document.getElementById("<%= Password.ClientID %>");
            const toggleIcon = document.getElementById("toggleIcon");

            togglePassword.addEventListener("click", function () {
                const type = passwordField.getAttribute("type") === "password" ? "text" : "password";
                passwordField.setAttribute("type", type);
                toggleIcon.classList.toggle("bi-eye");
                toggleIcon.classList.toggle("bi-eye-slash");
            });
        });
    </script>

</asp:Content>
