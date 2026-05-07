<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="vn.edu.hcmuaf.fit.demo3.model.Room" %>

<!doctype html>
<html lang="vi">

<head>

    <meta charset="UTF-8">

    <title>Tìm Phòng</title>

    <link rel="stylesheet" href="assets/css/find-room.css">

</head>

<body>

<div class="container">

    <div class="header">

        <h1>Danh Sách Phòng</h1>

        <a href="index.jsp" class="back-btn">
            ← Trang chủ
        </a>

    </div>

    <%
        String error = (String) request.getAttribute("error");

        if (error != null) {
    %>

    <p class="error"><%= error %></p>

    <%
        }
    %>

    <table class="table">

        <tr>
            <th>ID</th>
            <th>Tên phòng</th>
            <th>Số người</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>

        <%
            List<Room> rooms = (List<Room>) request.getAttribute("rooms");

            if (rooms != null && !rooms.isEmpty()) {

                for (Room room : rooms) {
        %>

        <tr>

            <td>
                <%= room.getRoomId() %>
            </td>

            <td>
                <%= room.getRoomName() %>
            </td>

            <td>
                <%= room.getCurrentPlayers() %> /
                <%= room.getMaxPlayers() %>
            </td>

            <td>
                <span class="status">
                    <%= room.getStatus() %>
                </span>
            </td>

            <td>

                <form action="join-room" method="post">

                    <input
                            type="hidden"
                            name="roomId"
                            value="<%= room.getRoomId() %>"
                    >

                    <button type="submit" class="join-btn">
                        Tham gia
                    </button>

                </form>

            </td>

        </tr>

        <%
            }

        } else {
        %>

        <tr>

            <td colspan="5" class="empty-room">
                Không có phòng nào
            </td>

        </tr>

        <%
            }
        %>

    </table>

    <div class="room-footer">

        <a href="create-room.jsp" class="create-room-btn">
            + Tạo phòng mới
        </a>

    </div>

</div>

</body>

</html>