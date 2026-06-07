package vn.edu.hcmuaf.fit.demo3.service;

import vn.edu.hcmuaf.fit.demo3.dao.ChatDao;
import vn.edu.hcmuaf.fit.demo3.model.AuthUser;
import vn.edu.hcmuaf.fit.demo3.model.ChatMessage;
import vn.edu.hcmuaf.fit.demo3.model.MessageType;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class ChatService {

    private final ChatDao chatDao = new ChatDao();

    public void sendMessage(AuthUser sender, long roomId, String text) throws SQLException {

        if (sender == null) {
            throw new IllegalArgumentException("Chưa đăng nhập");
        }

        if (text == null || text.isBlank()) {
            throw new IllegalArgumentException("Tin nhắn rỗng");
        }

        ChatMessage msg = new ChatMessage();

        msg.setRoomId(roomId);
        msg.setSenderUserId(sender.getId());
        msg.setMessageText(text.trim());

        // CHAT hoặc SYSTEM
        msg.setMessageType(MessageType.CHAT);

        msg.setCreatedAt(LocalDateTime.now());

        chatDao.saveMessage(msg);
    }

    public void sendSystemMessage(long roomId, String text) throws SQLException {

        ChatMessage msg = new ChatMessage();

        msg.setRoomId(roomId);
        msg.setSenderUserId(null);
        msg.setMessageText(text);
        msg.setMessageType(MessageType.SYSTEM);
        msg.setCreatedAt(LocalDateTime.now());

        chatDao.saveMessage(msg);
    }

    public List<ChatMessage> loadMessages(long roomId) throws SQLException {

        return chatDao.loadMessages(roomId);
    }
}
