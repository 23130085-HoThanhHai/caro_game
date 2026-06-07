package vn.edu.hcmuaf.fit.demo3.model;

public enum MessageType {

    CHAT,
    SYSTEM;

    public static MessageType fromDbValue(String value) {
        if (value == null) {
            return CHAT;
        }

        return switch (value.toUpperCase()) {
            case "SYSTEM" -> SYSTEM;
            default -> CHAT;
        };
    }

    public String toDbValue() {
        return name();
    }
}
