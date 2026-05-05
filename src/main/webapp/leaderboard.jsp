<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("activeNav", "leaderboard"); %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Bảng xếp hạng | Gomoku Zen</title>
  <link rel="stylesheet" href="assets/css/app.css" />
</head>
<body>
  <div class="page">
    <%@ include file="WEB-INF/jsp/common/header.jspf" %>

    <main class="main" role="main">
      <section class="section" aria-label="Bảng xếp hạng">
        <div class="container section-head">
          <div>
            <h2 class="section-title">Bảng Xếp Hạng</h2>
            <p class="section-sub">Top 10 người chơi nổi bật.</p>
          </div>
          <div class="section-accent" aria-hidden="true"></div>
        </div>

        <div class="container">
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
                <h3 class="card-head-title">Top 10</h3>
              </div>
              <div class="lb-sub">Cập nhật theo tuần</div>
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

              <div class="lb-row">
                <div class="lb-rank">04</div>
                <div class="lb-player">
                  <div class="avatar" aria-hidden="true"></div>
                  <div>
                    <div class="lb-name">Quang Huy</div>
                    <div class="lb-sub">ELO: 2,210</div>
                  </div>
                </div>
                <div class="lb-metric">
                  <div class="lb-rate">77%</div>
                  <div class="lb-sub">Tỷ lệ thắng</div>
                </div>
              </div>

              <div class="lb-row">
                <div class="lb-rank">05</div>
                <div class="lb-player">
                  <div class="avatar" aria-hidden="true"></div>
                  <div>
                    <div class="lb-name">Bảo Ngân</div>
                    <div class="lb-sub">ELO: 2,180</div>
                  </div>
                </div>
                <div class="lb-metric">
                  <div class="lb-rate">75%</div>
                  <div class="lb-sub">Tỷ lệ thắng</div>
                </div>
              </div>

              <div class="lb-row">
                <div class="lb-rank">06</div>
                <div class="lb-player">
                  <div class="avatar" aria-hidden="true"></div>
                  <div>
                    <div class="lb-name">Khánh Linh</div>
                    <div class="lb-sub">ELO: 2,140</div>
                  </div>
                </div>
                <div class="lb-metric">
                  <div class="lb-rate">73%</div>
                  <div class="lb-sub">Tỷ lệ thắng</div>
                </div>
              </div>

              <div class="lb-row">
                <div class="lb-rank">07</div>
                <div class="lb-player">
                  <div class="avatar" aria-hidden="true"></div>
                  <div>
                    <div class="lb-name">Gia Bảo</div>
                    <div class="lb-sub">ELO: 2,120</div>
                  </div>
                </div>
                <div class="lb-metric">
                  <div class="lb-rate">72%</div>
                  <div class="lb-sub">Tỷ lệ thắng</div>
                </div>
              </div>

              <div class="lb-row">
                <div class="lb-rank">08</div>
                <div class="lb-player">
                  <div class="avatar" aria-hidden="true"></div>
                  <div>
                    <div class="lb-name">Thảo Vy</div>
                    <div class="lb-sub">ELO: 2,090</div>
                  </div>
                </div>
                <div class="lb-metric">
                  <div class="lb-rate">70%</div>
                  <div class="lb-sub">Tỷ lệ thắng</div>
                </div>
              </div>

              <div class="lb-row">
                <div class="lb-rank">09</div>
                <div class="lb-player">
                  <div class="avatar" aria-hidden="true"></div>
                  <div>
                    <div class="lb-name">Hồng Phúc</div>
                    <div class="lb-sub">ELO: 2,060</div>
                  </div>
                </div>
                <div class="lb-metric">
                  <div class="lb-rate">68%</div>
                  <div class="lb-sub">Tỷ lệ thắng</div>
                </div>
              </div>

              <div class="lb-row">
                <div class="lb-rank">10</div>
                <div class="lb-player">
                  <div class="avatar" aria-hidden="true"></div>
                  <div>
                    <div class="lb-name">Tuấn Anh</div>
                    <div class="lb-sub">ELO: 2,030</div>
                  </div>
                </div>
                <div class="lb-metric">
                  <div class="lb-rate">66%</div>
                  <div class="lb-sub">Tỷ lệ thắng</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <%@ include file="WEB-INF/jsp/common/footer.jspf" %>
  </div>
</body>
</html>
