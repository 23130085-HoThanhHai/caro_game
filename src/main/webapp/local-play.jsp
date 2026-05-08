<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chơi 2 Người - Gomoku Zen</title>
    <link rel="stylesheet" href="assets/css/app.css" />
    <link rel="stylesheet" href="assets/css/local-play.css" />
</head>
<body>
<div class="page">
    <main class="main">
        <section class="section">
            <div class="container game-container">
                <div class="game-header">
                    <a href="index.jsp" class="btn btn-outline btn-back">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M19 12H5" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                            <path d="M12 19l-7-7 7-7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                        Thoát
                    </a>
                    <h1 class="game-title">Thi Đấu Trực Tiếp</h1>
                    <button class="btn btn-primary">Chơi Mới</button>
                </div>

                <div class="game-layout">
                    <div class="players-status">
                        <div class="player-box is-active" id="box-black">
                            <div class="player-stone stone-black"></div>
                            <div class="player-info">
                                <div class="player-name">Người chơi 1</div>
                                <div class="player-stats">
                                    <span class="score">Điểm: <strong id="score-black">0</strong></span>
                                    <span class="timer hidden" id="timer-black">30s</span>
                                </div>
                                <div class="turn-indicator">Đang đi...</div>
                            </div>
                        </div>

                        <div class="vs-text">VS</div>

                        <div class="player-box" id="box-white">
                            <div class="player-info" style="text-align: right;">
                                <div class="player-name">Người chơi 2</div>
                                <div class="player-stats">
                                    <span class="timer hidden" id="timer-white">30s</span>
                                    <span class="score">Điểm: <strong id="score-white">0</strong></span>
                                </div>
                                <div class="turn-indicator">Chờ lượt</div>
                            </div>
                            <div class="player-stone stone-white"></div>
                        </div>
                    </div>

                    <div class="board-wrapper">
                        <div class="caro-board">
                            <% for(int i = 0; i < 225; i++) { %>
                            <button class="caro-cell" data-index="<%= i %>">
                                <span class="stone-slot"></span>
                            </button>
                            <% } %>
                        </div>
                    </div>

                    <div class="game-controls">
                        <button class="btn btn-outline">
                            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                                <polyline points="9 22 9 12 15 12 15 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></polyline>
                            </svg>
                            Xin hòa
                        </button>
                        <button class="btn btn-outline">
                            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M3 3h18v18H3z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                                <path d="M9 9l6 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                                <path d="M15 9l-6 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                            </svg>
                            Nhận thua
                        </button>
                        <button class="btn btn-outline">
                            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                                <path d="M3 3v5h5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                            </svg>
                            Đi lại
                        </button>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>
<div id="custom-modal" class="modal-overlay hidden">
    <div class="modal-box">
        <h3 id="modal-title" class="modal-title">Thông báo</h3>
        <p id="modal-message" class="modal-message">Nội dung thông báo</p>
        <div id="modal-actions" class="modal-actions">
        </div>
    </div>
</div>
<audio id="sound-move" src="assets/audio/move.mp3" preload="auto"></audio>
<audio id="sound-win" src="assets/audio/win.mp3" preload="auto"></audio>
<audio id="sound-timeout" src="assets/audio/timeout.mp3" preload="auto"></audio>
<script src="assets/js/local-play.js"></script>
</body>
</html>