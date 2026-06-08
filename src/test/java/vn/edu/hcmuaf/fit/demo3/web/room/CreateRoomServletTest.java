package vn.edu.hcmuaf.fit.demo3.web.room;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import vn.edu.hcmuaf.fit.demo3.model.AuthUser;
import vn.edu.hcmuaf.fit.demo3.model.Room;
import vn.edu.hcmuaf.fit.demo3.model.UserRole;
import vn.edu.hcmuaf.fit.demo3.service.RoomException;
import vn.edu.hcmuaf.fit.demo3.service.RoomService;
import vn.edu.hcmuaf.fit.demo3.web.auth.AuthSession;

import java.io.IOException;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class CreateRoomServletTest {

    @Mock
    private RoomService roomService;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private RequestDispatcher requestDispatcher;

    @InjectMocks
    private CreateRoomServlet createRoomServlet;

    private AuthUser mockUser;

    @BeforeEach
    public void setUp() {
        // Khởi tạo AuthUser hợp lệ với constructor đầy đủ tham số
        mockUser = new AuthUser(1L, "dangqpham1", "Phạm Quốc Đăng", UserRole.PLAYER, "avatar.png");
    }

    @Test
    public void testDoGet_WhenNotLoggedIn_RedirectToLogin() throws ServletException, IOException {
        when(request.getSession(false)).thenReturn(null);
        when(request.getContextPath()).thenReturn("/demo3");

        createRoomServlet.doGet(request, response);

        verify(response).sendRedirect("/demo3/login");
    }

    @Test
    public void testDoGet_WhenLoggedIn_ForwardToCreateRoomJsp() throws ServletException, IOException {
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute(AuthSession.AUTH_USER)).thenReturn(mockUser);
        when(request.getRequestDispatcher("/WEB-INF/jsp/room/create-room.jsp")).thenReturn(requestDispatcher);

        createRoomServlet.doGet(request, response);

        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_Success_RedirectToRoom() throws Exception {
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute(AuthSession.AUTH_USER)).thenReturn(mockUser);
        when(request.getParameter("roomName")).thenReturn("Caro VIP");
        when(request.getParameter("boardSize")).thenReturn("15");
        when(request.getContextPath()).thenReturn("/demo3");

        Room mockCreatedRoom = new Room();
        mockCreatedRoom.setRoomCode("ABCXYZ");
        when(roomService.createRoom(mockUser, "Caro VIP", 15)).thenReturn(mockCreatedRoom);

        createRoomServlet.doPost(request, response);

        verify(response).sendRedirect("/demo3/room?code=ABCXYZ");
    }

    @Test
    public void testDoPost_Fail_Validation_ForwardWithErrorMessage() throws Exception {
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute(AuthSession.AUTH_USER)).thenReturn(mockUser);
        when(request.getParameter("roomName")).thenReturn("");
        when(request.getParameter("boardSize")).thenReturn("15");
        when(request.getRequestDispatcher("/WEB-INF/jsp/room/create-room.jsp")).thenReturn(requestDispatcher);

        when(roomService.createRoom(mockUser, "", 15)).thenThrow(new RoomException("Tên phòng không được để trống"));

        createRoomServlet.doPost(request, response);

        verify(request).setAttribute("error", "Tên phòng không được để trống");
        verify(request).setAttribute("roomName", "");
        verify(request).setAttribute("boardSize", 15);
        verify(requestDispatcher).forward(request, response);
    }
}