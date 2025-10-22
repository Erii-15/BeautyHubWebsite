<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" Inherits="System.Web.UI.Page" %>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

  <!-- ===== HERO ===== -->
  <section class="hero">
    <div class="hero-inner">
      <span class="eyebrow">your wellbeing</span>
      <h1>Natural Beauty & Spa Centre</h1>
      <p class="lede">
        Personalized treatments for mind, body & spirit.
        Slow down, switch off, and let our therapists take care of you.
      </p>
      <div class="hero-cta">
        <a href="Services.aspx" class="btn btn-primary">Our Services</a>
        <a href="Services.aspx" class="btn btn-ghost">Book Online</a>
      </div>
    </div>

    <!-- optional decorative images -->
    <img class="hero-oval" src="https://antdisplay.com/pub/media/magefan_blog/SPA_7_.png" alt="">
    <img class="hero-oval-small" src="https://images.unsplash.com/photo-1556228453-efd1f2ebd0d8?q=80&w=800&auto=format&fit=crop" alt="">
  </section>

  <!-- ===== HIGHLIGHTS ===== -->
  <section class="container highlights">
    <div class="card">
      <div class="icon">🧖‍♀️</div>
      <h3>Therapists You’ll Love</h3>
      <p>Warm, certified professionals who tailor every session to you.</p>
    </div>
    <div class="card">
      <div class="icon">🌿</div>
      <h3>Clean & Natural</h3>
      <p>Plant-based products chosen for results and skin sensitivity.</p>
    </div>
    <div class="card">
      <div class="icon">🕰️</div>
      <h3>Right on Time</h3>
      <p>Simple online booking, reminders, and zero stress arrivals.</p>
    </div>
    <div class="card">
      <div class="icon">💫</div>
      <h3>Calm Spaces</h3>
      <p>Soft lighting, gentle music, and a vibe that melts tension.</p>
    </div>
  </section>

  <!-- ===== OUR STORY (split) ===== -->
  <section class="split">
    <div class="split-media">
      <img src="https://images.unsplash.com/photo-1544161515-4ab6ce6db874?q=80&w=1400&auto=format&fit=crop" alt="Our spa">
    </div>
    <div class="split-text">
      <h2>Our Story</h2>
      <p>
        Beauty Hub began with a simple belief: self-care should feel effortless.
        We’ve blended modern techniques with traditional rituals to create
        treatments that are both restorative and results-driven.
      </p>
      <p>
        From the first hello to your final cup of tea, every detail is designed
        to help you breathe deeper and leave lighter.
      </p>
      <ul class="checklist">
        <li>Locally owned & community minded</li>
        <li>Ethically sourced products</li>
        <li>Continuous therapist training</li>
      </ul>
    </div>
  </section>

  <!-- ===== WHY CHOOSE US ===== -->
  <section class="container why">
    <h2 class="center">Why Guests Choose Us</h2>
    <div class="why-grid">
      <div class="why-item">
        <span class="bullet">1</span>
        <h4>Tailored Spa Services</h4>
        <p>Every body is different. We adjust pressure, focus areas, and products to suit you.</p>
      </div>
      <div class="why-item">
        <span class="bullet">2</span>
        <h4>Transparent Pricing</h4>
        <p>No surprises. Clear durations and fair pricing, with seasonal promos.</p>
      </div>
      <div class="why-item">
        <span class="bullet">3</span>
        <h4>Serene Atmosphere</h4>
        <p>Quiet treatment rooms, premium linens, and soothing scent profiles.</p>
      </div>
    </div>
  </section>

  

  <!-- ===== TESTIMONIAL STRIP ===== -->
  <section class="testimonials">
    <div class="container testi-grid">
      <div class="quote">“Best facial I’ve had in years. My skin glowed for days.” <span>— Aisha M.</span></div>
      <div class="quote">“I walked in stressed and left floating. Five stars.” <span>— Daniel S.</span></div>
      <div class="quote">“Calm atmosphere, kind staff, spotless rooms.” <span>— Keabetswe T.</span></div>
    </div>
  </section>

  <!-- ===== CTA ===== -->
  <section class="cta">
    <h2>Ready to unwind?</h2>
    <p>Book your treatment in minutes. Your future self will thank you.</p>
    <a href="Services.aspx" class="btn btn-primary">Book Online</a>
  </section>

  <!-- ===== Page styles (scoped) ===== -->
  <style>
    :root{
      --bg:#fff; --ink:#1f2937; --muted:#6b7280;
      --brand:#e9b5ad;           /* soft blush */
      --brand-dark:#d7897e;
      --accent:#00a077;
      --card:#ffffff;
      --shadow:0 10px 25px rgba(0,0,0,.08);
      --radius:14px;
    }
    .container{max-width:1100px;margin:0 auto;padding:0 18px;}
    .center{text-align:center}
    .muted{color:var(--muted)}

    /* HERO */
    .hero{
      position:relative;
      background:#fff6f5;
      border-radius: var(--radius);
      overflow:hidden;
      padding:70px 0 110px;
      margin-bottom:28px;
    }
    .hero-inner{max-width:800px;margin:0 auto;padding:0 18px;position:relative;z-index:2}
    .eyebrow{letter-spacing:.25em;text-transform:uppercase;color:#c07a72;font-weight:700}
    .hero h1{font-size:clamp(36px,5vw,56px);line-height:1.08;margin:.35em 0;color:#222}
    .hero .lede{font-size:1.1rem;color:var(--muted);max-width:680px}
    .hero-cta{margin-top:18px;display:flex;gap:12px;flex-wrap:wrap}

    .btn{display:inline-block;padding:10px 18px;border-radius:999px;font-weight:700;text-decoration:none}
    .btn-primary{background:var(--accent);color:#fff}
    .btn-primary:hover{background:#00905f}
    .btn-ghost{border:2px solid var(--accent);color:var(--accent)}
    .btn-ghost:hover{background:rgba(0,160,119,.08)}

    /* fancy ovals (decor) */
    .hero-oval{
      position:absolute;right:4%;bottom:-120px;width:600px;height:420px;
      object-fit:cover;border-radius:50% 45% 50% 52% / 48% 52% 45% 55%;
      box-shadow:var(--shadow);border:8px solid #f5d7d2;opacity:.95
    }
    .hero-oval-small{
      position:absolute;right:9%;bottom:-40px;width:220px;height:160px;
      object-fit:cover;border-radius:50%;box-shadow:var(--shadow);border:6px solid #f5d7d2
    }

    /* HIGHLIGHTS */
    .highlights{display:grid;gap:16px;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));margin:28px auto}
    .highlights .card{
      background:var(--card);border-radius:var(--radius);padding:18px;box-shadow:var(--shadow);text-align:center
    }
    .highlights .icon{font-size:28px;margin-bottom:6px}
    .highlights h3{margin:6px 0 4px;font-size:1.05rem}

    /* SPLIT */
    .split{display:grid;grid-template-columns: 1.1fr 1fr;gap:28px;align-items:center;margin:40px auto}
    .split-media img{width:100%;height:100%;max-height:440px;object-fit:cover;border-radius:18px;box-shadow:var(--shadow)}
    .split-text h2{font-size:2rem;margin-bottom:10px}
    .checklist{list-style:none;padding:0;margin:12px 0 0}
    .checklist li{margin:6px 0;padding-left:26px;position:relative}
    .checklist li:before{content:"✓";position:absolute;left:0;top:0;color:var(--accent);font-weight:800}

    /* WHY */
    .why{margin:40px auto}
    .why-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:18px;margin-top:12px}
    .why-item{background:var(--card);border-radius:var(--radius);padding:16px;box-shadow:var(--shadow)}
    .bullet{width:30px;height:30px;border-radius:50%;display:inline-grid;place-items:center;
            background:#fde6e2;color:#a65b52;font-weight:800;margin-bottom:6px}



    /* TESTIMONIALS */
    .testimonials{background:#111;color:#eee;padding:28px 0;margin:50px 0;border-radius:16px}
    .testi-grid{display:grid;gap:14px;grid-template-columns:repeat(auto-fit,minmax(240px,1fr))}
    .quote{background:#1a1a1a;border:1px solid #2a2a2a;border-radius:12px;padding:14px}
    .quote span{color:#c9c9c9}

    /* CTA */
    .cta{text-align:center;margin:48px auto;padding:28px;background:#fff6f5;border:1px solid #f1d6d2;border-radius:16px}
    .cta h2{margin:0 0 6px}

    /* Responsive */
    @media (max-width: 980px){
      .hero{padding-bottom:160px}
      .hero-oval{width:460px;height:320px;right:2%}
      .hero-oval-small{right:7%}
      .split{grid-template-columns:1fr}
    }
  </style>
</asp:Content>
