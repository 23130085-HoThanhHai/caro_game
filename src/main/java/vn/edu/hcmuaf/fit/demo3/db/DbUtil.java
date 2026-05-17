package vn.edu.hcmuaf.fit.demo3.db;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class DbUtil {
    private static final String PROPERTIES_FILE = "db.properties";

    private DbUtil() {
    }

    private static volatile String DB_URL;
    private static volatile String DB_USER;
    private static volatile String DB_PASSWORD;
    private static volatile Exception INIT_ERROR;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            INIT_ERROR = new RuntimeException("Không tìm thấy MySQL JDBC Driver", e);
        }

        try (InputStream input = DbUtil.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            Properties prop = new Properties();
            if (input == null) {
                System.out.println("[DbUtil] ⚠️ Không tìm thấy " + PROPERTIES_FILE + " - sử dụng giá trị mặc định");
                DB_URL = "jdbc:mysql://localhost:3306/caro?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
                DB_USER = "root";
                DB_PASSWORD = "";
            } else {
                prop.load(input);
                DB_URL = prop.getProperty("db.url", "jdbc:mysql://localhost:3306/caro?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
                DB_USER = prop.getProperty("db.user", "root");
                DB_PASSWORD = prop.getProperty("db.password", "");
                System.out.println("[DbUtil] ✓ Đã load " + PROPERTIES_FILE);
            }
        } catch (IOException ex) {
            System.err.println("[DbUtil] ✗ Lỗi đọc " + PROPERTIES_FILE + ": " + ex.getMessage());
            INIT_ERROR = ex;
        }
    }

    public static Connection getConnection() throws SQLException {
        if (INIT_ERROR != null) {
            throw new SQLException("Lỗi khởi tạo database driver: " + INIT_ERROR.getMessage(), INIT_ERROR);
        }

        if (DB_URL == null || DB_USER == null) {
            throw new SQLException("Cấu hình database không hợp lệ");
        }

        try {
            System.out.println("[DbUtil] Kết nối: " + DB_URL);
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("[DbUtil] ✓ Kết nối thành công");
            return connection;
        } catch (SQLException e) {
            System.err.println("[DbUtil] ✗ Lỗi kết nối database:");
            System.err.println("  - URL: " + DB_URL);
            System.err.println("  - User: " + DB_USER);
            System.err.println("  - Error: " + e.getMessage());
            System.err.println("  - SQLState: " + e.getSQLState());
            System.err.println("  - ErrorCode: " + e.getErrorCode());
            throw e;
        }
    }
}
