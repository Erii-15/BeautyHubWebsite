<%@ Page Title="Services" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Services.aspx.cs" Inherits="WebApplication1.Services" %>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

  <!-- login notice -->
  <asp:Panel ID="pnlLoginNotice" runat="server" Visible="false">
    <div style="background:#fff3cd;color:#856404;border:1px solid #ffeeba;padding:8px;border-radius:6px;margin-bottom:12px;">
      Please log in to book an appointment.
      <a href="~/Account/Login" runat="server" style="font-weight:600; margin-left:6px;">Log in</a>
    </div>
  </asp:Panel>

  <!-- Optional upcoming banner -->
     <!-- Still needs to be made -->
  <asp:Panel ID="pnlUpcoming" runat="server" Visible="false"
    Style="background:#eefaf3;border:1px solid #cceedd;border-radius:8px;padding:10px 12px;margin-bottom:14px;">
    <asp:Label ID="lblUpcoming" runat="server" />
  </asp:Panel>

  <!-- FILTER BAR -->
  <div class="products-filter">
    <div class="filter-item">
      <label for="txtSvcSearch">Search</label>
      <asp:TextBox ID="txtSvcSearch" runat="server" CssClass="form-control"
                   AutoPostBack="true" OnTextChanged="FilterServices"
                   Placeholder="Type a service name…" />
    </div>

    <div class="filter-item">
      <label for="ddlSvcSort">Sort</label>
      <asp:DropDownList ID="ddlSvcSort" runat="server" CssClass="form-control"
                        AutoPostBack="true" OnSelectedIndexChanged="FilterServices">
        <asp:ListItem Text="Default" Value="default" Selected="True" />
        <asp:ListItem Text="Price: Low → High" Value="price-asc" />
        <asp:ListItem Text="Price: High → Low" Value="price-desc" />
        <asp:ListItem Text="Duration: Short → Long" Value="dur-asc" />
        <asp:ListItem Text="Duration: Long → Short" Value="dur-desc" />
        <asp:ListItem Text="Name: A → Z" Value="name-asc" />
      </asp:DropDownList>
    </div>
  </div>

  <h1>Services</h1>

  <!-- Services grid -->
  <asp:Panel ID="pnlServices" runat="server" CssClass="services-grid">
    <asp:Repeater ID="rptServices" runat="server">
      <ItemTemplate>
        <div class="service-card">
          <div class="service-image">
            <img src='<%# GetImageUrl(Eval("ImagePath")) %>'
                 alt='<%# Eval("ServiceName") %>'
                 onerror="this.src='https://via.placeholder.com/600x360?text=No+Image';" />
          </div>

          <h3><%# Eval("ServiceName") %></h3>
          <p><%# Eval("Description") %></p>
          <p class="price">
            <%# Convert.ToBoolean(Eval("Promotion"))
                ? $"<span class='original-price'>R{Eval("Price", "{0:F2}")}</span> <span class='promo-price'>R{Eval("PromotionPrice", "{0:F2}")}</span>"
                : $"R{Eval("Price", "{0:F2}")}" %>
            • <%# Eval("DurationMinutes") %> mins
          </p>

          <!-- Link to the booking page -->
          <asp:HyperLink runat="server"
              CssClass="btn-view"
              Text="View / Book"
              NavigateUrl='<%# "BookAppointment.aspx?serviceId=" + Eval("ServiceID") %>' />
        </div>
      </ItemTemplate>
    </asp:Repeater>
  </asp:Panel>


    <style>
/* ===== FILTER BAR ===== */
.filter-bar {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
    justify-content: flex-start;
    margin-bottom: 25px;
}
.filter-bar .filter-item {
    flex: 1;
    min-width: 220px;
    display: flex;
    flex-direction: column;
}
.filter-bar label {
    font-weight: 600;
    color: #333;
    margin-bottom: 4px;
}
.filter-bar input,
.filter-bar select {
    border: 1px solid #ccc;
    border-radius: 6px;
    padding: 6px 10px;
    font-size: 15px;
}

/* ===== SERVICE GRID ===== */
.services-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 25px;
}
.service-card {
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    border: 1px solid #eee;
    padding: 18px;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.service-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}
.service-card h3 {
    font-size: 1.2rem;
    color: #222;
    margin-bottom: 6px;
}
.service-card p {
    color: #666;
    font-size: 0.95rem;
    margin-bottom: 8px;
}
.service-card .price {
    font-weight: 700;
    color: #00916e;
    font-size: 1rem;
}
.service-card .original-price {
    text-decoration: line-through;
    color: #999;
    margin-right: 6px;
}
.service-card .promo-price {
    color: #e74c3c;
}
.service-card .btn-view {
    background-color: #00a077;
    color: white;
    border: none;
    border-radius: 20px;
    padding: 8px 16px;
    cursor: pointer;
    font-weight: 600;
    margin-top: 10px;
    transition: background-color 0.2s ease;
}
.service-card .btn-view:hover {
    background-color: #00905f;
}

/* ===== BOOKING PANEL ===== */
.booking-panel {
    margin-top: 25px;
    padding: 20px;
    background: #f9f9f9;
    border: 1px solid #ddd;
    border-radius: 12px;
}
.booking-panel h2 {
    margin-top: 0;
    color: #333;
}
.booking-panel label {
    display: block;
    font-weight: 600;
    color: #333;
    margin-top: 8px;
    margin-bottom: 3px;
}
.booking-panel input,
.booking-panel select,
.booking-panel textarea {
    width: 100%;
    border: 1px solid #ccc;
    border-radius: 6px;
    padding: 6px;
    font-size: 15px;
}
.booking-panel button {
    margin-top: 15px;
    background-color: #00a077;
    color: white;
    border: none;
    border-radius: 20px;
    padding: 10px 18px;
    cursor: pointer;
    font-weight: 600;
}
.booking-panel button:hover {
    background-color: #00905f;
}
</style>




</asp:Content>
