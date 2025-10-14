<%@ Page Title="Product Catalog" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="WebApplication1.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h1 class="text-center mb-4">Product Catalog</h1>

    <!-- ===== FILTER BAR ===== -->
    <div class="products-filter">
        <div class="filter-item">
            <label for="ddlProdCat">Category</label>
            <asp:DropDownList ID="ddlProdCat" runat="server" CssClass="form-control"
                AutoPostBack="true" OnSelectedIndexChanged="FilterProducts">
                <asp:ListItem Text="All" Value="all" Selected="True" />
            </asp:DropDownList>
        </div>

        <div class="filter-item">
            <label for="ddlSort">Sort</label>
            <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-control"
                AutoPostBack="true" OnSelectedIndexChanged="FilterProducts">
                <asp:ListItem Text="Default" Value="popular" Selected="True" />
                <asp:ListItem Text="Price: Low → High" Value="price-asc" />
                <asp:ListItem Text="Price: High → Low" Value="price-desc" />
                <asp:ListItem Text="Name: A → Z" Value="name-asc" />
            </asp:DropDownList>
        </div>

        <div class="filter-item">
            <label for="txtProdSearch">Search</label>
            <asp:TextBox ID="txtProdSearch" runat="server" CssClass="form-control"
                AutoPostBack="true" OnTextChanged="FilterProducts" Placeholder="Type a product name…" />
        </div>
    </div>

    <!-- ===== PRODUCTS GRID ===== -->
    <asp:Panel ID="pnlProducts" runat="server" CssClass="products-grid">
        <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
            <ItemTemplate>
                <div class="product-card">
                    <div class="product-image">
                        <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("ProductName") %>'
                             onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'" />
                    </div>
                    <div class="product-info">
                        <h3 class="product-name"><%# Eval("ProductName") %></h3>
                        <p class="product-description"><%# Eval("Description") %></p>
                        <p class="product-price">
                            <%# Convert.ToBoolean(Eval("Promotion")) ?
                                $"<span class='original-price'>R{Eval("Price", "{0:F2}")}</span> <span class='promo-price'>R{Eval("PromotionPrice", "{0:F2}")}</span>"
                                : $"R{Eval("Price", "{0:F2}")}" %>
                        </p>

                        <%# Convert.ToInt32(Eval("QuantityInStock")) <= 5 ? "<p class='low-stock'>Low stock!</p>" : "" %>

                        <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart"
                            CommandName="AddToCart" CommandArgument='<%# Eval("ProductID") %>'
                            CssClass="btn-add"
                            Enabled='<%# Convert.ToInt32(Eval("QuantityInStock")) > 0 %>' />
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>

    <!-- ===== POPUP ===== -->
    <div id="addedPopup"></div>

    <style>
        /* ===== FILTER BAR ===== */
        .products-filter {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            width: 100%;
            margin-bottom: 20px;
        }
        .products-filter .filter-item {
            flex: 1;
            min-width: 200px;
            display: flex;
            flex-direction: column;
        }

        /* ===== PRODUCTS GRID ===== */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }
        .product-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            border: 1px solid #e0e0e0;
            text-align: center;
        }
        .product-image { height: 180px; display:flex; align-items:center; justify-content:center; background:#f0f0f0; }
        .product-image img { width:100%; height:100%; object-fit:cover; }
        .product-info { padding:15px; }
        .product-name { font-weight:600; color:#2c3e50; }
        .product-description { font-size:0.9rem; color:#7f8c8d; height:40px; overflow:hidden; margin-bottom:10px; }
        .product-price { font-weight:700; color:#27ae60; margin-bottom:10px; }
        .original-price { text-decoration: line-through; color: #999; margin-right:5px; }
        .promo-price { color:#e74c3c; font-weight:bold; }
        .low-stock { color:#e67e22; font-weight:bold; margin-bottom:10px; }
        .btn-add {
            background-color:#00a077; border:none; color:white;
            padding:8px 16px; border-radius:20px; font-weight:600; cursor:pointer;
        }
        .btn-add:hover { background-color:#00905f; transform: translateY(-2px); }

        /* ===== POPUP ===== */
        #addedPopup {
            position: fixed; top:20px; right:20px;
            background-color:#27ae60; color:white; padding:10px 20px;
            border-radius:5px; display:none; z-index:9999;
            box-shadow:0 2px 10px rgba(0,0,0,0.2);
        }
    </style>

    <script>
        function showAddedPopup(productName) {
            const popup = document.getElementById("addedPopup");
            popup.innerHTML = "✅ " + productName + " added to cart!";
            popup.style.display = "block";
            setTimeout(() => { popup.style.display = "none"; }, 1000);
        }
    </script>

</asp:Content>
