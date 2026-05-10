package vn.edu.hcmuaf.fit.demo3.dao;

import vn.edu.hcmuaf.fit.demo3.db.DbUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public final class RoomGameDao {

    public Optional<GameInfo> findLatestGameByRoom(long roomId) throws SQLException {
        String sql = """
                SELECT id, board_size, status, result
                FROM games
                WHERE room_id = ? AND mode = 'ONLINE_PVP'
                ORDER BY id DESC
                LIMIT 1
                """;
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(new GameInfo(
                        rs.getLong("id"),
                        rs.getInt("board_size"),
                        rs.getString("status"),
                        rs.getString("result")
                ));
            }
        }
    }

    public long createGame(long roomId, long createdByUserId, int boardSize) throws SQLException {
        String sql = """
                INSERT INTO games (room_id, created_by_user_id, mode, board_size, status, result, started_at)
                VALUES (?, ?, 'ONLINE_PVP', ?, 'IN_PROGRESS', 'NONE', CURRENT_TIMESTAMP(3))
                """;
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, roomId);
            ps.setLong(2, createdByUserId);
            ps.setInt(3, boardSize);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (!keys.next()) throw new SQLException("Không lấy được game id");
                return keys.getLong(1);
            }
        }
    }

    public void upsertGamePlayers(long gameId, long p1UserId, Long p2UserId) throws SQLException {
        try (Connection c = DbUtil.getConnection()) {
            c.setAutoCommit(false);
            try {
                upsertOneGamePlayer(c, gameId, 1, p1UserId, "X");
                if (p2UserId != null) {
                    upsertOneGamePlayer(c, gameId, 2, p2UserId, "O");
                }
                c.commit();
            } catch (SQLException e) {
                c.rollback();
                throw e;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    private void upsertOneGamePlayer(Connection c, long gameId, int playerNo, long userId, String symbol) throws SQLException {
        String updateSql = "UPDATE game_players SET user_id = ?, is_bot = 0, symbol = ? WHERE game_id = ? AND player_no = ?";
        try (PreparedStatement ps = c.prepareStatement(updateSql)) {
            ps.setLong(1, userId);
            ps.setString(2, symbol);
            ps.setLong(3, gameId);
            ps.setInt(4, playerNo);
            int updated = ps.executeUpdate();
            if (updated > 0) return;
        }
        String insertSql = """
                INSERT INTO game_players (game_id, player_no, user_id, is_bot, symbol)
                VALUES (?, ?, ?, 0, ?)
                """;
        try (PreparedStatement ps = c.prepareStatement(insertSql)) {
            ps.setLong(1, gameId);
            ps.setInt(2, playerNo);
            ps.setLong(3, userId);
            ps.setString(4, symbol);
            ps.executeUpdate();
        }
    }

    public List<Move> findMoves(long gameId) throws SQLException {
        String sql = """
                SELECT move_no, player_no, x, y
                FROM game_moves
                WHERE game_id = ?
                ORDER BY move_no ASC
                """;
        List<Move> moves = new ArrayList<>();
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, gameId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    moves.add(new Move(
                            rs.getInt("move_no"),
                            rs.getInt("player_no"),
                            rs.getInt("x"),
                            rs.getInt("y")
                    ));
                }
            }
        }
        return moves;
    }

    public void addMove(long gameId, int moveNo, int playerNo, int x, int y) throws SQLException {
        String sql = """
                INSERT INTO game_moves (game_id, move_no, player_no, x, y)
                VALUES (?, ?, ?, ?, ?)
                """;
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, gameId);
            ps.setInt(2, moveNo);
            ps.setInt(3, playerNo);
            ps.setInt(4, x);
            ps.setInt(5, y);
            ps.executeUpdate();
        }
    }

    public void finishGame(long gameId, String result, Long winnerUserId) throws SQLException {
        String sql = """
                UPDATE games
                SET status = 'FINISHED', result = ?, ended_reason = 'FIVE_IN_ROW', winner_user_id = ?, ended_at = CURRENT_TIMESTAMP(3)
                WHERE id = ?
                """;
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, result);
            if (winnerUserId == null) ps.setNull(2, Types.BIGINT);
            else ps.setLong(2, winnerUserId);
            ps.setLong(3, gameId);
            ps.executeUpdate();
        }
    }

    public record GameInfo(long id, int boardSize, String status, String result) {}
    public record Move(int moveNo, int playerNo, int x, int y) {}
}
