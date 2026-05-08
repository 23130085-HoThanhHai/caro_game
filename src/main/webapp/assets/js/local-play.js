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
        if (isGameOver) return;

        const cell = e.currentTarget;
        const index = parseInt(cell.getAttribute("data-index"));

        if (boardState[index] !== null) return;

        // Phát âm thanh đánh cờ
        if(soundMove) {
            soundMove.currentTime = 0;
            soundMove.play().catch(e => console.log("Audio play prevented"));
        }

        boardState[index] = currentPlayer;
        moveHistory.push(index);
        cell.classList.add(`has-${currentPlayer}`);

        // Kiểm tra thắng - Nhận về mảng index các quân thắng (nếu có)
        const winCombo = checkWin(index);
        if (winCombo) {
            handleWin(currentPlayer, winCombo);
            return;
        }

        if (moveHistory.length === TOTAL_CELLS) {
            endGame("Hòa Nhau!", "Bàn cờ đã kín, trận đấu kết thúc với kết quả Hòa!");
            return;
        }

        switchTurn();
    }

    // --- ĐỔI LƯỢT ---
    function switchTurn() {
        currentPlayer = currentPlayer === 'black' ? 'white' : 'black';

        // Đổi class hover cho bàn cờ
        boardElement.classList.remove("turn-black", "turn-white");
        boardElement.classList.add(`turn-${currentPlayer}`);

        if (currentPlayer === 'black') {
            playerBoxes[0].classList.add("is-active");
            playerBoxes[1].classList.remove("is-active");
        } else {
            playerBoxes[1].classList.add("is-active");
            playerBoxes[0].classList.remove("is-active");
        }

        // Reset bộ đếm giờ
        startTimer();
    }

    // --- ĐỒNG HỒ ĐẾM NGƯỢC ---
    function startTimer() {
        clearInterval(timerInterval);
        timeLeft = TIME_PER_TURN;
        updateTimerUI();

        timerInterval = setInterval(() => {
            timeLeft--;
            updateTimerUI();

            if (timeLeft <= 0) {
                clearInterval(timerInterval);
                if(soundTimeout) soundTimeout.play().catch(e=>{});

                // Hết giờ xử thua luôn người đang đi
                const loser = currentPlayer === 'black' ? 'Người chơi 1' : 'Người chơi 2';
                const winnerColor = currentPlayer === 'black' ? 'white' : 'black';

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

    function undoMove() {
        if (isGameOver || moveHistory.length === 0) return;

        const lastMoveIndex = moveHistory.pop();
        const lastPlayer = boardState[lastMoveIndex];

        boardState[lastMoveIndex] = null;
        cells[lastMoveIndex].classList.remove(`has-${lastPlayer}`);

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