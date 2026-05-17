package vn.edu.hcmuaf.fit.demo3.dao;

import vn.edu.hcmuaf.fit.demo3.db.DbUtil;
import vn.edu.hcmuaf.fit.demo3.model.UserRole;
import vn.edu.hcmuaf.fit.demo3.model.UserStatus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Optional;

public final class UserDao {
    public record UserWithProfile(
            long id,
            String username,
            String email,
            String passwordHash,
            UserRole role,
            UserStatus status,
            String displayName,
            String avatarUrl
    ) {
    }

    public Optional<UserWithProfile> findById(long id) throws SQLException {
        String sql = """
                SELECT u.id, u.username, u.email, u.password_hash, u.role, u.status,
                       p.display_name, p.avatar_url
                FROM users u
                LEFT JOIN user_profiles p ON p.user_id = u.id
                WHERE u.id = ?
                LIMIT 1
                """;

        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(map(rs));
            }
        }
    }

    public Optional<UserWithProfile> findByUsernameOrEmail(String identifier) throws SQLException {
        String sql = """
                SELECT u.id, u.username, u.email, u.password_hash, u.role, u.status,
                       p.display_name, p.avatar_url
                FROM users u
                LEFT JOIN user_profiles p ON p.user_id = u.id
                WHERE u.username = ? OR u.email = ?
                LIMIT 1
                """;

        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, identifier);
            ps.setString(2, identifier);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(map(rs));
            }
        }
    }

    public Optional<UserWithProfile> findByEmail(String email) throws SQLException {
        String sql = """
                SELECT u.id, u.username, u.email, u.password_hash, u.role, u.status,
                       p.display_name, p.avatar_url
                FROM users u
                LEFT JOIN user_profiles p ON p.user_id = u.id
                WHERE u.email = ?
                LIMIT 1
                """;

        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(map(rs));
            }
        }
    }

    public boolean existsByUsername(String username) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE username = ? LIMIT 1";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean existsByEmail(String email) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE email = ? LIMIT 1";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public long createUserWithProfile(
            String username,
            String email,
            String passwordHash,
            String displayName,
            String fullName,
            String avatarUrl
    ) throws SQLException {
        String insertUserSql = """
                INSERT INTO users (username, email, password_hash)
                VALUES (?, ?, ?)
                """;
        String insertProfileSql = """
                INSERT INTO user_profiles (user_id, display_name, full_name, avatar_url)
                VALUES (?, ?, ?, ?)
                """;

        try (Connection c = DbUtil.getConnection()) {
            c.setAutoCommit(false);

            try {
                long userId;
                try (PreparedStatement ps = c.prepareStatement(insertUserSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, username);
                    ps.setString(2, email);
                    ps.setString(3, passwordHash);
                    ps.executeUpdate();

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) {
                            throw new SQLException("Failed to get generated user id");
                        }
                        userId = keys.getLong(1);
                    }
                }

                try (PreparedStatement ps = c.prepareStatement(insertProfileSql)) {
                    ps.setLong(1, userId);
                    ps.setString(2, displayName);
                    ps.setString(3, fullName);
                    ps.setString(4, avatarUrl);
                    ps.executeUpdate();
                }

                c.commit();
                return userId;
            } catch (SQLException e) {
                try {
                    c.rollback();
                } catch (SQLException ignored) {
                    // ignored
                }
                throw e;
            }
        }
    }

    public void updateLastLoginAt(long userId) throws SQLException {
        String sql = "UPDATE users SET last_login_at = CURRENT_TIMESTAMP(3) WHERE id = ?";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.executeUpdate();
        }
    }

    private static UserWithProfile map(ResultSet rs) throws SQLException {
        return new UserWithProfile(
                rs.getLong("id"),
                rs.getString("username"),
                rs.getString("email"),
                rs.getString("password_hash"),
                UserRole.valueOf(rs.getString("role")),
                UserStatus.valueOf(rs.getString("status")),
                rs.getString("display_name"),
                rs.getString("avatar_url")
        );
    }
}
