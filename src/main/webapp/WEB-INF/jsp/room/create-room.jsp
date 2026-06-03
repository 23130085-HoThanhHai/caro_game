<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("activeNav", ""); %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Tạo phòng | Gomoku Zen</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/app.css" />
</head>
<body>
  <div class="page">
    <%@ include file="/WEB-INF/jsp/common/header.jspf" %>
    <main class="main" role="main">
      <section class="section">
        <div class="container" style="max-width: 640px;">
          <h2 class="section-title">Tạo Phòng</h2>
          <p class="section-sub" style="margin-bottom: 18px;">Tạo phòng đấu và chia sẻ mã cho bạn bè.</p>

          <% if (request.getAttribute("error") != null) { %>
            <div class="card" style="padding:12px; margin-bottom:12px; color:#b42318;"><%= request.getAttribute("error") %></div>
          <% } %>
            <%-- Tối ưu UI Form Tạo Phòng và Phân loại Kích thước (create-room.jsp) --%>
            <form class="card" style="padding:24px; display:grid; gap:16px;" method="post" action="<%= request.getContextPath() %>/create-room">

                <div style="display: flex; flex-direction: column; gap: 6px;">
                    <label for="roomName" style="font-weight: 600; color: #344054;">Tên phòng thi đấu</label>
                    <input type="text" id="roomName" name="roomName" required maxlength="100" autofocus
                           value="<%= request.getAttribute("roomName") != null ? request.getAttribute("roomName") : "" %>"
                           style="width:100%; padding:12px; border:1px solid #d0d5dd; border-radius:8px; font-size: 15px; outline: none; transition: border-color 0.2s;"
                           onfocus="this.style.borderColor='#3498db'" onblur="this.style.borderColor='#d0d5dd'"
                           placeholder="Ví dụ: Phòng của Minh (Tối đa 100 ký tự)" />
                </div>

                <div style="display: flex; flex-direction: column; gap: 6px;">
                    <label for="boardSize" style="font-weight: 600; color: #344054;">Kích thước bàn cờ</label>
                    <select id="boardSize" name="boardSize" style="width:100%; padding:12px; border:1px solid #d0d5dd; border-radius:8px; font-size: 15px; background-color: #fff; cursor: pointer;">
                        <option value="13">13 x 13 (Trận đấu nhanh)</option>
                        <option value="15" selected>15 x 15 (Tiêu chuẩn quốc tế)</option>
                        <option value="19">19 x 19 (Trận đấu kéo dài)</option>
                    </select>
                </div>

                <button class="btn btn-primary" type="submit" style="padding:12px 16px; font-size: 16px; margin-top: 8px;">
                    Tạo phòng ngay
                </button>
            </form>
        </div>
      </section>
    </main>
    <%@ include file="/WEB-INF/jsp/common/footer.jspf" %>
  </div>
</body>
</html>
