package vn.edu.hcmuaf.fit.demo3.model;

import java.util.ArrayList;
import java.util.List;

public class RoomGameSnapshot {
    private long roomId;
    private String roomCode;
    private int boardSize;
    private String gameStatus;
    private String result;
    private int currentPlayerNo;
    private int yourPlayerNo;
    private int playersJoined;
    private int[][] board;
    private List<int[]> moves = new ArrayList<>();
    private List<int[]> winningCells = new ArrayList<>();
    private String message;

    public long getRoomId() { return roomId; }
    public void setRoomId(long roomId) { this.roomId = roomId; }
    public String getRoomCode() { return roomCode; }
    public void setRoomCode(String roomCode) { this.roomCode = roomCode; }
    public int getBoardSize() { return boardSize; }
    public void setBoardSize(int boardSize) { this.boardSize = boardSize; }
    public String getGameStatus() { return gameStatus; }
    public void setGameStatus(String gameStatus) { this.gameStatus = gameStatus; }
    public String getResult() { return result; }
    public void setResult(String result) { this.result = result; }
    public int getCurrentPlayerNo() { return currentPlayerNo; }
    public void setCurrentPlayerNo(int currentPlayerNo) { this.currentPlayerNo = currentPlayerNo; }
    public int getYourPlayerNo() { return yourPlayerNo; }
    public void setYourPlayerNo(int yourPlayerNo) { this.yourPlayerNo = yourPlayerNo; }
    public int getPlayersJoined() { return playersJoined; }
    public void setPlayersJoined(int playersJoined) { this.playersJoined = playersJoined; }
    public int[][] getBoard() { return board; }
    public void setBoard(int[][] board) { this.board = board; }
    public List<int[]> getMoves() { return moves; }
    public void setMoves(List<int[]> moves) { this.moves = moves; }
    public List<int[]> getWinningCells() { return winningCells; }
    public void setWinningCells(List<int[]> winningCells) { this.winningCells = winningCells; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
}
