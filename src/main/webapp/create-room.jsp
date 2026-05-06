
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tạo Phòng - Gomoku Zen</title>
    <link rel="stylesheet" href="assets/css/app.css" />
    <link rel="stylesheet" href="assets/css/create-room.css" />
</head>
<body>
<div class="page">
    <main class="main">
        <section class="section">
            <div class="container create-room-container">
                <div class="section-head">
                    <div>
                        <h1 class="section-title">Tạo Phòng Mới</h1>
                        <p class="section-sub">Thiết lập không gian thi đấu của riêng bạn</p>
                    </div>
                    <div class="section-accent"></div>
                </div>

                <div class="card">
                    <div class="card-head">
                        <div class="card-head-left">
                            <div class="card-head-icon">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M12 5v14" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                                    <path d="M5 12h14" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                                    <rect x="4" y="4" width="16" height="16" rx="4" stroke="currentColor" stroke-width="1.6" opacity="0.6" />
                                </svg>
                            </div>
                            <h3 class="card-head-title">Thông số phòng</h3>
                        </div>
                    </div>

                    <form class="form-wrap" action="create-room" method="POST">
                        <div class="form-group">
                            <label class="form-label" for="roomName">Tên phòng</label>
                            <input type="text" id="roomName" name="roomName" class="form-control" placeholder="Nhập tên phòng..." required />
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Kích thước</label>
                                <select name="boardSize" class="form-control">
                                    <option value="15">15 x 15 (Mặc định)</option>
                                    <option value="19">19 x 19</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Thời gian (giây)</label>
                                <select name="turnTime" class="form-control">
                                    <option value="30">30s</option>
                                    <option value="60">60s</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-actions">
                            <a href="index.jsp" class="btn btn-outline">Hủy bỏ</a>
                            <button type="submit" class="btn btn-primary">Bắt Đầu</button>
                        </div>
                    </form>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>
