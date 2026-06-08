package vn.edu.hcmuaf.fit.demo3.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import vn.edu.hcmuaf.fit.demo3.dao.RoomDao;
import vn.edu.hcmuaf.fit.demo3.model.AuthUser;
import vn.edu.hcmuaf.fit.demo3.model.Room;
import vn.edu.hcmuaf.fit.demo3.model.UserRole;

import java.sql.SQLException;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class RoomServiceTest {

    @Mock
    private RoomDao roomDao;

    @InjectMocks
    private RoomService roomService;

    private AuthUser mockUser;

    @BeforeEach
    public void setUp() {
        // Sử dụng constructor có tham số của AuthUser theo đúng định nghĩa mới
        mockUser = new AuthUser(1L, "dangqpham1", "Phạm Quốc Đăng", UserRole.PLAYER, "avatar.png");
    }

    @Test
    public void testCreateRoom_Success() throws SQLException, RoomException {
        String roomName = "Phòng của Đăng";
        int boardSize = 15;
        long mockRoomId = 100L;

        Room mockRoom = new Room();
        mockRoom.setId(mockRoomId);
        mockRoom.setRoomCode("AKKMJU5");
        mockRoom.setName(roomName);

        when(roomDao.existsByCode(anyString())).thenReturn(false);
        when(roomDao.createRoom(anyString(), eq(roomName), eq(boardSize), eq(mockUser.getId()), any())).thenReturn(mockRoomId);
        doNothing().when(roomDao).addHostToRoom(mockRoomId, mockUser.getId());
        when(roomDao.findById(mockRoomId)).thenReturn(Optional.of(mockRoom));

        Room result = roomService.createRoom(mockUser, roomName, boardSize);

        assertNotNull(result);
        assertEquals("AKKMJU5", result.getRoomCode());
        assertEquals(roomName, result.getName());
        verify(roomDao, times(1)).createRoom(anyString(), eq(roomName), eq(boardSize), eq(mockUser.getId()), any());
        verify(roomDao, times(1)).addHostToRoom(mockRoomId, mockUser.getId());
    }

    @Test
    public void testCreateRoom_Fail_NotLoggedIn() {
        RoomException exception = assertThrows(RoomException.class, () -> {
            roomService.createRoom(null, "Room Name", 15);
        });
        assertEquals("Bạn cần đăng nhập để dùng chức năng phòng", exception.getMessage());
    }

    @Test
    public void testCreateRoom_Fail_EmptyRoomName() {
        RoomException exception = assertThrows(RoomException.class, () -> {
            roomService.createRoom(mockUser, "   ", 15);
        });
        assertEquals("Tên phòng không được để trống", exception.getMessage());
    }

    @Test
    public void testCreateRoom_Fail_RoomNameTooLong() {
        String longRoomName = "a".repeat(101);

        RoomException exception = assertThrows(RoomException.class, () -> {
            roomService.createRoom(mockUser, longRoomName, 15);
        });
        assertEquals("Tên phòng tối đa 100 ký tự", exception.getMessage());
    }

    @Test
    public void testCreateRoom_Fail_InvalidBoardSize_TooSmall() {
        RoomException exception = assertThrows(RoomException.class, () -> {
            roomService.createRoom(mockUser, "Phòng Test", 4);
        });
        assertEquals("Kích thước bàn cờ phải từ 5 đến 50", exception.getMessage());
    }

    @Test
    public void testCreateRoom_Fail_InvalidBoardSize_TooLarge() {
        RoomException exception = assertThrows(RoomException.class, () -> {
            roomService.createRoom(mockUser, "Phòng Test", 51);
        });
        assertEquals("Kích thước bàn cờ phải từ 5 đến 50", exception.getMessage());
    }
}