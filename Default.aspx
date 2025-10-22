

<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Default.aspx.cs"
    Inherits="WebApplication1._Default" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <!-- ===== HERO  ===== -->
  <section class="hero">
    <div class="hero-inner">
      <span class="eyebrow">welcome to beauty hub</span>
      <h1>Relax. Restore. <span class="accent">Glow.</span></h1>
      <p class="lede">Mindful treatments and clean products that help you slow down and feel your best.</p>
      <div class="hero-cta">
        <a href="Services.aspx" class="btn btn-primary">Explore Services</a>
        <a href="Products.aspx" class="btn btn-ghost">Shop Products</a>
      </div>
    </div>
    <img class="hero-oval" src="https://images.unsplash.com/photo-1600431521340-491eca880813?q=80&w=1600&auto=format&fit=crop" alt="">
    <img class="hero-oval-small" src="https://images.unsplash.com/photo-1582092728063-5d9b2aaf9f7c?q=80&w=900&auto=format&fit=crop" alt="">
  </section>

  <!-- ===== PILLARS ===== -->
  <section class="container pillars">
    <div class="pill"><span class="pill-icon">🌿</span><h4>Clean Ingredients</h4><p>Plant-based, skin-friendly formulas.</p></div>
    <div class="pill"><span class="pill-icon">🧖‍♀️</span><h4>Skilled Therapists</h4><p>Warm, certified pros who tailor to you.</p></div>
    <div class="pill"><span class="pill-icon">⏰</span><h4>Easy Booking</h4><p>Online scheduling & reminders.</p></div>
  </section>

  <!-- ===== FEATURED SERVICES ===== -->
  <section class="container section">
    <div class="section-head">
      <h2>Popular Services</h2>
      <a class="link" href="Services.aspx">View all services →</a>
    </div>

    <div class="card-grid">
      <asp:Repeater ID="rptFeaturedServices" runat="server">
        <ItemTemplate>
          <a class="card" href='<%# "BookAppointment.aspx?serviceId=" + Eval("ServiceID") %>'>
            <div class="card-img">
              <img src='<%# GetImageUrl(Eval("ImagePath")) %>'
                   alt='<%# Eval("ServiceName") %>' 
                   onerror="this.src='https://via.placeholder.com/600x360?text=Service';" />
            </div>
            <div class="card-body">
              <h5><%# Eval("ServiceName") %></h5>
              <p><%# Eval("Description") %></p>
              <span class="tag"><%# Eval("DurationMinutes") %> mins</span>
            </div>
          </a>
        </ItemTemplate>
      </asp:Repeater>
    </div>
  </section>

  <!-- ===== FEATURED PRODUCTS ===== -->
  <section class="container section">
    <div class="section-head">
      <h2>Best-Loved Products</h2>
      <a class="link" href="Products.aspx">Shop the catalog →</a>
    </div>

    <div class="card-grid small">
      <asp:Repeater ID="rptFeaturedProducts" runat="server">
        <ItemTemplate>
          <a class="card" href="Products.aspx">
            <div class="card-img">
              <img src='<%# GetImageUrl(Eval("ImageUrl")) %>'
                   alt='<%# Eval("ProductName") %>'
                   onerror="this.src='https://via.placeholder.com/600x360?text=Product';" />
            </div>
            <div class="card-body">
              <h5><%# Eval("ProductName") %></h5>
              <p><%# Eval("Description") %></p>
              <span class="price">
                <%# Convert.ToBoolean(Eval("Promotion"))
                    ? $"<span style='text-decoration:line-through;color:#999;margin-right:6px;'>R{Eval("Price","{0:F2}")}</span> R{Eval("PromotionPrice","{0:F2}")}"
                    : $"R{Eval("Price","{0:F2}")}" %>
              </span>
            </div>
          </a>
        </ItemTemplate>
      </asp:Repeater>
    </div>
  </section>



  <section class="cta">
    <h2>Take a breath.</h2>
    <p>Book your next moment of calm in minutes.</p>
    <a href="Services.aspx" class="btn btn-primary">Book a Treatment</a>
  </section>

  


  <!-- ===== Styles (scoped) ===== -->
  <style>
    :root{
      --ink:#1f2937; --muted:#6b7280;
      --accent:#00a077;
      --blush:#fff6f5; --border:#f1d6d2;
      --card:#fff; --shadow:0 10px 25px rgba(0,0,0,.08);
      --radius:16px;
    }
    .container{max-width:1100px;margin:0 auto;padding:0 18px}
    .btn{display:inline-block;padding:10px 18px;border-radius:999px;font-weight:700;text-decoration:none}
    .btn-primary{background:var(--accent);color:#fff}
    .btn-primary:hover{background:#00905f}
    .btn-ghost{border:2px solid var(--accent);color:var(--accent)}
    .btn-ghost:hover{background:rgba(0,160,119,.08)}
    .link{color:#0069c0;text-decoration:none;font-weight:700}
    .link:hover{text-decoration:underline}

    /* HERO */
    .hero{position:relative;background:var(--blush);border-radius:var(--radius);overflow:hidden;padding:70px 0 110px;margin-bottom:28px}
    .hero-inner{max-width:820px;margin:0 auto;padding:0 18px;position:relative;z-index:2}
    .eyebrow{letter-spacing:.25em;text-transform:uppercase;color:#c07a72;font-weight:700}
    .hero h1{font-size:clamp(38px,5vw,58px);line-height:1.06;margin:.35em 0;color:#222}
    .hero h1 .accent{color:#d7897e}
    .lede{font-size:1.12rem;color:var(--muted);max-width:680px}
    .hero-cta{margin-top:18px;display:flex;gap:12px;flex-wrap:wrap}
    .hero-oval{position:absolute;right:4%;bottom:-120px;width:600px;height:420px;object-fit:cover;border-radius:50% 45% 50% 52% / 48% 52% 45% 55%;box-shadow:var(--shadow);border:8px solid var(--border);opacity:.95}
    .hero-oval-small{position:absolute;right:9%;bottom:-40px;width:220px;height:160px;object-fit:cover;border-radius:50%;box-shadow:var(--shadow);border:6px solid var(--border)}

    /* PILLARS */
    .pillars{display:grid;gap:16px;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));margin:26px auto}
    .pill{background:var(--card);border-radius:14px;padding:16px;text-align:center;box-shadow:var(--shadow)}
    .pill-icon{font-size:26px;display:block;margin-bottom:6px}

    /* SECTIONS */
    .section{margin:34px auto}
    .section-head{display:flex;justify-content:space-between;align-items:end;gap:12px;margin-bottom:12px}
    .section-head h2{margin:0}
    .card-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:18px}
    .card-grid.small{grid-template-columns:repeat(auto-fit,minmax(220px,1fr))}
    .card{background:var(--card);border:1px solid #eee;border-radius:14px;overflow:hidden;box-shadow:var(--shadow);text-decoration:none;color:inherit;display:block;transition:transform .2s ease, box-shadow .2s ease}
    .card:hover{transform:translateY(-4px);box-shadow:0 12px 28px rgba(0,0,0,.12)}
    .card-img{height:160px;background:#f5f5f5}
    .card-img img{width:100%;height:100%;object-fit:cover;display:block}
    .card-body{padding:12px}
    .card-body h5{margin:2px 0 6px;font-size:1.05rem;color:#2c3e50}
    .card-body p{margin:0 0 8px;color:#666;font-size:.95rem}
    .tag{display:inline-block;background:#eefaf3;color:#00795c;border-radius:999px;padding:4px 10px;font-weight:700;font-size:.8rem}
    .price{font-weight:700;color:#00916e}


    /* CTA */
    .cta{text-align:center;margin:40px auto;padding:26px;background:var(--blush);border:1px solid var(--border);border-radius:16px}
    .cta h2{margin:0 0 6px}

    /* Responsive tweaks */
    @media (max-width: 980px){
      .hero{padding-bottom:160px}
      .hero-oval{width:460px;height:320px;right:2%}
      .hero-oval-small{right:7%}
    }
  </style>

</asp:Content>


