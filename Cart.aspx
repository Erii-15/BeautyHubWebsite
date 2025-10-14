<%@ Page Title="Shopping Cart" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="WebApplication1.Cart" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .table th, .table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        .table th { background-color: #00a077; color: white; }

        .btn-danger, .btn-primary { padding:6px 12px; border-radius:5px; border:none; cursor:pointer; }
        .btn-danger { background-color:#e74c3c; color:white; }
        .btn-danger:hover { background-color:#c0392b; }
        .btn-primary { background-color:#00a077; color:white; }
        .btn-primary:hover { background-color:#00905f; }

        .text-end { text-align:right; margin-top:20px; }
        .fw-bold { font-weight:bold; }

        #cartPopup {
            position: fixed; top:50%; left:50%;
            transform:translate(-50%, -50%);
            background:white; padding:20px 40px; border-radius:10px;
            box-shadow:0 5px 20px rgba(0,0,0,0.3);
            color:#2c3e50; font-size:18px; text-align:center;
            display:none; z-index:9999; animation:fadeInOut 2s ease-in-out forwards;
        }
        @keyframes fadeInOut {
            0% {opacity:0; transform:translate(-50%,-60%);}
            20% {opacity:1; transform:translate(-50%,-50%);}
            80% {opacity:1; transform:translate(-50%,-50%);}
            100% {opacity:0; transform:translate(-50%,-40%);}
        }
    </style>

    <main>
        <h2>🛒 Your Shopping Cart</h2>

        <asp:GridView ID="CartGrid" runat="server" AutoGenerateColumns="False" CssClass="table"
            OnRowCommand="CartGrid_RowCommand">
            <Columns>
                <asp:BoundField DataField="ProductName" HeaderText="Product" />
                <asp:BoundField DataField="Category" HeaderText="Category" />

                <asp:TemplateField HeaderText="Price (R)">
                    <ItemTemplate>
                        <%# Convert.ToBoolean(Eval("Promotion")) ?
                            $"<span style='text-decoration:line-through;color:#999;'>R{Eval("Price", "{0:F2}")}</span> <span style='color:#e74c3c;font-weight:bold;'>R{Eval("PromotionPrice", "{0:F2}")}</span>"
                            : $"R{Eval("Price", "{0:F2}")}" %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Quantity">
                    <ItemTemplate>
                        <div style="display:flex; justify-content:center; align-items:center; gap:5px;">
                            <asp:Button ID="btnDecrease" runat="server" Text="-" CommandName="DecreaseQty" 
                                CommandArgument='<%# Eval("ProductID") %>' CssClass="btn-primary btn-sm" />
                            <asp:Label ID="lblQty" runat="server" Text='<%# Eval("Quantity") %>' Width="30px" CssClass="text-center"></asp:Label>
                            <asp:Button ID="btnIncrease" runat="server" Text="+" CommandName="IncreaseQty" 
                                CommandArgument='<%# Eval("ProductID") %>' CssClass="btn-primary btn-sm" />
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:Button ID="btnRemove" runat="server" Text="Remove" 
                            CommandName="RemoveItem" CommandArgument='<%# Eval("ProductID") %>'
                            CssClass="btn-danger" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <h4 class="text-end mt-3">
            <asp:Label ID="lblTotal" runat="server" CssClass="fw-bold text-success"></asp:Label>
        </h4>

        <div class="text-end mt-3">
            <asp:Button ID="btnContinue" runat="server" Text="Continue Shopping" CssClass="btn-primary" 
                OnClientClick="window.location='Products.aspx'; return false;" />
            <asp:Button ID="btnCheckout" runat="server" Text="Checkout" CssClass="btn-primary" />
        </div>

        <div id="cartPopup"></div>
    </main>

    <script>
        function showCartPopup(message) {
            const popup = document.getElementById("cartPopup");
            popup.innerHTML = message;
            popup.style.display = "block";
            setTimeout(() => { popup.style.display = "none"; }, 2000);
        }
    </script>

</asp:Content>
