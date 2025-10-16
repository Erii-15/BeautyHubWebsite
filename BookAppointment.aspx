<%@ Page Title="Book Appointment" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="BookAppointment.aspx.cs" Inherits="WebApplication1.BookAppointment" %>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

  <h1 class="text-center mb-3">Book Appointment</h1>

  <!-- Service summary -->
  <asp:Panel ID="pnlService" runat="server" CssClass="booking-summary" Visible="false">
    <h2><asp:Label ID="lblSvcName" runat="server" /></h2>
    <p><asp:Label ID="lblSvcDesc" runat="server" /></p>
    <p>Price: R<asp:Label ID="lblSvcPrice" runat="server" /> • Duration: <asp:Label ID="lblSvcDur" runat="server" /> mins</p>
  </asp:Panel>

  <!-- Booking form -->
  <asp:Panel ID="pnlForm" runat="server" CssClass="booking-panel" Visible="false">
    <asp:HiddenField ID="hfServiceID" runat="server" />

    <div class="form-row">
      <label>Date</label>
      <asp:TextBox ID="txtDate" runat="server" TextMode="Date" CssClass="form-control" />
    </div>

    <div class="form-row">
      <label>Start Time</label>
      <asp:TextBox ID="txtTime" runat="server" TextMode="Time" CssClass="form-control" />
    </div>

    <div class="form-row">
      <label>Staff</label>
      <asp:DropDownList ID="ddlStaff" runat="server" CssClass="form-control" />
    </div>

    <div class="form-row">
      <label>Comment (optional)</label>
      <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
    </div>

    <asp:Button ID="btnBook" runat="server" Text="Book Appointment" CssClass="btn-primary" OnClick="btnBook_Click" />
    <a href="Services.aspx" class="btn-link" style="margin-left:10px;">← Back to Services</a>
  </asp:Panel>

  <!-- Simple styles -->
  <style>
    .booking-summary { margin-bottom:14px; padding:12px; border:1px solid #e6e6e6; border-radius:10px; background:#fafafa; }
    .booking-panel { padding:16px; border:1px solid #e6e6e6; border-radius:10px; background:#fff; }
    .form-row { margin-bottom:10px; }
    .form-row label { display:block; font-weight:600; margin-bottom:4px; }
    .form-control { width:100%; padding:8px; border:1px solid #ccc; border-radius:6px; }
    .btn-primary { background:#00a077; border:none; color:#fff; padding:8px 16px; border-radius:20px; font-weight:600; cursor:pointer; }
    .btn-primary:hover { background:#00905f; }
    .btn-link { text-decoration:none; color:#0069c0; }
  </style>

  <!-- SweetAlert2 for nice centered popups -->
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

