package vn.edu.hcmuaf.fit.demo3.web.room;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.demo3.model.AuthUser;
import vn.edu.hcmuaf.fit.demo3.model.RoomGameSnapshot;
import vn.edu.hcmuaf.fit.demo3.service.RoomException;
import vn.edu.hcmuaf.fit.demo3.service.RoomGameService;
import vn.edu.hcmuaf.fit.demo3.web.auth.AuthSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "roomPlayServlet", value = "/room-play")
public class RoomPlayServlet extends HttpServlet {
    private final RoomGameService roomGameService = new RoomGameService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        AuthUser authUser = getAuthUser(request);
        if (authUser == null) {
            response.getWriter().write("{\"success\":false,\"error\":\"Bạn chưa đăng nhập\"}");
            return;
        }
        String roomCode = request.getParameter("code");
        try {
            RoomGameSnapshot snapshot = roomGameService.getState(authUser, roomCode);
            response.getWriter().write(toJson(true, null, snapshot));
        } catch (RoomException | SQLException e) {
            response.getWriter().write("{\"success\":false,\"error\":\"" + escape(e.getMessage()) + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        AuthUser authUser = getAuthUser(request);
        if (authUser == null) {
            response.getWriter().write("{\"success\":false,\"error\":\"Bạn chưa đăng nhập\"}");
            return;
        }
        String action = request.getParameter("action");
        if (!"move".equals(action) && !"restart".equals(action)) {
            response.getWriter().write("{\"success\":false,\"error\":\"Action không hợp lệ\"}");
            return;
        }
        String roomCode = request.getParameter("code");

        try {
            RoomGameSnapshot snapshot;
            if ("restart".equals(action)) {
                snapshot = roomGameService.restartGame(authUser, roomCode);
            } else {
                int x;
                int y;
                try {
                    x = Integer.parseInt(request.getParameter("x"));
                    y = Integer.parseInt(request.getParameter("y"));
                } catch (Exception e) {
                    response.getWriter().write("{\"success\":false,\"error\":\"Tọa độ không hợp lệ\"}");
                    return;
                }
                snapshot = roomGameService.placeMove(authUser, roomCode, x, y);
            }
            response.getWriter().write(toJson(true, null, snapshot));
        } catch (RoomException | SQLException e) {
            response.getWriter().write(toJson(false, e.getMessage(), null));
        }
    }

    private AuthUser getAuthUser(HttpServletRequest request) {
        return request.getSession(false) == null ? null : (AuthUser) request.getSession(false).getAttribute(AuthSession.AUTH_USER);
    }

    private String toJson(boolean success, String error, RoomGameSnapshot snapshot) {
        StringBuilder sb = new StringBuilder();
        sb.append("{\"success\":").append(success);
        if (error != null) sb.append(",\"error\":\"").append(escape(error)).append("\"");
        if (snapshot != null) {
            sb.append(",\"state\":{");
            sb.append("\"roomCode\":\"").append(escape(snapshot.getRoomCode())).append("\",");
            sb.append("\"boardSize\":").append(snapshot.getBoardSize()).append(",");
            sb.append("\"gameStatus\":\"").append(snapshot.getGameStatus()).append("\",");
            sb.append("\"result\":\"").append(snapshot.getResult()).append("\",");
            sb.append("\"currentPlayerNo\":").append(snapshot.getCurrentPlayerNo()).append(",");
            sb.append("\"yourPlayerNo\":").append(snapshot.getYourPlayerNo()).append(",");
            sb.append("\"playersJoined\":").append(snapshot.getPlayersJoined()).append(",");
            sb.append("\"message\":\"").append(escape(snapshot.getMessage() == null ? "" : snapshot.getMessage())).append("\",");
            sb.append("\"board\":").append(boardJson(snapshot.getBoard())).append(",");
            sb.append("\"winningCells\":").append(cellsJson(snapshot.getWinningCells())).append("}");
        }
        sb.append("}");
        return sb.toString();
    }

    private String boardJson(int[][] board) {
        StringBuilder sb = new StringBuilder("[");
        for (int y = 0; y < board.length; y++) {
            if (y > 0) sb.append(",");
            sb.append("[");
            for (int x = 0; x < board[y].length; x++) {
                if (x > 0) sb.append(",");
                sb.append(board[y][x]);
            }
            sb.append("]");
        }
        sb.append("]");
        return sb.toString();
    }

    private String cellsJson(java.util.List<int[]> cells) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < cells.size(); i++) {
            if (i > 0) sb.append(",");
            int[] c = cells.get(i);
            sb.append("[").append(c[0]).append(",").append(c[1]).append("]");
        }
        sb.append("]");
        return sb.toString();
    }

    private String escape(String s) {
        return s == null ? "" : s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
