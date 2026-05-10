package vn.edu.hcmuaf.fit.demo3.model;

import java.time.LocalDateTime;

public record RoomPlayer(
        long id,
        long roomId,
        long userId,
        String username,
        String displayName,
        String role,
        Integer seatNo,
        String memberStatus,
        LocalDateTime joinedAt
) {
    public String shownName() {
        return (displayName != null && !displayName.isBlank()) ? displayName : username;
    }
}
