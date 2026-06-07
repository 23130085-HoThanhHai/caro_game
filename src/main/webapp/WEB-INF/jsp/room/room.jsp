<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="vn.edu.hcmuaf.fit.demo3.model.Room" %>
<%@ page import="vn.edu.hcmuaf.fit.demo3.model.RoomPlayer" %>
<%
  request.setAttribute("activeNav", "");
  Room room = (Room) request.getAttribute("room");
  Long currentUserId = (Long) request.getAttribute("currentUserId");
%>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Phòng <%= room != null ? room.getRoomCode() : "" %> | Gomoku Zen</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/app.css" />
  <style>
    .room-layout { display:grid; grid-template-columns: 1fr 320px; gap:18px; }
    .board { display:grid; gap:0; background:#fff; border:1px solid #e5e7eb; border-radius:10px; padding:8px; grid-template-columns: repeat(var(--board-size), 1fr); }
    .cell { width:30px; height:30px; border:1px solid rgba(16,24,40,0.1); background:#fff; cursor:pointer; display:flex; align-items:center; justify-content:center; font-size:20px; position: relative; }
    .cell.win-cell { background: rgba(241,196,15,0.25); }
    .stone {
      width: 22px;
      height: 22px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      animation: stonePlace 0.25s ease-out;
      box-shadow: 0 2px 6px rgba(0,0,0,0.15);
    }
    .stone-player {
      background: linear-gradient(135deg, #1abc9c 0%, #16a085 100%);
      color: white;
    }
    .stone-bot {
      background: linear-gradient(135deg, #2c3e50 0%, #1a252f 100%);
      color: white;
    }
    @keyframes stonePlace {
      0% { transform: scale(0.3); opacity: 0; }
      100% { transform: scale(1); opacity: 1; }
    }
    .btn-replay {
      display: none;
      margin-top: 8px;
      width: 100%;
      padding: 9px 12px;
      border: none;
      border-radius: 10px;
      font-weight: 700;
      cursor: pointer;
      background: var(--accent);
      color: #fff;
    }
    .meta { color:#667085; font-size:13px; }
    @media (max-width: 980px) { .room-layout { grid-template-columns: 1fr; } }

    /* Blue dot indicator over the absolute last move played */
    .cell.last-move-cell::after {
      content: '';
      position: absolute;
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background-color: #2196F3;
      box-shadow: 0 0 6px #2196F3;
      z-index: 10;
      pointer-events: none;
    }

    /* Scrollable Move History notation board */
    .move-log-box {
      height: 160px;
      overflow-y: auto;
      border: 1px solid #eaecf0;
      border-radius: 8px;
      padding: 8px 12px;
      background: #f8f9fa;
      font-family: monospace;
      font-size: 13px;
    }
    .move-log-row {
      display: flex;
      justify-content: space-between;
      padding: 4px 0;
      border-bottom: 1px solid #f2f4f7;
    }
  </style>
</head>
<body>
<div class="page">
  <%@ include file="/WEB-INF/jsp/common/header.jspf" %>
  <main class="main" role="main">
    <section class="section">
      <div class="container" style="max-width: 900px;">
        <% if (room == null) { %>
        <div class="card" style="padding:20px;">Không tìm thấy phòng.</div>
        <% } else { %>
        <div class="card" style="padding:20px; margin-bottom:14px;">
          <h2 class="section-title" style="margin-bottom:6px;"><%= room.getName() %></h2>
          <div class="section-sub">Mã phòng: <strong><%= room.getRoomCode() %></strong></div>
        </div>

        <div class="room-layout">
          <div class="card" style="padding:12px;">
            <div id="board" class="board" style="--board-size:<%= room.getBoardSize() %>;">
              <% for (int y = 0; y < room.getBoardSize(); y++) {
                   for (int x = 0; x < room.getBoardSize(); x++) { %>
                <div class="cell" data-x="<%= x %>" data-y="<%= y %>"></div>
              <%   }
                 } %>
            </div>
          </div>

          <div style="display:grid; gap:14px;">
            <div class="card" style="padding:20px; display:grid; gap:8px;">
                <%-- Làm nổi bật và thêm nút "Copy" Mã Phòng (room.jsp) Phạm Quốc Đăng --%>
                <div style="background: #fffbeb; border: 1px dashed #f59e0b; padding: 12px; border-radius: 8px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                    <div>
                        <div style="font-size: 13px; color: #92400e; margin-bottom: 4px;">Mã phòng của bạn:</div>
                        <strong id="roomCodeText" style="font-size: 24px; color: #b45309; letter-spacing: 2px;"><%= room.getRoomCode() %></strong>
                    </div>
                    <button onclick="copyRoomCode()" class="btn btn-primary" type="button" style="padding: 8px 12px; font-size: 14px; display: flex; align-items: center; gap: 6px;">
                        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                            <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                        </svg>
                        Copy
                    </button>
                </div>

                <script>
                    function copyRoomCode() {
                        const code = document.getElementById('roomCodeText').innerText;
                        navigator.clipboard.writeText(code).then(() => {
                            alert('Đã sao chép mã phòng: ' + code);
                        }).catch(err => {
                            console.error('Không thể sao chép', err);
                        });
                    }
                </script>
              <div><strong>Trạng thái:</strong> <span id="statusText"><%= room.getStatus() %></span></div>
              <div><strong>Kích thước:</strong> <%= room.getBoardSize() %>x<%= room.getBoardSize() %></div>
              <div><strong>Số người:</strong> <span id="playersJoined"><%= room.getPlayers().size() %></span>/2</div>
              <div><strong>Lượt:</strong> <span id="turnText">Đang tải...</span></div>
              <div id="gameMessage" class="meta"></div>
              <button id="replayBtn" class="btn-replay" type="button" onclick="restartGame()">Chơi lại</button>
            </div>

            <div class="card" style="padding:20px;">
              <h3 style="margin-top:0; font-size:15px; margin-bottom:10px;">Biên bản trận đấu</h3>
              <div id="moveLog" class="move-log-box">
                <div style="color:#667085; text-align:center; padding-top:60px;">Chưa có nước đi nào</div>
              </div>
            </div>

            <div class="card" style="padding:20px;">
              <h3 style="margin-top:0;">Người chơi trong phòng</h3>
              <div style="display:grid; gap:8px;">
                <% for (RoomPlayer p : room.getPlayers()) { %>
                  <div style="padding:10px; border:1px solid #eee; border-radius:8px;">
                    <strong><%= p.shownName() %></strong>
                    <% if (currentUserId != null && p.userId() == currentUserId) { %>
                      <span style="color:#b45309;">(Bạn)</span>
                    <% } %>
                    - Vai trò: <%= p.role() %>
                  </div>
                <% } %>
              </div>
              <p style="margin-top:8px; color:#667085; font-size:13px;">Người chơi khác nhập mã phòng để vào ngay.</p>
            </div>


              <div class="card" style="padding:20px;">
                  <h3 style="margin-top:0;">Chat phòng</h3>

                  <div id="chatMessages"
                       style="height:250px;
                overflow-y:auto;
                border:1px solid #eee;
                padding:10px;
                border-radius:8px;
                margin-bottom:10px;">


        <%@ page import="java.util.List" %>
        <%@ page import="vn.edu.hcmuaf.fit.demo3.model.ChatMessage" %>

        <%
                        List<ChatMessage> messages = (List<ChatMessage>) request.getAttribute("messages");

                        if(messages != null){
                        for(ChatMessage msg : messages){
        %>

                    <div style="margin-bottom:8px;">
                        <strong>
                            <%= msg.getSenderUsername() %>
                        </strong>
        :
                        <%= msg.getMessageText() %>
                    </div>

        <%
            }
        }
        %>

                  </div>

                  <form id="chatForm">

                      <input type="hidden"
                             id="roomId"
                             value="<%= room.getId() %>">

                      <input type="text"
                             id="messageText"
                             placeholder="Nhập tin nhắn..."
                             maxlength="500"
                             style="width:100%;
                      padding:10px;
                      border:1px solid #ddd;
                      border-radius:8px;" />

                      <button class="btn btn-primary"
                              type="submit"
                              style="margin-top:10px;width:100%;">
                          Gửi
                      </button>


                  </form>
              </div>


            <a class="btn btn-ghost" href="<%= request.getContextPath() %>/index.jsp" style="text-align:center;">Về sảnh</a>
          </div>
        </div>
        <% } %>
      </div>
    </section>
  </main>
  <%@ include file="/WEB-INF/jsp/common/footer.jspf" %>
</div>
<script>
  const roomCode = '<%= room != null ? room.getRoomCode() : "" %>';
  const contextPath = '<%= request.getContextPath() %>';
  let latestState = null;
  let renderedBoard = null;
  let isSending = false;

  // Added: Audio playback data management references
  let cachedMoveCount = 0;
  let endMatchAudioTriggered = false;

  const gameAudioEngine = {
    stone: new Audio(contextPath + '/assets/audio/stone.mp3'),
    win: new Audio(contextPath + '/assets/audio/win.mp3'),
    lose: new Audio(contextPath + '/assets/audio/lose.mp3'),
    draw: new Audio(contextPath + '/assets/audio/draw.mp3')
  };

  function triggerGameSound(trackName) {
    const asset = gameAudioEngine[trackName];
    if (asset) {
      asset.currentTime = 0;
      asset.play().catch(e => console.log("Audio deferred until context block interaction click: ", e));
    }
  }

  document.addEventListener('DOMContentLoaded', () => {
    bindBoard();
    refreshState();
    setInterval(refreshState, 2000);
  });

  function bindBoard() {
    const board = document.getElementById('board');
    if (!board) return;
    board.addEventListener('click', (e) => {
      const cell = e.target.closest('.cell');
      if (!cell || isSending) return;
      const x = Number(cell.dataset.x);
      const y = Number(cell.dataset.y);
      sendMove(x, y);
    });
  }

  async function refreshState() {
    const res = await fetch(contextPath + '/room-play?code=' + encodeURIComponent(roomCode));
    const data = await res.json();
    if (!data.success) return;
    latestState = data.state;
    renderState();
  }

  async function sendMove(x, y) {
    if (!latestState) return;
    if (latestState.playersJoined < 2) return;
    if (latestState.gameStatus === 'FINISHED') return;
    if (latestState.yourPlayerNo !== latestState.currentPlayerNo) return;

    isSending = true;
    try {
      const body = 'action=move&code=' + encodeURIComponent(roomCode) + '&x=' + x + '&y=' + y;
      const res = await fetch(contextPath + '/room-play', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body
      });
      const data = await res.json();
      if (!data.success) {
        alert(data.error || 'Không thể đánh nước này');
        return;
      }
      latestState = data.state;
      renderState();
    } finally {
      isSending = false;
    }
  }

  function renderState() {
    if (!latestState) return;
    const statusText = document.getElementById('statusText');
    const playersJoined = document.getElementById('playersJoined');
    const turnText = document.getElementById('turnText');
    const msg = document.getElementById('gameMessage');

    if (statusText) statusText.textContent = latestState.gameStatus;
    if (playersJoined) playersJoined.textContent = latestState.playersJoined;
    if (msg) msg.textContent = latestState.message || '';

    if (turnText) {
      if (latestState.playersJoined < 2) turnText.textContent = 'Chờ người chơi 2';
      else if (latestState.gameStatus === 'FINISHED') {
        turnText.textContent = 'Ván đã kết thúc';
      } else {
        turnText.textContent = latestState.currentPlayerNo === 1 ? 'Người chơi 1' : 'Người chơi 2';
      }
    }

    const boardCells = document.querySelectorAll('#board .cell');
    const replayBtn = document.getElementById('replayBtn');
    const nextBoard = latestState.board;
    boardCells.forEach(cell => {
      const x = Number(cell.dataset.x);
      const y = Number(cell.dataset.y);
      const value = nextBoard[y][x];
      const prev = renderedBoard ? renderedBoard[y][x] : null;
      if (prev !== value) {
        if (value === 1) cell.innerHTML = "<div class='stone stone-player'>●</div>";
        else if (value === 2) cell.innerHTML = "<div class='stone stone-bot'>●</div>";
        else cell.innerHTML = "";
      }
      cell.classList.remove('win-cell');
      cell.classList.remove('last-move-cell'); // Added: Reset tracking dot class on loop passes
    });
    renderedBoard = nextBoard.map(row => row.slice());

    if (Array.isArray(latestState.winningCells)) {
      latestState.winningCells.forEach(([x, y]) => {
        const target = document.querySelector('#board .cell[data-x="' + x + '"][data-y="' + y + '"]');
        if (target) target.classList.add('win-cell');
      });
    }

    // Added: Highlight absolute newest array coordinates index
    if (Array.isArray(latestState.moves) && latestState.moves.length > 0) {
      const lastMove = latestState.moves[latestState.moves.length - 1];
      const lastCell = document.querySelector(`#board .cell[data-x="${lastMove[0]}"][data-y="${lastMove[1]}"]`);
      if (lastCell) {
        lastCell.classList.add('last-move-cell');
      }
    }

    // Added: Chronological step list engine loop parsing positions to algebraic notations
    const logBox = document.getElementById('moveLog');
    if (logBox && Array.isArray(latestState.moves) && latestState.moves.length > 0) {
      let rowsHtml = "";
      for (let i = 0; i < latestState.moves.length; i += 2) {
        const p1Move = latestState.moves[i];
        const p1Notation = String.fromCharCode(65 + p1Move[0]) + (p1Move[1] + 1);
        
        let p2Notation = "";
        if (i + 1 < latestState.moves.length) {
          const p2Move = latestState.moves[i + 1];
          p2Notation = String.fromCharCode(65 + p2Move[0]) + (p2Move[1] + 1);
        }
        
        rowsHtml += `
          <div class="move-log-row">
            <span style="color:#667085;">Nước ${Math.floor(i/2) + 1}</span>
            <span style="font-weight:600; color:#1abc9c;">${p1Notation}</span>
            <span style="font-weight:600; color:#2c3e50;">${p2Notation || '--'}</span>
          </div>`;
      }
      logBox.innerHTML = rowsHtml;
      logBox.scrollTop = logBox.scrollHeight;
    } else if (logBox) {
      logBox.innerHTML = `<div style="color:#667085; text-align:center; padding-top:60px;">Chưa có nước đi nào</div>`;
    }

    if (latestState.gameStatus === 'FINISHED') {
      if (replayBtn) replayBtn.style.display = 'block';

      // Added: Over-state physical audios tracker triggers exactly once at completion boundaries
      if (!endMatchAudioTriggered) {
        if (latestState.result === 'DRAW') {
          triggerGameSound('draw');
        } else {
          const winnerNo = (latestState.result === 'P1_WIN') ? 1 : 2;
          if (latestState.yourPlayerNo === winnerNo) {
            triggerGameSound('win');
          } else {
            triggerGameSound('lose');
          }
        }
        endMatchAudioTriggered = true;
      }
    } else {
      if (replayBtn) replayBtn.style.display = 'none';
      endMatchAudioTriggered = false;

      // Added: Piece landing clip triggers when lengths scale higher
      if (Array.isArray(latestState.moves) && latestState.moves.length > cachedMoveCount) {
        if (cachedMoveCount > 0) {
          triggerGameSound('stone');
        }
      }
    }

    cachedMoveCount = Array.isArray(latestState.moves) ? latestState.moves.length : 0;
  }

  async function restartGame() {
    if (!latestState || latestState.playersJoined < 2) return;
    if (!confirm('Bắt đầu ván mới với 2 người hiện tại?')) return;
    const body = 'action=restart&code=' + encodeURIComponent(roomCode);
    const res = await fetch(contextPath + '/room-play', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body
    });
    const data = await res.json();
    if (!data.success) {
      alert(data.error || 'Không thể chơi lại');
      return;
    }
    latestState = data.state;
    renderState();
  }


  document
      .getElementById("chatForm")
      .addEventListener(
          "submit",
          async function(e){

              e.preventDefault();

              const roomId =
                  document.getElementById("roomId").value;

              const message =
                  document.getElementById("messageText").value;

              if(!message.trim()){
                  return;
              }

              const body =
                  "roomId="
                  + encodeURIComponent(roomId)
                  + "&message="
                  + encodeURIComponent(message);

              const response =
                  await fetch(
                      "<%=request.getContextPath()%>/chat/send",
                      {
                          method:"POST",
                          headers:{
                              "Content-Type":
                                  "application/x-www-form-urlencoded"
                          },
                          body:body
                      });

              const result =
                  await response.json();

              if(result.success){

                  document
                      .getElementById("messageText")
                      .value = "";

                  await loadMessages();
              }
          });
  async function loadMessages(){

      const roomId =
          document.getElementById(
              "roomId").value;

      const response =
          await fetch(
              "<%=request.getContextPath()%>"
              + "/chat/messages?roomId="
              + roomId);

      const messages = await response.json();

      console.log(messages);

      const chatBox =
          document.getElementById(
              "chatMessages");

      chatBox.innerHTML = "";

      messages.forEach(msg => {

          chatBox.innerHTML += `
            <div>
                <strong>
                    ${msg.senderUsername ? msg.senderUsername : "System"}
                </strong> :
                ${msg.messageText}
            </div>
        `;
      });

      chatBox.scrollTop =
          chatBox.scrollHeight;
  }

  setInterval(loadMessages,2000);

  loadMessages();


</script>
</body>
</html>