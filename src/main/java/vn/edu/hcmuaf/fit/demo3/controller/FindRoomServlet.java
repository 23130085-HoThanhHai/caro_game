package vn.edu.hcmuaf.fit.demo3.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.demo3.model.Room;
import vn.edu.hcmuaf.fit.demo3.service.RoomService;

import java.io.IOException;
import java.util.List;

@WebServlet("/find-room")
public class FindRoomServlet extends HttpServlet {

    private final RoomService roomService = new RoomService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Room> rooms = roomService.getAvailableRooms();

        request.setAttribute("rooms", rooms);

        request.getRequestDispatcher("find-room.jsp").forward(request, response);
    }
}
