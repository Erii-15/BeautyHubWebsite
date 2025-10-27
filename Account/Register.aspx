<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WebApplication1.Account.Register" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <main aria-labelledby="title">
        <h2 id="title"><%: Title %></h2>
        <p class="text-danger">
            <asp:Literal runat="server" ID="ErrorMessage" />
        </p>
        <h4>Create a new account</h4>
        <hr />
        <asp:ValidationSummary runat="server" CssClass="text-danger" />

        <!-- First Name -->
        <div class="row mb-3">
            <asp:Label runat="server" AssociatedControlID="FirstName" CssClass="col-md-2 col-form-label">First Name</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="FirstName" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="FirstName"
                    CssClass="text-danger" ErrorMessage="First name is required." />
            </div>
        </div>

        <!-- Last Name -->
        <div class="row mb-3">
            <asp:Label runat="server" AssociatedControlID="LastName" CssClass="col-md-2 col-form-label">Last Name</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="LastName" CssClass="form-control" />
            </div>
        </div>

        <!-- Phone Number -->
        <div class="row mb-3">
            <asp:Label runat="server" AssociatedControlID="Phone" CssClass="col-md-2 col-form-label">Phone</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="Phone" CssClass="form-control" onblur="validatePhone()" />
                <span id="phoneError" class="text-danger"></span>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Phone"
                    CssClass="text-danger" ErrorMessage="Phone number is required." />
                <asp:RegularExpressionValidator runat="server" ControlToValidate="Phone"
                    CssClass="text-danger" ErrorMessage="Please enter a valid 10-digit phone number."
                    ValidationExpression="^\d{10}$" />
            </div>
        </div>

        <!-- Email -->
        <div class="row mb-3">
            <asp:Label runat="server" AssociatedControlID="Email" CssClass="col-md-2 col-form-label">Email</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="Email" CssClass="form-control" TextMode="Email" onblur="validateEmail()" />
                <span id="emailError" class="text-danger"></span>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Email"
                    CssClass="text-danger" ErrorMessage="Email is required." />
                <asp:RegularExpressionValidator runat="server" ControlToValidate="Email"
                    CssClass="text-danger" ErrorMessage="Please enter a valid email address."
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
            </div>
        </div>

        <!-- Username -->
        <div class="row mb-3">
            <asp:Label runat="server" AssociatedControlID="Username" CssClass="col-md-2 col-form-label">Username</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="Username" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Username"
                    CssClass="text-danger" ErrorMessage="Username is required." />
            </div>
        </div>

        <!-- Password -->
        <div class="row mb-3">
            <asp:Label runat="server" AssociatedControlID="Password" CssClass="col-md-2 col-form-label">Password</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control" onblur="validatePassword()" />
                <span id="passwordError" class="text-danger"></span>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Password"
                    CssClass="text-danger" ErrorMessage="Password is required." />
                <asp:RegularExpressionValidator runat="server" ControlToValidate="Password"
                    CssClass="text-danger"
                    ErrorMessage="Password must be at least 6 characters, include 1 uppercase, 1 lowercase, and 2 digits."
                    ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=(?:.*\d){2,}).{6,}$" />
            </div>
        </div>

        <!-- Confirm Password -->
        <div class="row mb-3">
            <asp:Label runat="server" AssociatedControlID="ConfirmPassword" CssClass="col-md-2 col-form-label">Confirm Password</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="ConfirmPassword" TextMode="Password" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="ConfirmPassword"
                    CssClass="text-danger" Display="Dynamic" ErrorMessage="Confirm password is required." />
                <asp:CompareValidator runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword"
                    CssClass="text-danger" Display="Dynamic" ErrorMessage="Passwords do not match." />
            </div>
        </div>

        <!-- Register Button -->
        <div class="row mb-3">
            <div class="offset-md-2 col-md-10">
                <asp:Button runat="server" OnClick="CreateUser_Click" Text="Register" CssClass="btn btn-outline-dark" />
            </div>
        </div>

        <!-- Login Link -->
        <div class="text-center mt-3">
            Already have an account? <asp:HyperLink runat="server" NavigateUrl="~/Account/Login.aspx">Login</asp:HyperLink>
        </div>

    </main>

    <!-- Client-side JavaScript -->
    <script>
        function validatePhone() {
            var phone = document.getElementById('<%= Phone.ClientID %>').value;
        var errorSpan = document.getElementById('phoneError');

        if (!/^\d{10}$/.test(phone)) {
            errorSpan.innerText = "Please enter a valid 10-digit phone number.";
        } else {
            errorSpan.innerText = "";
        }
    }

    function validateEmail() {
        var email = document.getElementById('<%= Email.ClientID %>').value;
        var errorSpan = document.getElementById('emailError');

        var regex = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
        if (!regex.test(email)) {
            errorSpan.innerText = "Please enter a valid email address.";
        } else {
            errorSpan.innerText = "";
        }
    }

    function validatePassword() {
        var password = document.getElementById('<%= Password.ClientID %>').value;
            var errorSpan = document.getElementById('passwordError');

            var regex = /^(?=.*[a-z])(?=.*[A-Z])(?=(?:.*\d){2,}).{6,}$/;
            if (!regex.test(password)) {
                errorSpan.innerText = "Password must be at least 6 characters, include 1 uppercase, 1 lowercase, and 2 digits.";
            } else {
                errorSpan.innerText = "";
            }
        }
    </script>

</asp:Content>

