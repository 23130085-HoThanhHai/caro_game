<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Phòng Chờ - Gomoku Zen</title>
    <link rel="stylesheet" href="assets/css/app.css" />
    <link rel="stylesheet" href="assets/css/room-detail.css" />
</head>
<body>
<div class="page">
    <main class="main">
        <section class="section">
            <div class="container room-container">
                <div class="room-header">
                    <div class="room-title-wrap">
                        <h1 class="room-title">${not empty roomName ? roomName : 'Phòng Của Bạn'}</h1>
                        <span class="room-badge">Đang chờ đối thủ</span>
                    </div>
                    <div class="room-actions">
                        <a href="index.jsp" class="btn btn-outline">Rời phòng</a>
                    </div>
                </div>

                <div class="room-grid">
                    <div class="card room-main">
                        <div class="card-head">
                            <h3 class="card-head-title">Người chơi</h3>
                        </div>

                        <div class="players-wrap">
                            <div class="player-card is-host">
                                <div class="player-avatar">
                                    <div class="avatar avatar--one"></div>
                                    <div class="stone-icon stone--x"></div>
                                </div>
                                <div class="player-info">
                                    <div class="player-name">Bạn (Chủ phòng)</div>
                                    <div class="player-elo">ELO: 1200</div>
                                </div>
                                <div class="player-status is-ready">Sẵn sàng</div>
                            </div>

                            <div class="vs-divider">VS</div>

                            <div class="player-card is-waiting">
                                <div class="player-avatar">
                                    <div class="avatar-placeholder">
                                        <div class="spinner"></div>
                                    </div>
                                </div>
                                <div class="player-info">
                                    <div class="player-name">Đang tìm kiếm...</div>
                                    <div class="player-elo">Đang đợi người chơi tham gia</div>
                                </div>
                            </div>
                        </div>

                        <div class="start-action">
                            <button class="btn btn-primary btn-lg btn-block" disabled>
                                Bắt Đầu Trận Đấu
                            </button>
                        </div>
                    </div>

                    <div class="card room-sidebar">
                        <div class="card-head">
                            <h3 class="card-head-title">Thông tin phòng</h3>
                        </div>
                        <div class="info-list">
                            <div class="info-item">
                                <div class="info-label">Mã phòng</div>
                                <div class="info-value txt-accent">#894A2</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Kích thước bàn</div>
                                <div class="info-value">${not empty boardSize ? boardSize : '15'} x ${not empty boardSize ? boardSize : '15'}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Thời gian/Nước</div>
                                <div class="info-value">${not empty turnTime ? turnTime : '30'} giây</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Luật chơi</div>
                                <div class="info-value">Tiêu chuẩn</div>
                            </div>
                        </div>

                        <div class="share-box">
                            <div class="info-label">Chia sẻ mã mời</div>
                            <div class="share-input-wrap">
                                <input type="text" value="https://gomokuzen.com/join/894A2" readonly class="form-control" />
                                <button class="btn btn-primary copy-btn">Copy</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>