package vn.edu.hcmuaf.fit.demo3.service;

import vn.edu.hcmuaf.fit.demo3.dao.UserDao;
import vn.edu.hcmuaf.fit.demo3.model.AuthUser;
import vn.edu.hcmuaf.fit.demo3.model.UserStatus;

import java.sql.SQLException;
import java.util.Locale;
import java.util.Optional;
import java.util.Random;
import java.util.UUID;

public final class AuthService {
    private final UserDao userDao;

    public AuthService() {
        this(new UserDao());
    }

    public AuthService(UserDao userDao) {
        this.userDao = userDao;
    }

    public AuthUser register(String username, String email, String password) throws AuthException, SQLException {
        String u = safeTrim(username);
        String e = safeTrim(email);
        String p = safeTrim(password);

        if (u == null || u.length() < 3 || u.length() > 50) {
            throw new AuthException("Username phải từ 3 đến 50 ký tự");
        }
        if (e == null || !looksLikeEmail(e)) {
            throw new AuthException("Email không hợp lệ");
        }
        if (p == null || p.length() < 6) {
            throw new AuthException("Mật khẩu phải tối thiểu 6 ký tự");
        }
        if (userDao.existsByUsername(u)) {
            throw new AuthException("Username đã tồn tại");
        }
        if (userDao.existsByEmail(e)) {
            throw new AuthException("Email đã được sử dụng");
        }

        String hash = PasswordHasher.hash(p);
        long userId = userDao.createUserWithProfile(u, e, hash, u, null, null);
        userDao.updateLastLoginAt(userId);
        return new AuthUser(userId, u, u, null, null);
    }

    public AuthUser login(String identifier, String password) throws AuthException, SQLException {
        String id = safeTrim(identifier);
        String p = safeTrim(password);
        if (id == null || id.isBlank()) {
            throw new AuthException("Vui lòng nhập username hoặc email");
        }
        if (p == null || p.isBlank()) {
            throw new AuthException("Vui lòng nhập mật khẩu");
        }

        Optional<UserDao.UserWithProfile> found = userDao.findByUsernameOrEmail(id);
        if (found.isEmpty()) {
            throw new AuthException("Sai thông tin đăng nhập");
        }

        UserDao.UserWithProfile row = found.get();
        if (row.status() != UserStatus.ACTIVE) {
            throw new AuthException("Tài khoản đang bị khóa hoặc vô hiệu hóa");
        }

        if (!PasswordHasher.verify(p, row.passwordHash())) {
            throw new AuthException("Sai thông tin đăng nhập");
        }

        userDao.updateLastLoginAt(row.id());
        return toAuthUser(row);
    }

    public AuthUser loginWithGoogle(GoogleUserInfo googleUser) throws AuthException, SQLException {
        if (googleUser == null || googleUser.email() == null || googleUser.email().isBlank()) {
            throw new AuthException("Google không cung cấp email hợp lệ");
        }

        String email = googleUser.email().trim();
        Optional<UserDao.UserWithProfile> found = userDao.findByEmail(email);

        if (found.isPresent()) {
            UserDao.UserWithProfile row = found.get();
            if (row.status() != UserStatus.ACTIVE) {
                throw new AuthException("Tài khoản đang bị khóa hoặc vô hiệu hóa");
            }
            userDao.updateLastLoginAt(row.id());
            return toAuthUser(row);
        }

        String username = generateUsernameFromEmail(email);
        String displayName = safeTrim(googleUser.name());
        if (displayName == null) displayName = username;

        String passwordHash = PasswordHasher.hashRandomSecret();
        long userId = userDao.createUserWithProfile(username, email, passwordHash, displayName, googleUser.name(), googleUser.picture());
        userDao.updateLastLoginAt(userId);

        return new AuthUser(userId, username, displayName, null, googleUser.picture());
    }

    private AuthUser toAuthUser(UserDao.UserWithProfile row) {
        String displayName = row.displayName();
        if (displayName == null || displayName.isBlank()) {
            displayName = row.username();
        }
        return new AuthUser(row.id(), row.username(), displayName, row.role(), row.avatarUrl());
    }

    private String generateUsernameFromEmail(String email) throws SQLException {
        String local = email.split("@", 2)[0];
        String base = local
                .toLowerCase(Locale.ROOT)
                .replaceAll("[^a-z0-9._]", "");
        if (base.isBlank()) {
            base = "user";
        }
        base = truncate(base, 30);

        if (!userDao.existsByUsername(base)) {
            return base;
        }

        Random rnd = new Random();
        for (int i = 0; i < 30; i++) {
            String candidate = truncate(base + (1000 + rnd.nextInt(9000)), 50);
            if (!userDao.existsByUsername(candidate)) {
                return candidate;
            }
        }

        return truncate("user_" + UUID.randomUUID().toString().replace("-", ""), 50);
    }

    private static String truncate(String s, int max) {
        if (s == null) return null;
        if (s.length() <= max) return s;
        return s.substring(0, max);
    }

    private static String safeTrim(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    private static boolean looksLikeEmail(String email) {
        int at = email.indexOf('@');
        if (at <= 0) return false;
        if (at != email.lastIndexOf('@')) return false;
        int dot = email.lastIndexOf('.');
        return dot > at + 1 && dot < email.length() - 1;
    }
}
