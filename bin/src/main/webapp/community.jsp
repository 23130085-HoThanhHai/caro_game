<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("activeNav", "community"); %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Cộng đồng | Gomoku Zen</title>
  <link rel="stylesheet" href="assets/css/app.css" />
</head>
<body>
  <div class="page">
    <%@ include file="WEB-INF/jsp/common/header.jspf" %>

    <main class="main" role="main">
      <section class="section" aria-label="Cộng đồng">
        <div class="container section-head">
          <div>
            <h2 class="section-title">Cộng Đồng</h2>
            <p class="section-sub">Nơi trao đổi chiến thuật, cập nhật sự kiện và kết nối người chơi.</p>
          </div>
          <div class="section-accent" aria-hidden="true"></div>
        </div>

        <div class="container split-grid">
          <div class="card community-card" aria-label="Hoạt động cộng đồng">
            <div class="card-head">
              <div class="card-head-left">
                <div class="card-head-icon" aria-hidden="true">
                  <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M4 5h16v10H7l-3 3V5Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round" />
                    <path d="M8 9h8" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                    <path d="M8 12h6" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                  </svg>
                </div>
                <h3 class="card-head-title">Hoạt động cộng đồng</h3>
              </div>
              <div class="lb-sub">Cập nhật mỗi ngày</div>
            </div>

            <div class="community-list" aria-label="Danh mục">
              <a class="community-item" href="#" aria-label="Thảo luận chiến thuật">
                <div class="community-icon" aria-hidden="true">
                  <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M4 5h16v10H7l-3 3V5Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round" />
                    <path d="M8 9h8" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                    <path d="M8 12h6" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                  </svg>
                </div>
                <div>
                  <div class="community-title">Thảo luận chiến thuật</div>
                  <div class="lb-sub">42 bài viết mới hôm nay</div>
                </div>
              </a>

              <a class="community-item" href="#" aria-label="Giải đấu Master Zen">
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
              </a>

              <a class="community-item" href="#" aria-label="Hỏi đáp tân thủ">
                <div class="community-icon" aria-hidden="true">
                  <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M7 3h10a2 2 0 0 1 2 2v16l-4-2-4 2-4-2-4 2V5a2 2 0 0 1 2-2Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round" />
                    <path d="M9 8h6" stroke="currentColor" stroke-width="2" stroke-linecap="round" opacity="0.7" />
                    <path d="M9 12h6" stroke="currentColor" stroke-width="2" stroke-linecap="round" opacity="0.7" />
                  </svg>
                </div>
                <div>
                  <div class="community-title">Hỏi đáp tân thủ</div>
                  <div class="lb-sub">Đặt câu hỏi, nhận trợ giúp nhanh</div>
                </div>
              </a>

              <a class="community-item" href="#" aria-label="Góp ý & báo lỗi">
                <div class="community-icon" aria-hidden="true">
                  <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18Z" stroke="currentColor" stroke-width="2" />
                    <path d="M12 8v5" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                    <path d="M12 16h.01" stroke="currentColor" stroke-width="3" stroke-linecap="round" />
                  </svg>
                </div>
                <div>
                  <div class="community-title">Góp ý &amp; báo lỗi</div>
                  <div class="lb-sub">Giúp Gomoku Zen tốt hơn mỗi ngày</div>
                </div>
              </a>
            </div>

            <a class="btn btn-outline btn-block" href="#">Tham Gia Discord</a>
          </div>

          <aside class="side-stack" aria-label="Thông tin cộng đồng">
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

            <div class="card community-card" aria-label="Quy tắc cộng đồng">
              <div class="card-head">
                <div class="card-head-left">
                  <div class="card-head-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                      <path d="M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18Z" stroke="currentColor" stroke-width="2" />
                      <path d="M8.5 12.5l2.2 2.2L16 9.4" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                    </svg>
                  </div>
                  <h3 class="card-head-title">Quy tắc cộng đồng</h3>
                </div>
              </div>

              <div class="prose">
                <ul>
                  <li>Tôn trọng mọi người chơi, không công kích cá nhân.</li>
                  <li>Không spam, không quảng cáo.</li>
                  <li>Không chia sẻ thông tin cá nhân nhạy cảm.</li>
                  <li>Nếu gặp vấn đề, hãy đăng ở mục “Góp ý &amp; báo lỗi”.</li>
                </ul>
              </div>

              <a class="btn btn-outline btn-block" href="rules.jsp">Xem luật chơi</a>
            </div>
          </aside>
        </div>
      </section>
    </main>

    <%@ include file="WEB-INF/jsp/common/footer.jspf" %>
  </div>
</body>
</html>
