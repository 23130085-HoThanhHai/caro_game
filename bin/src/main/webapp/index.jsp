<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("activeNav", "home"); %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Gomoku Zen</title>
  <link rel="stylesheet" href="assets/css/app.css" />
</head>
<body>
  <div class="page">
    <%@ include file="WEB-INF/jsp/common/header.jspf" %>

    <main class="main" role="main">
      <section class="hero" aria-label="Giới thiệu">
        <div class="container hero-inner">
          <div class="hero-copy">
            <div class="badge">TRẢI NGHIỆM CHIẾN THUẬT ĐỈNH CAO</div>
            <h1 class="hero-title">
              Chinh Phục Đỉnh Cao
              <span class="accent">Cờ Caro</span>
            </h1>
            <p class="hero-desc">
              Gomoku Zen mang đến không gian thi đấu tĩnh lặng nhưng đầy kịch tính.
              Nâng tầm kỹ năng của bạn qua từng nước cờ, từ những ván đấu thư giãn đến các trận xếp hạng căng thẳng.
            </p>

            <div class="hero-actions">
              <a class="btn btn-primary btn-lg" href="#modes">Bắt Đầu Ngay</a>
              <a class="btn btn-outline btn-lg" href="rules.jsp">Xem Luật Chơi</a>
            </div>
          </div>

          <div class="hero-media" aria-label="Xem trước">
            <div class="hero-image-card">
              <img
                class="hero-image"
                src="assets/img/hero-board.svg"
                alt="Bàn cờ Gomoku"
                loading="lazy"
                decoding="async"
              />
            </div>

            <div class="hero-float" aria-label="Top tuần">
              <div class="hero-float-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M7 4h10v3a4 4 0 0 1-4 4h-2a4 4 0 0 1-4-4V4Z" stroke="currentColor" stroke-width="1.8" />
                  <path d="M9 21h6" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" />
                  <path d="M12 11v10" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" />
                  <path d="M7 6H5a2 2 0 0 0 2 2" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" />
                  <path d="M17 6h2a2 2 0 0 1-2 2" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" />
                </svg>
              </div>
              <div class="hero-float-text">
                <div class="hero-float-meta">TOP #1 TUẦN</div>
                <div class="hero-float-name">Minh Triết</div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="section" id="modes" aria-label="Chế độ chơi">
        <div class="container section-head">
          <div>
            <h2 class="section-title">Chọn Chế Độ Chơi</h2>
            <p class="section-sub">Thử thách bản thân với nhiều hình thức thi đấu đa dạng.</p>
          </div>
          <div class="section-accent" aria-hidden="true"></div>
        </div>

        <div class="container mode-grid">
          <a class="card mode-card feature-card" href="create-room">
            <div class="mode-icon mode-icon--peach" aria-hidden="true">
              <svg viewBox="0 0 24 24" width="20" height="20" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 5v14" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                <path d="M5 12h14" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                <rect x="4" y="4" width="16" height="16" rx="4" stroke="currentColor" stroke-width="1.6" opacity="0.6" />
              </svg>
            </div>
            <h3 class="card-title">Tạo Phòng</h3>
            <p class="card-desc">Tự tạo không gian thi đấu riêng và mời bạn bè tham gia.</p>
            <span class="card-link">Bắt đầu <span aria-hidden="true">→</span></span>
          </a>

            <style>

              .feature-card{
                display: block;
                text-decoration: none;
                background: #ffffff;
                border-radius: 16px;
                padding: 24px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
                color: #333;
              }

              .feature-card:hover{
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(0,0,0,0.15);
              }

              .card-title{
                font-size: 24px;
                margin-bottom: 12px;
                color: #222;
              }

              .card-desc{
                font-size: 15px;
                line-height: 1.6;
                margin-bottom: 20px;
                color: #666;
              }

              .card-link{
                font-weight: bold;
                color: #3498db;
                display: inline-flex;
                align-items: center;
                gap: 6px;
              }

            </style>

            <a href="find-room" class="feature-card">
              <div class="mode-icon mode-icon--blue" aria-hidden="true">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <circle cx="11" cy="11" r="6" stroke="currentColor" stroke-width="2" />
                  <path d="M20 20l-3.5-3.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                </svg>
              </div>

              <h3 class="card-title">
                Tìm Phòng
              </h3>

              <p class="card-desc">
                Dạo qua danh sách các phòng đang chờ đối thủ gia nhập.
              </p>

              <span class="card-link">
                  Tìm kiếm <span aria-hidden="true">→</span>
              </span>

            </a>

          <a class="card mode-card is-muted feature-card" href="<%= request.getContextPath() %>/offline-pvp?action=new&mode=pvp&size=15">
            <div class="mode-icon mode-icon--muted" aria-hidden="true">
              <svg viewBox="0 0 24 24" width="20" height="20" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M16 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                <circle cx="10" cy="7" r="3" stroke="currentColor" stroke-width="2" />
                <path d="M23 21v-2a3.5 3.5 0 0 0-2.6-3.4" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                <path d="M18.5 4.6a3 3 0 0 1 0 5.8" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
              </svg>
            </div>
            <h3 class="card-title">Chơi 2 Người</h3>
            <p class="card-desc">Thi đấu trực tiếp với bạn bè ngay trên một thiết bị duy nhất.</p>
            <span class="card-link">Vào bàn ngay <span aria-hidden="true">→</span></span>
          </a>

          <a class="card mode-card is-muted feature-card" href="<%= request.getContextPath() %>/offline-bot">
            <div class="mode-icon mode-icon--muted" aria-hidden="true">
              <svg viewBox="0 0 24 24" width="20" height="20" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M7 7h10v8H7V7Z" stroke="currentColor" stroke-width="2" />
                <path d="M9 15v2" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                <path d="M15 15v2" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                <path d="M10 10h.01" stroke="currentColor" stroke-width="3" stroke-linecap="round" />
                <path d="M14 10h.01" stroke="currentColor" stroke-width="3" stroke-linecap="round" />
                <path d="M12 2v3" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                <path d="M4 12h3" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                <path d="M17 12h3" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
              </svg>
            </div>
            <h3 class="card-title">Đấu Với Máy</h3>
            <p class="card-desc">Rèn luyện kỹ năng với trí tuệ nhân tạo từ Dễ đến Siêu cấp.</p>
            <span class="card-link">Luyện tập <span aria-hidden="true">→</span></span>
          </a>
        </div>
      </section>

      <section class="section" id="leaderboard" aria-label="Bảng xếp hạng">
        <div class="container split-grid">
          <div class="card board-card">
            <div class="card-head">
              <div class="card-head-left">
                <div class="card-head-icon" aria-hidden="true">
                  <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M4 20V8" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                    <path d="M10 20V4" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                    <path d="M16 20v-9" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                    <path d="M22 20v-6" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                  </svg>
                </div>
                <h3 class="card-head-title">Bảng Xếp Hạng</h3>
              </div>
              <a class="link-accent" href="leaderboard.jsp">Xem tất cả</a>
            </div>

            <div class="lb">
              <div class="lb-row is-top">
                <div class="lb-rank">01</div>
                <div class="lb-player">
                  <div class="avatar avatar--one" aria-hidden="true"></div>
                  <div>
                    <div class="lb-name">Minh Triết</div>
                    <div class="lb-sub">ELO: 2,450</div>
                  </div>
                </div>
                <div class="lb-metric">
                  <div class="lb-rate">88%</div>
                  <div class="lb-sub">Tỷ lệ thắng</div>
                </div>
              </div>

              <div class="lb-row">
                <div class="lb-rank">02</div>
                <div class="lb-player">
                  <div class="avatar avatar--two" aria-hidden="true"></div>
                  <div>
                    <div class="lb-name">Ngọc Lan</div>
                    <div class="lb-sub">ELO: 2,310</div>
                  </div>
                </div>
                <div class="lb-metric">
                  <div class="lb-rate">82%</div>
                  <div class="lb-sub">Tỷ lệ thắng</div>
                </div>
              </div>

              <div class="lb-row">
                <div class="lb-rank">03</div>
                <div class="lb-player">
                  <div class="avatar avatar--three" aria-hidden="true"></div>
                  <div>
                    <div class="lb-name">Đức Duy</div>
                    <div class="lb-sub">ELO: 2,280</div>
                  </div>
                </div>
                <div class="lb-metric">
                  <div class="lb-rate">79%</div>
                  <div class="lb-sub">Tỷ lệ thắng</div>
                </div>
              </div>
            </div>
          </div>

          <div class="side-stack">
            <div class="card stat-card">
              <div class="stat-top">
                <div class="stat-icon" aria-hidden="true">
                  <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18Z" stroke="currentColor" stroke-width="2" />
                    <path d="M3.6 9h16.8" stroke="currentColor" stroke-width="2" stroke-linecap="round" opacity="0.7" />
                    <path d="M3.6 15h16.8" stroke="currentColor" stroke-width="2" stroke-linecap="round" opacity="0.7" />
                    <path d="M12 3a12 12 0 0 1 0 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" opacity="0.7" />
                    <path d="M12 3a12 12 0 0 0 0 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" opacity="0.7" />
                  </svg>
                </div>
                <div>
                  <div class="stat-label">ĐANG ONLINE</div>
                  <div class="stat-value">1,284</div>
                </div>
              </div>
              <p class="stat-desc">Người chơi đang trực tuyến trên toàn thế giới.</p>
            </div>

            <div class="card community-card" id="community">
              <div class="card-head">
                <div class="card-head-left">
                  <div class="card-head-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                      <path d="M4 5h16v10H7l-3 3V5Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round" />
                      <path d="M8 9h8" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                      <path d="M8 12h6" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                    </svg>
                  </div>
                  <h3 class="card-head-title">Cộng Đồng</h3>
                </div>
              </div>

              <div class="community-list">
                <div class="community-item">
                  <div class="community-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                      <path d="M4 6h16v12H4V6Z" stroke="currentColor" stroke-width="2" />
                      <path d="M7 10h10" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                      <path d="M7 14h6" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                    </svg>
                  </div>
                  <div>
                    <div class="community-title">Thảo luận chiến thuật</div>
                    <div class="lb-sub">42 bài viết mới hôm nay</div>
                  </div>
                </div>

                <div class="community-item">
                  <div class="community-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                      <path d="M7 4h10v4H7V4Z" stroke="currentColor" stroke-width="2" />
                      <path d="M6 8h12v12H6V8Z" stroke="currentColor" stroke-width="2" />
                      <path d="M8 12h8" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                      <path d="M8 16h6" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                    </svg>
                  </div>
                  <div>
                    <div class="community-title">Giải đấu Master Zen</div>
                    <div class="lb-sub">Bắt đầu sau 2 ngày nữa</div>
                  </div>
                </div>
              </div>

              <a class="btn btn-outline btn-block" href="#">Tham Gia Discord</a>
            </div>
          </div>
        </div>
      </section>
    </main>

    <%@ include file="WEB-INF/jsp/common/footer.jspf" %>
  </div>
</body>
</html>
