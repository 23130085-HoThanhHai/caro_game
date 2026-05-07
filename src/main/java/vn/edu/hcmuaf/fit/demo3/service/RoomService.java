package vn.edu.hcmuaf.fit.demo3.service;

import vn.edu.hcmuaf.fit.demo3.db.DbUtil;
import vn.edu.hcmuaf.fit.demo3.model.Room;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
public class RoomService {

    public List<Room> getAvailableRooms() {
        List<Room> rooms = new ArrayList<>();

        String sql = "SELECT * FROM rooms WHERE status = 'OPEN'";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomName(rs.getString("room_name"));
                room.setMaxPlayers(rs.getInt("max_players"));
                room.setCurrentPlayers(rs.getInt("current_players"));
                room.setStatus(rs.getString("status"));

                rooms.add(room);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rooms;
    }
    public String joinRoom(int roomId, int playerId) {

        String checkRoom = "SELECT * FROM rooms WHERE id = ?";
        String insertPlayer = "INSERT INTO room_members(user_id, room_id) VALUES (?, ?)";
        String updateRoom = "UPDATE rooms SET status = 'IN_GAME' WHERE id = ?";

        try (Connection conn = DbUtil.getConnection()) {

            conn.setAutoCommit(false);

            PreparedStatement checkStmt = conn.prepareStatement(checkRoom);
            checkStmt.setInt(1, roomId);

            ResultSet rs = checkStmt.executeQuery();

            if (!rs.next()) {
                return "ROOM_NOT_FOUND";
            }
            int currentPlayers = rs.getInt("current_players");
            int maxPlayers = rs.getInt("max_players");
            String status = rs.getString("status");

            if (currentPlayers >= maxPlayers) {
                return "ROOM_FULL";
            }

            if ("IN_GAME".equals(status)) {
                return "ROOM_PLAYING";
            }
            PreparedStatement insertStmt = conn.prepareStatement(insertPlayer);
            insertStmt.setInt(1, playerId);
            insertStmt.setInt(2, roomId);
            insertStmt.executeUpdate();

            PreparedStatement updateStmt = conn.prepareStatement(updateRoom);
            updateStmt.setInt(1, roomId);
            updateStmt.executeUpdate();

            conn.commit();

            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace();
            return "SERVER_ERROR";
        }
    }
}