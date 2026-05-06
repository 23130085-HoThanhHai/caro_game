package vn.edu.hcmuaf.fit.demo3.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/create-room")
public class CreateRoomServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("create-room.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomName = request.getParameter("roomName");
        String boardSize = request.getParameter("boardSize");
        String turnTime = request.getParameter("turnTime");

        request.setAttribute("roomName", roomName);
        request.setAttribute("boardSize", boardSize);
        request.setAttribute("turnTime", turnTime);

        request.getRequestDispatcher("room-detail.jsp").forward(request, response);
    }
}