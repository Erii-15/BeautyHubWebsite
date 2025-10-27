<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyAppointments.aspx.cs" Inherits="WebApplication1.MyAppointments" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h1>My Appointments</h1>

    <!-- UPCOMING SECTION -->
    <h2 style="margin-top:20px;">Upcoming</h2>
    <asp:Panel ID="pnlUpcomingEmpty" runat="server" Visible="false"
        Style="background:#fff3cd;border:1px solid #ffeeba;color:#856404;
               padding:10px 12px;border-radius:6px;margin-bottom:15px;">
        You have no upcoming appointments.
    </asp:Panel>

    <asp:Repeater ID="rptUpcoming" runat="server">
        <ItemTemplate>
            <div class="appt-card">
  <div class="appt-img">
    <img src='<%# ResolveImageUrl(Eval("ImagePath")) %>'
         alt='<%# Eval("ServiceName") %>'
         onerror="this.src='https://via.placeholder.com/150x100?text=No+Image';" />
  </div>

  <div class="appt-info">
    <div class="appt-header">
        <span class="appt-service"><%# Eval("ServiceName") %></span>
        <span class="appt-badge upcoming">Upcoming</span>
    </div>
    <div class="appt-line"><strong>With:</strong> <%# Eval("StaffName") %></div>
    <div class="appt-line"><strong>Date:</strong> <%# Convert.ToDateTime(Eval("Date")).ToString("yyyy-MM-dd") %></div>
    <div class="appt-line"><strong>Time:</strong> <%# ((TimeSpan)Eval("StartTime")).ToString(@"hh\:mm") %> - <%# ((TimeSpan)Eval("EndTime")).ToString(@"hh\:mm") %></div>
  </div>
</div>

        </ItemTemplate>
    </asp:Repeater>


    <!-- PAST SECTION -->
    <h2 style="margin-top:30px;">Past</h2>
    <asp:Panel ID="pnlPastEmpty" runat="server" Visible="false"
        Style="background:#eef2f5;border:1px solid #cfd6dc;color:#4a5568;
               padding:10px 12px;border-radius:6px;margin-bottom:15px;">
        You have no past appointments yet.
    </asp:Panel>

    <!-- We'll allow rating here -->
    <asp:Repeater ID="rptPast" runat="server" OnItemCommand="rptPast_ItemCommand">
        <ItemTemplate>
            <div class="appt-card">
                <div class="appt-header">
                    <span class="appt-service"><%# Eval("ServiceName") %></span>
                    <span class="appt-badge past">Completed</span>
                </div>

                <div class="appt-line">
                    <strong>With:</strong>
                    <%# Eval("StaffName") %>
                </div>

                <div class="appt-line">
                    <strong>Date:</strong>
                    <%# Convert.ToDateTime(Eval("Date")).ToString("yyyy-MM-dd") %>
                </div>

                <div class="appt-line">
                    <strong>Time:</strong>
                    <%# ((TimeSpan)Eval("StartTime")).ToString(@"hh\:mm") %>
                    -
                    <%# ((TimeSpan)Eval("EndTime")).ToString(@"hh\:mm") %>
                </div>

                <div class="appt-line">
                    <strong>Your rating:</strong>
                    <asp:PlaceHolder ID="phRated" runat="server" Visible='<%# (Convert.ToInt32(Eval("Rating")) > 0) %>'>
                        <span class="rating-display">
                            <%# RenderStars(Convert.ToInt32(Eval("Rating"))) %>
                            (<%# Eval("Rating") %> / 5)
                        </span>
                    </asp:PlaceHolder>

                    <asp:PlaceHolder ID="phRateNow" runat="server" Visible='<%# (Convert.ToInt32(Eval("Rating")) == 0) %>'>
                        <asp:DropDownList ID="ddlRating" runat="server" CssClass="rating-ddl">
                            <asp:ListItem Text="Select…" Value="0" />
                            <asp:ListItem Text="1 - Poor" Value="1" />
                            <asp:ListItem Text="2 - Fair" Value="2" />
                            <asp:ListItem Text="3 - Good" Value="3" />
                            <asp:ListItem Text="4 - Very Good" Value="4" />
                            <asp:ListItem Text="5 - Excellent" Value="5" />
                        </asp:DropDownList>

                        <asp:Button ID="btnSubmitRating" runat="server"
                            CssClass="btn-rate"
                            Text="Submit Rating"
                            CommandName="Rate"
                            CommandArgument='<%# Eval("AppointmentID") %>' />
                    </asp:PlaceHolder>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>


    <style>
        .appt-card {
            background:#fff;
            border:1px solid #e2e8f0;
            border-radius:12px;
            padding:16px 18px;
            margin-bottom:18px;
            box-shadow:0 2px 8px rgba(0,0,0,0.05);
            max-width:480px;
        }

        .appt-header {
            display:flex;
            justify-content:space-between;
            align-items:flex-start;
            margin-bottom:8px;
        }

        .appt-service {
            font-weight:600;
            color:#2c3e50;
            font-size:1.05rem;
        }

        .appt-badge {
            font-size:0.8rem;
            font-weight:600;
            border-radius:12px;
            padding:3px 8px;
            line-height:1.2;
            border:1px solid transparent;
        }

        .appt-badge.upcoming {
            background:#e6fffa;
            color:#046c4e;
            border-color:#b2f5ea;
        }

        .appt-badge.past {
            background:#edf2f7;
            color:#4a5568;
            border-color:#cbd5e0;
        }

        .appt-line {
            font-size:0.9rem;
            color:#4a5568;
            margin-bottom:6px;
        }

        .rating-display {
            color:#2c3e50;
            font-weight:600;
        }

        .rating-ddl {
            border:1px solid #cbd5e0;
            border-radius:6px;
            padding:4px 6px;
            font-size:0.9rem;
            margin-right:8px;
        }

        .btn-rate {
            background-color:#00a077;
            color:#fff;
            border:none;
            border-radius:20px;
            padding:6px 14px;
            font-weight:600;
            cursor:pointer;
        }

        .btn-rate:hover {
            background-color:#00905f;
        }


        .appt-card {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    background: #fff;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 14px;
    margin-bottom: 16px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    max-width: 520px;
}

.appt-img img {
    width: 120px;
    height: 90px;
    border-radius: 10px;
    object-fit: cover;
}

.appt-info {
    flex: 1;
}

    </style>



</asp:Content>
