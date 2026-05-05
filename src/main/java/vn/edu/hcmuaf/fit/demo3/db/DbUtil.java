package vn.edu.hcmuaf.fit.demo3.db;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Objects;
import java.util.Properties;

public final class DbUtil {
    private static final String PROPERTIES_FILE = "db.properties";

    private static volatile Properties cached;

    private DbUtil() {
    }

    private static Properties props() {
        Properties local = cached;
        if (local != null) return local;

        synchronized (DbUtil.class) {
            if (cached != null) return cached;
            Properties p = new Properties();

            try (InputStream in = DbUtil.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
                if (in == null) {
                    throw new IllegalStateException("Missing " + PROPERTIES_FILE + " in classpath");
                }
                p.load(in);
            } catch (IOException e) {
                throw new IllegalStateException("Failed to load " + PROPERTIES_FILE, e);
            }

            cached = p;
            return p;
        }
    }

    public static Connection getConnection() throws SQLException {
        Properties p = props();

        String url = Objects.requireNonNull(p.getProperty("db.url"), "db.url is required");
        String user = Objects.requireNonNull(p.getProperty("db.user"), "db.user is required");
        String password = p.getProperty("db.password", "");

        return DriverManager.getConnection(url, user, password);
    }
}
