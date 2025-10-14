<%@ Page Title="Welcome" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication1._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div style="text-align:center; margin-top:100px;">
        <h1>Welcome to Our Website!</h1>
        <p>Use the menu above to navigate through products and your shopping cart.</p>
    </div>

    <style>
        h1 {
            color: #00a077;
            font-weight: bold;
            margin-bottom: 20px;
        }
        p {
            font-size: 1.2rem;
            color: #333;
        }
    </style>
</asp:Content>

