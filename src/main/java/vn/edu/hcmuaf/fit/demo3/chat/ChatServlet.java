package vn.edu.hcmuaf.fit.demo3.chat;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.demo3.model.AuthUser;
import vn.edu.hcmuaf.fit.demo3.service.ChatService;
import  vn.edu.hcmuaf.fit.demo3.web.auth.AuthSession;

import java.io.IOException;

@WebServlet("/chat/send")
public class ChatServlet extends HttpServlet {

    private final ChatService chatService = new ChatService();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {

            AuthUser user =
                    (AuthUser) request.getSession(false)
                            .getAttribute(AuthSession.AUTH_USER);

            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Chưa đăng nhập\"}");
                return;
            }

            long roomId = Long.parseLong(
                    request.getParameter("roomId"));

            String text =
                    request.getParameter("message");

            chatService.sendMessage(
                    user,
                    roomId,
                    text);

            response.getWriter().write(
                    "{\"success\":true}");

        } catch (Exception e) {

            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

            response.getWriter().write(
                    "{\"success\":false,\"message\":\""
                            + e.getMessage()
                            + "\"}");
        }
    }
}