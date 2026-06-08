package vn.edu.hcmuaf.fit.demo3.dao;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;
import vn.edu.hcmuaf.fit.demo3.db.DbUtil;

import java.sql.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class RoomDaoTest {

    private RoomDao roomDao;
    private Connection mockConnection;
    private PreparedStatement mockPreparedStatement;
    private ResultSet mockResultSet;
    private MockedStatic<DbUtil> mockedDbUtil;

    @BeforeEach
    public void setUp() throws SQLException {
        roomDao = new RoomDao();
        mockConnection = mock(Connection.class);
        mockPreparedStatement = mock(PreparedStatement.class);
        mockResultSet = mock(ResultSet.class);

        mockedDbUtil = mockStatic(DbUtil.class);
        mockedDbUtil.when(DbUtil::getConnection).thenReturn(mockConnection);
    }

    @AfterEach
    public void tearDown() {
        mockedDbUtil.close();
    }

    @Test
    public void testCreateRoom_Success() throws SQLException {
        String roomCode = "AKKMJU5";
        String roomName = "Phòng của Đăng";
        int boardSize = 15;
        long hostId = 1L;
        long expectedGeneratedId = 99L;

        when(mockConnection.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS)))
                .thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);
        when(mockPreparedStatement.getGeneratedKeys()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getLong(1)).thenReturn(expectedGeneratedId);

        long generatedId = roomDao.createRoom(roomCode, roomName, boardSize, hostId, null);

        assertEquals(expectedGeneratedId, generatedId);
        verify(mockPreparedStatement).setString(1, roomCode);
        verify(mockPreparedStatement).setString(2, roomName);
        verify(mockPreparedStatement).setLong(3, hostId);
        verify(mockPreparedStatement).setBoolean(4, false);
        verify(mockPreparedStatement).setInt(6, boardSize);
    }

    @Test
    public void testAddHostToRoom_Success() throws SQLException {
        long roomId = 99L;
        long hostId = 1L;

        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        assertDoesNotThrow(() -> roomDao.addHostToRoom(roomId, hostId));

        verify(mockPreparedStatement).setLong(1, roomId);
        verify(mockPreparedStatement).setLong(2, hostId);
        verify(mockPreparedStatement).executeUpdate();
    }
}