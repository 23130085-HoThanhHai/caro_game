document.addEventListener("DOMContentLoaded", () => {
    // --- CẤU HÌNH TRÒ CHƠI ---
    const BOARD_SIZE = 15;
    const TOTAL_CELLS = BOARD_SIZE * BOARD_SIZE;
    const TIME_PER_TURN = 30; // 30 giây mỗi lượt

    // --- TRẠNG THÁI TRÒ CHƠI ---
    let boardState = Array(TOTAL_CELLS).fill(null);
    let currentPlayer = 'black';
    let isGameOver = false;
    let moveHistory = [];

    // Trạng thái nâng cấp
    let scores = { black: 0, white: 0 };
    let timerInterval;
    let timeLeft = TIME_PER_TURN;

    // --- DOM ELEMENTS ---
    const boardElement = document.querySelector(".caro-board");
    const cells = document.querySelectorAll(".caro-cell");
    const playerBoxes = document.querySelectorAll(".player-box");

    const uiScoreBlack = document.getElementById("score-black");
    const uiScoreWhite = document.getElementById("score-white");
    const uiTimerBlack = document.getElementById("timer-black");
    const uiTimerWhite = document.getElementById("timer-white");

    const btnNewGame = document.querySelector(".game-header .btn-primary");
    const controlButtons = document.querySelectorAll(".game-controls .btn-outline");
    const btnDraw = controlButtons[0];
    const btnResign = controlButtons[1];
    const btnUndo = controlButtons[2];

    // Audio Elements
    const soundMove = document.getElementById("sound-move");
    const soundWin = document.getElementById("sound-win");
    const soundTimeout = document.getElementById("sound-timeout");

    // Modal Elements
    const modalOverlay = document.getElementById("custom-modal");
    const modalTitle = document.getElementById("modal-title");
    const modalMessage = document.getElementById("modal-message");
    const modalActions = document.getElementById("modal-actions");

    // --- KHỞI TẠO SỰ KIỆN ---
    initGame();

    function initGame() {
        cells.forEach(cell => {
            cell.addEventListener("click", handleCellClick);
        });

        btnNewGame.addEventListener("click", () => {
            if (moveHistory.length > 0 && !isGameOver) {
                showModal("Chơi mới", "Bạn có chắc chắn muốn hủy ván hiện tại?", [
                    { text: "Hủy", class: "btn-cancel" },
                    { text: "Đồng ý", class: "btn-confirm", onClick: resetGame }
                ]);
            } else {
                resetGame();
            }
        });

        btnUndo.addEventListener("click", undoMove);
        btnResign.addEventListener("click", resignGame);
        btnDraw.addEventListener("click", proposeDraw);

        // Cập nhật class hover ban đầu
        boardElement.classList.add("turn-black");
        startTimer();
    }

    // --- XỬ LÝ CLICK Ô CỜ ---
    function handleCellClick(e) {
        // [UC-05: Điều kiện tiên quyết] Kiểm tra trạng thái trò chơi
        if (isGameOver) return;

        // [UC-05.1] Người chơi chọn một ô trống bằng cách click chuột
        const cell = e.currentTarget;

        // [UC-05.2] Hệ thống xác định vị trí của ô thông qua thuộc tính data-index
        const index = parseInt(cell.getAttribute("data-index"));

        // [UC-05.3 / A1.1] Hệ thống kiểm tra và xác nhận ô được chọn hiện tại đang trống
        // [A1.2] Nếu ô đã có quân cờ (boardState[index] !== null), hệ thống bỏ qua sự kiện click
        if (boardState[index] !== null) return;

        // [UC-05.4] Hệ thống phát âm thanh đánh cờ (soundMove)
        if(soundMove) {
            soundMove.currentTime = 0;
            soundMove.play().catch(e => console.log("Audio play prevented"));
        }

        // [UC-05.5] Hệ thống ghi nhận nước đi vào trạng thái bàn cờ và hiển thị quân cờ
        boardState[index] = currentPlayer;
        cell.classList.add(`has-${currentPlayer}`);

        // [UC-05.6] Hệ thống lưu nước đi vào lịch sử di chuyển (moveHistory)
        moveHistory.push(index);

        // [UC-05.7] Hệ thống kiểm tra điều kiện thắng hoặc hòa
        const winCombo = checkWin(index);

        // [A2] Luồng thay thế: Người chơi giành chiến thắng
        if (winCombo) {
            // [A2.1 -> A2.5] Xử lý thắng: phát âm thanh, highlight, cập nhật điểm và kết thúc game
            handleWin(currentPlayer, winCombo);
            return;
        }

        // [A3] Luồng thay thế: Trận đấu hòa (Hết ô trống)
        // [A3.6] Kiểm tra nếu moveHistory.length === TOTAL_CELLS (225 ô)
        if (moveHistory.length === TOTAL_CELLS) {
            // [A3.7] Hiển thị thông báo hòa và kết thúc trò chơi
            endGame("Hòa Nhau!", "Bàn cờ đã kín, trận đấu kết thúc với kết quả Hòa!");
            return;
        }

        // [UC-05.8] Luồng chính: Hệ thống thực hiện chuyển lượt (switchTurn)
        switchTurn();
    }

    // --- ĐỔI LƯỢT ---
    function switchTurn() {
        // [UC-05.8] Đổi quân cờ của người chơi hiện tại
        currentPlayer = currentPlayer === 'black' ? 'white' : 'black';

        boardElement.classList.remove("turn-black", "turn-white");
        boardElement.classList.add(`turn-${currentPlayer}`);

        // [UC-05.8] Cập nhật giao diện người chơi đang hoạt động (is-active)
        if (currentPlayer === 'black') {
            playerBoxes[0].classList.add("is-active");
            playerBoxes[1].classList.remove("is-active");
        } else {
            playerBoxes[1].classList.add("is-active");
            playerBoxes[0].classList.remove("is-active");
        }

        // [UC-05.8] Đặt lại và khởi động đồng hồ đếm ngược (30 giây)
        startTimer();
    }

    // --- ĐỒNG HỒ ĐẾM NGƯỢC ---
    function startTimer() {
        clearInterval(timerInterval);
        timeLeft = TIME_PER_TURN; // 30 giây
        updateTimerUI();

        timerInterval = setInterval(() => {
            timeLeft--;
            updateTimerUI();

            // [A4] Luồng thay thế: Hết thời gian suy nghĩ (Timeout)
            if (timeLeft <= 0) {
                clearInterval(timerInterval);
                // [A4.1] Phát âm thanh cảnh báo hết giờ
                if(soundTimeout) soundTimeout.play().catch(e=>{});

                const loser = currentPlayer === 'black' ? 'Người chơi 1' : 'Người chơi 2';
                const winnerColor = currentPlayer === 'black' ? 'white' : 'black';

                // [A4.2 -> A4.4] Tự động xử thua, hiển thị thông báo và kết thúc trò chơi
                handleWin(winnerColor, null, `${loser} đã hết thời gian!`);
            }
        }, 1000);
    }

    function updateTimerUI() {
        uiTimerBlack.classList.add("hidden");
        uiTimerWhite.classList.add("hidden");
        uiTimerBlack.classList.remove("warning");
        uiTimerWhite.classList.remove("warning");

        const activeTimer = currentPlayer === 'black' ? uiTimerBlack : uiTimerWhite;
        activeTimer.textContent = `${timeLeft}s`;
        activeTimer.classList.remove("hidden");

        if (timeLeft <= 5) {
            activeTimer.classList.add("warning");
        }
    }

    // --- THUẬT TOÁN KIỂM TRA THẮNG NÂNG CẤP (Trả về mảng toạ độ) ---
    function checkWin(index) {
        const row = Math.floor(index / BOARD_SIZE);
        const col = index % BOARD_SIZE;
        const player = boardState[index];

        const directions = [
            [0, 1], [1, 0], [1, 1], [1, -1]
        ];

        for (let [dRow, dCol] of directions) {
            let winLine = [index]; // Mảng chứa chuỗi quân

            winLine = winLine.concat(getLineStones(row, col, dRow, dCol, player));
            winLine = winLine.concat(getLineStones(row, col, -dRow, -dCol, player));

            if (winLine.length >= 5) {
                return winLine;
            }
        }
        return null;
    }

    // Lấy danh sách index của các quân cờ cùng màu trên một hướng
    function getLineStones(row, col, dRow, dCol, player) {
        let line = [];
        let r = row + dRow;
        let c = col + dCol;

        while (r >= 0 && r < BOARD_SIZE && c >= 0 && c < BOARD_SIZE) {
            const idx = r * BOARD_SIZE + c;
            if (boardState[idx] === player) {
                line.push(idx);
                r += dRow;
                c += dCol;
            } else {
                break;
            }
        }
        return line;
    }

    // --- XỬ LÝ CHIẾN THẮNG & ĐIỂM SỐ ---
    function handleWin(winnerColor, winCombo = null, customMessage = null) {
        clearInterval(timerInterval);
        isGameOver = true;
        boardElement.classList.add("game-over");

        if(soundWin) soundWin.play().catch(e=>{});

        // Cộng điểm
        scores[winnerColor]++;
        uiScoreBlack.textContent = scores['black'];
        uiScoreWhite.textContent = scores['white'];

        // Highlight quân cờ thắng (nếu không phải do hết giờ)
        if (winCombo) {
            winCombo.forEach(idx => {
                cells[idx].classList.add("win-highlight");
            });
        }

        const winnerName = winnerColor === 'black' ? 'Người chơi 1 (Đen)' : 'Người chơi 2 (Trắng)';
        const msg = customMessage || `Chúc mừng ${winnerName} đã giành chiến thắng!`;

        setTimeout(() => {
            endGame("Chiến Thắng!", msg);
        }, 800); // Đợi 0.8s để user nhìn thấy highlight rồi mới hiện popup
    }

    // --- CÁC CHỨC NĂNG GAME ---
    function resetGame() {
        boardState.fill(null);
        moveHistory = [];
        isGameOver = false;
        currentPlayer = 'black';
        closeModal();

        boardElement.classList.remove("game-over");
        boardElement.classList.add("turn-black");
        boardElement.classList.remove("turn-white");

        cells.forEach(cell => {
            cell.classList.remove("has-black", "has-white", "win-highlight");
        });

        playerBoxes[0].classList.add("is-active");
        playerBoxes[1].classList.remove("is-active");

        startTimer(); // Khởi động lại đồng hồ
    }

    // --- HOÀN TÁC ---
    function undoMove() {
        // [A5: Điều kiện] Kiểm tra game chưa kết thúc và có nước đi để lùi
        if (isGameOver || moveHistory.length === 0) return;

        // [A5.1] Hệ thống lấy nước đi cuối cùng từ moveHistory
        const lastMoveIndex = moveHistory.pop();
        const lastPlayer = boardState[lastMoveIndex];

        // [A5.2] Hệ thống xóa quân cờ tại vị trí đó trên giao diện và trong boardState
        boardState[lastMoveIndex] = null;
        cells[lastMoveIndex].classList.remove(`has-${lastPlayer}`);

        // [A5.3] Hệ thống chuyển lại lượt đi cho người vừa thực hiện và đặt lại đồng hồ
        switchTurn();
    }

    function resignGame() {
        if (isGameOver || moveHistory.length === 0) return;
        const playerName = currentPlayer === 'black' ? 'Người chơi 1' : 'Người chơi 2';
        const winnerColor = currentPlayer === 'black' ? 'white' : 'black';

        showModal(
            "Xác nhận nhận thua",
            `${playerName}, bạn có chắc chắn muốn đầu hàng không?`,
            [
                { text: "Tiếp tục chơi", class: "btn-cancel" },
                {
                    text: "Chấp nhận thua",
                    class: "btn-confirm",
                    onClick: () => handleWin(winnerColor, null, `${playerName} đã nhận thua.`)
                }
            ]
        );
    }

    function proposeDraw() {
        if (isGameOver || moveHistory.length === 0) return;
        const proposer = currentPlayer === 'black' ? 'Người chơi 1' : 'Người chơi 2';
        const receiver = currentPlayer === 'black' ? 'Người chơi 2' : 'Người chơi 1';

        showModal(
            "Đề nghị hòa",
            `${proposer} muốn xin hòa. ${receiver} có đồng ý không?`,
            [
                { text: "Từ chối", class: "btn-cancel" },
                {
                    text: "Đồng ý hòa",
                    class: "btn-confirm",
                    onClick: () => {
                        clearInterval(timerInterval);
                        endGame("Trận đấu Hòa!", "Cả hai người chơi đã đồng ý hòa nhau.");
                    }
                }
            ]
        );
    }

    // --- HIỂN THỊ KẾT THÚC GAME ---
    function endGame(title, message) {
        clearInterval(timerInterval);
        isGameOver = true;
        showModal(title, message, [
            { text: "Đóng", class: "btn-cancel" },
            { text: "Chơi ván mới", class: "btn-confirm", onClick: resetGame }
        ]);
    }

    // --- UI MODAL CONTROLLER ---
    function showModal(title, message, buttons) {
        modalTitle.textContent = title;
        modalMessage.textContent = message;
        modalActions.innerHTML = '';

        buttons.forEach(btnInfo => {
            const btn = document.createElement("button");
            btn.className = `btn-modal ${btnInfo.class}`;
            btn.textContent = btnInfo.text;
            btn.onclick = () => {
                if (btnInfo.onClick) btnInfo.onClick();
                else closeModal();
            };
            modalActions.appendChild(btn);
        });

        modalOverlay.classList.remove("hidden");
    }

    function closeModal() {
        modalOverlay.classList.add("hidden");
    }
});