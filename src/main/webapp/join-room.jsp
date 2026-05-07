<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!doctype html>
<html lang="vi">

<head>

    <meta charset="UTF-8">

    <title>Phòng Chơi Gomoku</title>

    <link rel="stylesheet" href="assets/css/join-room.css">

</head>

<body>

<div class="room-container">

    <h1 class="room-title">
        Phòng Chơi Gomoku
    </h1>

    <div class="room-info">

        <p>
            <strong>Mã phòng:</strong>
            <%= request.getParameter("id") %>
        </p>

        <p>
            <strong>Trạng thái:</strong>
            Đang chờ người chơi...
        </p>

    </div>

    <div class="player-list">

        <h3>Danh sách người chơi</h3>

        <div class="player-item">
            Người chơi 1
        </div>

        <div class="player-item">
            Người chơi 2
        </div>

    </div>

    <div class="room-actions">

        <a href="#" class="btn btn-start">
            Bắt đầu chơi
        </a>

        <a href="find-room" class="btn btn-leave">
            Rời phòng
        </a>

    </div>

</div>

</body>

</html>