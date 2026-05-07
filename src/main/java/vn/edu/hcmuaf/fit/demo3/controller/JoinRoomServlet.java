package vn.edu.hcmuaf.fit.demo3.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.demo3.service.RoomService;

import java.io.IOException;

@WebServlet("/join-room")
public class JoinRoomServlet extends HttpServlet {

    private final RoomService roomService = new RoomService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int roomId = Integer.parseInt(request.getParameter("roomId"));

        int playerId = 1;

        String result = roomService.joinRoom(roomId, playerId);

        switch (result) {
            case "SUCCESS":
                response.sendRedirect("room-detail?id=" + roomId);
                break;

            case "ROOM_FULL":
                request.setAttribute("error", "Phòng đã đầy");
                request.getRequestDispatcher("find-room.jsp").forward(request, response);
                break;
            case "ROOM_PLAYING":
                request.setAttribute("error", "Phòng đang chơi");
                request.getRequestDispatcher("find-room.jsp").forward(request, response);
                break;

            case "ROOM_NOT_FOUND":
                request.setAttribute("error", "Phòng không tồn tại");
                request.getRequestDispatcher("find-room.jsp").forward(request, response);
                break;

            default:
                request.setAttribute("error", "Lỗi hệ thống");
                request.getRequestDispatcher("find-room.jsp").forward(request, response);
                break;
        }
    }
}
