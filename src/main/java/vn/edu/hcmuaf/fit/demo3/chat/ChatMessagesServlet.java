package vn.edu.hcmuaf.fit.demo3.chat;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vn.edu.hcmuaf.fit.demo3.model.ChatMessage;
import vn.edu.hcmuaf.fit.demo3.service.ChatService;

import java.io.IOException;
import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;

@WebServlet("/chat/messages")
public class ChatMessagesServlet extends HttpServlet {

    private final ChatService chatService =
            new ChatService();

    private final ObjectMapper mapper =
            new ObjectMapper();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            long roomId =
                    Long.parseLong(
                            request.getParameter("roomId"));

            List<ChatMessage> messages =
                    chatService.loadMessages(roomId);

            response.setContentType(
                    "application/json");

            response.setCharacterEncoding(
                    "UTF-8");

            mapper.writeValue(
                    response.getWriter(),
                    messages);

        } catch (Exception e) {

            response.sendError(500);
        }
    }
}