package vn.edu.hcmuaf.fit.demo3.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Objects;
import java.util.Properties;

public final class AppConfig {
    private static final String PROPERTIES_FILE = "app.properties";

    private static volatile Properties cached;

    private AppConfig() {
    }

    private static Properties props() {
        Properties local = cached;
        if (local != null) return local;

        synchronized (AppConfig.class) {
            if (cached != null) return cached;
            Properties p = new Properties();

            try (InputStream in = AppConfig.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
                if (in != null) {
                    p.load(in);
                }
            } catch (IOException e) {
                throw new IllegalStateException("Failed to load " + PROPERTIES_FILE, e);
            }

            cached = p;
            return p;
        }
    }

    public static String get(String key) {
        String sys = System.getProperty(key);
        if (sys != null && !sys.isBlank()) {
            return sys.trim();
        }

        String envKey = key.toUpperCase().replace('.', '_');
        String env = System.getenv(envKey);
        if (env != null && !env.isBlank()) {
            return env.trim();
        }

        String value = props().getProperty(key);
        if (value != null && !value.isBlank()) {
            return value.trim();
        }

        return null;
    }

    public static String require(String key) {
        return Objects.requireNonNull(get(key), key + " is required (set in app.properties, system property, or env var)");
    }
}
