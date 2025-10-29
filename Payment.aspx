<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Payment.aspx.cs" Inherits="WebApplication1.Payment" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="checkout-container">

        <h2>🛒 Checkout</h2>

        <!-- LOGIN NOTICE PANEL -->
        <asp:Panel ID="pnlLoginNotice" runat="server" Visible="false" CssClass="login-notice">
            Please log in to place your order.
            <a href="~/Account/Login" runat="server" class="login-link">Log in</a>
        </asp:Panel>

        <!-- Cart Summary -->
        <asp:Panel ID="pnlCartSummary" runat="server" Visible="true" CssClass="cart-summary">
            <h3>Order Summary</h3>
            <asp:Repeater ID="rptCart" runat="server">
                <HeaderTemplate>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Quantity</th>
                                <th>Total (R)</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Eval("ProductName") %></td>
                        <td><%# Eval("Quantity") %></td>
                        <td><%# GetItemTotal(Container.DataItem) %></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>

            <div class="total-amount">
                <h4>Total: R<asp:Label ID="lblTotal" runat="server"></asp:Label></h4>
            </div>
        </asp:Panel>

        <hr class="divider" />

        <!-- Payment Type -->
        <h3>Payment Type</h3>
        <asp:RadioButtonList ID="rblPaymentType" runat="server" CssClass="form-control">
            <asp:ListItem Text="Credit Card" Value="Credit Card" Selected="True" />
            <asp:ListItem Text="EFT / Bank Transfer" Value="EFT" />
            <asp:ListItem Text="Cash on Delivery" Value="Cash" />
        </asp:RadioButtonList>

        <div class="mt-3">
            <asp:Button ID="btnPlaceOrder" runat="server" Text="Place Order" CssClass="btn btn-primary btn-place-order" OnClick="btnPlaceOrder_Click" />
        </div>

        <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true" CssClass="order-message"></asp:Label>

    </div>

    <style>
        .checkout-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            font-family: Arial, sans-serif;
        }

        h2, h3 { color: #2c3e50; }

        .login-notice {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
            padding: 10px 15px;
            border-radius: 6px;
            text-align: center;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .login-link { margin-left: 6px; font-weight: 700; color: #00a077; text-decoration: none; }
        .login-link:hover { text-decoration: underline; }

        .cart-summary { margin-bottom: 30px; }
        .table { width: 100%; border-collapse: collapse; margin-bottom: 15px; }
        .table th, .table td { padding: 12px; border: 1px solid #ddd; text-align: center; }
        .table th { background-color: #00a077; color: white; font-weight: bold; }
        .total-amount h4 { text-align: right; color: #00a077; font-weight: bold; }

        .divider { border: none; border-top: 2px solid #ddd; margin: 30px 0; }
        .form-control { width: 100%; padding: 10px; margin-top: 5px; margin-bottom: 15px; border-radius: 5px; border: 1px solid #ccc; }

        .btn-primary { background-color: #00a077; color: white; padding: 12px 25px; border: none; border-radius: 5px; cursor: pointer; font-weight: 600; transition: background 0.3s ease; }
        .btn-primary:hover { background-color: #00905f; }
        .btn-place-order { width: 100%; font-size: 16px; }
        .order-message { display: block; text-align: center; margin-top: 20px; font-size: 16px; }
    </style>

</asp:Content>
