package vn.edu.hcmuaf.fit.demo3.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/room-detail")
public class RoomDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomId = request.getParameter("id");

        if (request.getAttribute("roomName") == null) {
            request.setAttribute("roomName", "Phòng " + (roomId != null ? roomId : "Ẩn danh"));
            request.setAttribute("boardSize", "15");
            request.setAttribute("turnTime", "30");
        }

        request.getRequestDispatcher("room-detail.jsp").forward(request, response);
    }
}