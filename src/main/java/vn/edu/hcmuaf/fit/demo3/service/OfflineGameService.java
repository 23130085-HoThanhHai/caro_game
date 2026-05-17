package vn.edu.hcmuaf.fit.demo3.service;

import vn.edu.hcmuaf.fit.demo3.model.GameResult;
import vn.edu.hcmuaf.fit.demo3.model.GameState;
import vn.edu.hcmuaf.fit.demo3.model.OfflineGame;
import vn.edu.hcmuaf.fit.demo3.model.OfflineGame.Difficulty;
import vn.edu.hcmuaf.fit.demo3.model.OfflineGame.GameMode;

import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

public final class OfflineGameService {
    private static final ConcurrentHashMap<String, OfflineGame> games = new ConcurrentHashMap<>();
    private static final long GAME_TIMEOUT = 30 * 60 * 1000; // 30 min

    private OfflineGameService() {}

    public static OfflineGame createGame(int boardSize, Difficulty difficulty) {
        return createGame(boardSize, difficulty, GameMode.VS_BOT);
    }

    public static OfflineGame createGame(int boardSize, Difficulty difficulty, GameMode gameMode) {
        String gameId = UUID.randomUUID().toString();
        OfflineGame game = new OfflineGame(gameId, boardSize, difficulty, gameMode);
        games.put(gameId, game);
        return game;
    }

    public static OfflineGame createGame(int boardSize) {
        return createGame(boardSize, Difficulty.MEDIUM);
    }

    public static OfflineGame getGame(String gameId) {
        OfflineGame game = games.get(gameId);
        if (game != null) {
            long age = System.currentTimeMillis() - game.getCreatedAt();
            if (age > GAME_TIMEOUT) {
                games.remove(gameId);
                return null;
            }
        }
        return game;
    }

    public static void deleteGame(String gameId) {
        games.remove(gameId);
    }

    public static boolean playerMove(OfflineGame game, int x, int y) {
        if (game == null || game.getState() != GameState.IN_PROGRESS) {
            return false;
        }
        if (!game.isCellEmpty(x, y)) {
            return false;
        }
        if (game.getCurrentPlayer() != 1) {
            return false;
        }

        game.addMove(x, y, 1);

        if (GomokuRules.isWinning(game, x, y, 1)) {
            game.setState(GameState.FINISHED);
            game.setResult(GameResult.P1_WIN);
            return true;
        }

        // Check if board full
        if (isBoardFull(game)) {
            game.setState(GameState.FINISHED);
            game.setResult(GameResult.DRAW);
            return true;
        }

        // Bot's turn
        game.setCurrentPlayer(2);
        return true;
    }

    public static boolean localMove(OfflineGame game, int x, int y) {
        if (game == null || game.getState() != GameState.IN_PROGRESS) return false;
        if (!game.isCellEmpty(x, y)) return false;

        int currentPlayer = game.getCurrentPlayer();
        if (currentPlayer != 1 && currentPlayer != 2) return false;

        game.addMove(x, y, currentPlayer);
        if (GomokuRules.isWinning(game, x, y, currentPlayer)) {
            game.setState(GameState.FINISHED);
            game.setResult(currentPlayer == 1 ? GameResult.P1_WIN : GameResult.P2_WIN);
            return true;
        }

        if (isBoardFull(game)) {
            game.setState(GameState.FINISHED);
            game.setResult(GameResult.DRAW);
            return true;
        }

        game.setCurrentPlayer(currentPlayer == 1 ? 2 : 1);
        return true;
    }

    public static int[] botMove(OfflineGame game) {
        if (game == null || game.getState() != GameState.IN_PROGRESS) {
            return null;
        }
        if (game.getCurrentPlayer() != 2) {
            return null;
        }

        int[] move = GomokuAI.makeMove(game);
        if (move == null) {
            game.setState(GameState.FINISHED);
            game.setResult(GameResult.DRAW);
            return null;
        }

        game.addMove(move[0], move[1], 2);

        if (GomokuRules.isWinning(game, move[0], move[1], 2)) {
            game.setState(GameState.FINISHED);
            game.setResult(GameResult.P2_WIN);
            return move;
        }

        if (isBoardFull(game)) {
            game.setState(GameState.FINISHED);
            game.setResult(GameResult.DRAW);
            return move;
        }

        game.setCurrentPlayer(1);
        return move;
    }

    public static boolean resign(OfflineGame game) {
        if (game == null || game.getState() != GameState.IN_PROGRESS) {
            return false;
        }
        game.setState(GameState.FINISHED);
        if (game.getGameMode() == GameMode.TWO_PLAYERS) {
            game.setResult(game.getCurrentPlayer() == 1 ? GameResult.P2_WIN : GameResult.P1_WIN);
        } else {
            game.setResult(GameResult.P2_WIN);
        }
        return true;
    }

    public static boolean undoLastRound(OfflineGame game) {
        if (game == null || game.getMoves().isEmpty()) {
            return false;
        }

        int undoCount;
        if (game.getGameMode() == GameMode.TWO_PLAYERS) {
            undoCount = 1;
        } else {
            undoCount = game.getCurrentPlayer() == 1 && game.getMoves().size() >= 2 ? 2 : 1;
        }
        for (int i = 0; i < undoCount; i++) {
            int lastIdx = game.getMoves().size() - 1;
            if (lastIdx < 0) break;
            int[] move = game.getMoves().remove(lastIdx);
            game.setCell(move[0], move[1], (byte) 0);
        }

        game.setState(GameState.IN_PROGRESS);
        game.setResult(GameResult.NONE);
        game.setCurrentPlayer(game.getMoves().size() % 2 == 0 ? 1 : 2);
        game.setUpdatedAt(System.currentTimeMillis());
        return true;
    }

    private static boolean isBoardFull(OfflineGame game) {
        int boardSize = game.getBoardSize();
        for (int x = 0; x < boardSize; x++) {
            for (int y = 0; y < boardSize; y++) {
                if (game.isCellEmpty(x, y)) return false;
            }
        }
        return true;
    }
}
