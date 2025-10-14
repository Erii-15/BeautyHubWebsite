<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="WebApplication1.Checkout" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h2>🛒 Checkout</h2>

    <!-- Cart Summary -->
    <asp:Panel ID="pnlCartSummary" runat="server">
        <h3>Order Summary</h3>
        <asp:Repeater ID="rptCart" runat="server">
            <HeaderTemplate>
                <table class="table">
                    <tr>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Price (R)</th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%# Eval("ProductName") %></td>
                    <td><%# Eval("Quantity") %></td>
                    <td>
                        <%# (Convert.ToBoolean(Eval("Promotion")) 
                                ? Convert.ToDecimal(Eval("PromotionPrice")) * Convert.ToInt32(Eval("Quantity")) 
                                : Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Quantity"))) %>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>

        <h4>Total: R<asp:Label ID="lblTotal" runat="server"></asp:Label></h4>
    </asp:Panel>

    <hr />

    <!-- Payment Type -->
    <h3>Payment Type</h3>
    <asp:RadioButtonList ID="rblPaymentType" runat="server">
        <asp:ListItem Text="Credit Card" Value="Credit Card" Selected="True" />
        <asp:ListItem Text="EFT / Bank Transfer" Value="EFT" />
        <asp:ListItem Text="Cash on Delivery" Value="Cash" />
    </asp:RadioButtonList>

    <div class="mt-3">
        <asp:Button ID="btnPlaceOrder" runat="server" Text="Place Order" CssClass="btn btn-primary" OnClick="btnPlaceOrder_Click" />
    </div>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>

    <style>
        .table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .table th, .table td { padding: 10px; border: 1px solid #ddd; text-align: center; }
        .btn-primary { background-color:#00a077; color:white; padding:10px 20px; border:none; border-radius:5px; cursor:pointer; }
        .btn-primary:hover { background-color:#00905f; }
        .form-control { width: 100%; padding: 8px; margin-top: 5px; margin-bottom: 10px; }
        .mt-3 { margin-top: 15px; }
    </style>

</asp:Content>
