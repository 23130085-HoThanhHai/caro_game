<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("activeNav", "rules"); %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Luật chơi | Gomoku Zen</title>
  <link rel="stylesheet" href="assets/css/app.css" />
</head>
<body>
  <div class="page">
    <%@ include file="WEB-INF/jsp/common/header.jspf" %>

    <main class="main" role="main">
      <section class="section" aria-label="Luật chơi">
        <div class="container section-head">
          <div>
            <h2 class="section-title">Luật Chơi</h2>
            <p class="section-sub">Hướng dẫn chi tiết, dễ hiểu để bắt đầu nhanh.</p>
          </div>
          <div class="section-accent" aria-hidden="true"></div>
        </div>

        <div class="container split-grid">
          <article class="card rules-card" aria-label="Nội dung luật chơi">
            <div class="card-head">
              <div class="card-head-left">
                <div class="card-head-icon" aria-hidden="true">
                  <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M7 3h10a2 2 0 0 1 2 2v16l-4-2-4 2-4-2-4 2V5a2 2 0 0 1 2-2Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round" />
                    <path d="M8 7h8" stroke="currentColor" stroke-width="2" stroke-linecap="round" opacity="0.7" />
                    <path d="M8 11h8" stroke="currentColor" stroke-width="2" stroke-linecap="round" opacity="0.7" />
                  </svg>
                </div>
                <h3 class="card-head-title">Cờ Caro (Gomoku) – Luật cơ bản</h3>
              </div>
              <a class="link-accent" href="index.jsp">Về sảnh</a>
            </div>

            <div class="rules-body prose">
              <h3>1) Mục tiêu</h3>
              <p>
                Mục tiêu của trò chơi là <strong>tạo được 5 quân liên tiếp</strong> theo một đường thẳng
                (ngang, dọc hoặc chéo) trước đối thủ.
              </p>

              <h3>2) Chuẩn bị</h3>
              <ul>
                <li><strong>Bàn cờ:</strong> dạng lưới (thường 15×15 hoặc lớn hơn).</li>
                <li><strong>Quân cờ:</strong> 2 loại (đen / trắng). Mỗi người dùng 1 màu.</li>
                <li><strong>Đi trước:</strong> thường là quân đen (bạn có thể tự thống nhất).</li>
              </ul>

              <h3>3) Cách chơi</h3>
              <ol>
                <li>Hai người chơi lần lượt <strong>đặt 1 quân</strong> vào một ô trống trên bàn cờ.</li>
                <li>Không được đặt chồng lên ô đã có quân.</li>
                <li>Ván đấu kết thúc khi có người thắng hoặc bàn cờ hết ô trống (hòa).</li>
              </ol>

              <h3>4) Luật thắng (theo yêu cầu của bạn)</h3>
              <div class="rules-callout" role="note">
                <div class="rules-callout-title">Quan trọng</div>
                <div>
                  <strong>Chặn 2 đầu vẫn ăn được:</strong> chỉ cần đủ <strong>5 quân liên tiếp</strong> là thắng,
                  <strong>kể cả</strong> khi hai đầu của dãy bị đối thủ chặn.
                </div>
              </div>

              <ul>
                <li><strong>Thắng ngay</strong> khi có 5 quân (hoặc nhiều hơn) liên tiếp theo hàng ngang / dọc / chéo.</li>
                <li><strong>Không cần “mở hai đầu”</strong> (khác với một số luật caro truyền thống).</li>
                <li>Nếu hai người cùng “tưởng như” thắng thì xét theo <strong>nước đi vừa đặt</strong> (người vừa đi sẽ được ưu tiên kiểm tra thắng trước).</li>
              </ul>

              <h3>5) Ví dụ nhanh (minh họa)</h3>
              <div class="rules-examples" aria-label="Ví dụ minh họa">
                <div class="rules-example">
                  <div>
                    <div class="rules-example-title">Ví dụ A — 5 liên tiếp là thắng</div>
                    <div class="rules-note">Bạn tạo 5 quân liên tiếp theo hàng ngang.</div>
                  </div>
                  <div class="rules-line" aria-label="Ví dụ A">
                    <span class="stone stone--x" aria-hidden="true"></span>
                    <span class="stone stone--x" aria-hidden="true"></span>
                    <span class="stone stone--x" aria-hidden="true"></span>
                    <span class="stone stone--x" aria-hidden="true"></span>
                    <span class="stone stone--x" aria-hidden="true"></span>
                  </div>
                </div>

                <div class="rules-example">
                  <div>
                    <div class="rules-example-title">Ví dụ B — Bị chặn 2 đầu vẫn thắng</div>
                    <div class="rules-note">Đối thủ chặn hai đầu nhưng bạn vẫn đủ 5 liên tiếp.</div>
                  </div>
                  <div class="rules-line" aria-label="Ví dụ B">
                    <span class="stone stone--o" aria-hidden="true"></span>
                    <span class="stone stone--x" aria-hidden="true"></span>
                    <span class="stone stone--x" aria-hidden="true"></span>
                    <span class="stone stone--x" aria-hidden="true"></span>
                    <span class="stone stone--x" aria-hidden="true"></span>
                    <span class="stone stone--x" aria-hidden="true"></span>
                    <span class="stone stone--o" aria-hidden="true"></span>
                  </div>
                </div>

                <div class="rules-example">
                  <div>
                    <div class="rules-example-title">Ví dụ C — 4 liên tiếp chưa thắng</div>
                    <div class="rules-note">Bạn mới có 4 quân liên tiếp, ván đấu vẫn tiếp tục.</div>
                  </div>
                  <div class="rules-line" aria-label="Ví dụ C">
                    <span class="stone stone--x" aria-hidden="true"></span>
                    <span class="stone stone--x" aria-hidden="true"></span>
                    <span class="stone stone--x" aria-hidden="true"></span>
                    <span class="stone stone--x" aria-hidden="true"></span>
                    <span class="stone stone--empty" aria-hidden="true"></span>
                  </div>
                </div>
              </div>

              <p class="rules-legend">
                Chú thích: <span class="legend"><span class="stone stone--x" aria-hidden="true"></span> Quân của bạn</span>
                <span class="legend"><span class="stone stone--o" aria-hidden="true"></span> Quân đối thủ</span>
              </p>

              <h3>6) Luật hòa</h3>
              <ul>
                <li>Nếu bàn cờ đã đầy mà chưa ai có 5 liên tiếp, ván đấu được tính là <strong>hòa</strong>.</li>
              </ul>

              <h3>7) Mẹo chơi nhanh</h3>
              <ul>
                <li>Ưu tiên tạo “thế 3” và “thế 4” để buộc đối thủ phải phòng thủ.</li>
                <li>Chú ý các đường chéo, vì đó là hướng dễ bỏ sót nhất.</li>
                <li>Khi đối thủ có 4 liên tiếp, hãy chặn ngay lập tức.</li>
              </ul>
            </div>
          </article>

          <aside class="side-stack" aria-label="Tóm tắt">
            <div class="card stat-card rules-side">
              <div class="stat-top">
                <div class="stat-icon" aria-hidden="true">
                  <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18Z" stroke="currentColor" stroke-width="2" />
                    <path d="M8.5 12.5l2.2 2.2L16 9.4" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                  </svg>
                </div>
                <div>
                  <div class="stat-label">TÓM TẮT NHANH</div>
                  <div class="stat-value">5</div>
                </div>
              </div>
              <p class="stat-desc">Mục tiêu: tạo 5 quân liên tiếp.</p>
              <ul class="rules-side-list">
                <li>5 liên tiếp là thắng (ngang/dọc/chéo).</li>
                <li>Bị chặn 2 đầu vẫn thắng.</li>
                <li>Hết ô trống mà chưa thắng: hòa.</li>
              </ul>
            </div>

            <div class="card community-card rules-side">
              <div class="card-head">
                <div class="card-head-left">
                  <div class="card-head-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                      <path d="M4 5h16v10H7l-3 3V5Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round" />
                      <path d="M8 9h8" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                      <path d="M8 12h6" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                    </svg>
                  </div>
                  <h3 class="card-head-title">Câu hỏi thường gặp</h3>
                </div>
              </div>

              <div class="rules-faq">
                <div class="rules-faq-item">
                  <div class="rules-faq-q">Có cần “không bị chặn 2 đầu” mới thắng không?</div>
                  <div class="rules-faq-a">Không. Luật của bạn là <strong>chặn 2 đầu vẫn ăn</strong> — đủ 5 liên tiếp là thắng.</div>
                </div>
                <div class="rules-faq-item">
                  <div class="rules-faq-q">6 quân liên tiếp có tính thắng không?</div>
                  <div class="rules-faq-a">Có. Chỉ cần có ít nhất <strong>5</strong> quân liên tiếp.</div>
                </div>
              </div>

              <a class="btn btn-outline btn-block" href="index.jsp#modes">Bắt đầu chơi</a>
            </div>
          </aside>
        </div>
      </section>
    </main>

    <%@ include file="WEB-INF/jsp/common/footer.jspf" %>
  </div>
</body>
</html>
