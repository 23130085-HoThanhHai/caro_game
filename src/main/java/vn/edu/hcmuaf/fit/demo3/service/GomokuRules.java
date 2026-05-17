package vn.edu.hcmuaf.fit.demo3.service;

import vn.edu.hcmuaf.fit.demo3.model.OfflineGame;

public final class GomokuRules {
    private GomokuRules() {}

    public static boolean isWinning(OfflineGame game, int x, int y, int player) {
        byte p = (byte) player;
        int boardSize = game.getBoardSize();

        // Horizontal
        int count = 1;
        for (int i = x - 1; i >= 0 && game.getCell(i, y) == p; i--) count++;
        for (int i = x + 1; i < boardSize && game.getCell(i, y) == p; i++) count++;
        if (count >= 5) return true;

        // Vertical
        count = 1;
        for (int i = y - 1; i >= 0 && game.getCell(x, i) == p; i--) count++;
        for (int i = y + 1; i < boardSize && game.getCell(x, i) == p; i++) count++;
        if (count >= 5) return true;

        // Diagonal \
        count = 1;
        for (int i = 1; x - i >= 0 && y - i >= 0 && game.getCell(x - i, y - i) == p; i++) count++;
        for (int i = 1; x + i < boardSize && y + i < boardSize && game.getCell(x + i, y + i) == p; i++) count++;
        if (count >= 5) return true;

        // Diagonal /
        count = 1;
        for (int i = 1; x - i >= 0 && y + i < boardSize && game.getCell(x - i, y + i) == p; i++) count++;
        for (int i = 1; x + i < boardSize && y - i >= 0 && game.getCell(x + i, y - i) == p; i++) count++;
        if (count >= 5) return true;

        return false;
    }

    public static int scoreCell(OfflineGame game, int x, int y, int player) {
        if (!game.isCellEmpty(x, y)) return -999999;

        int score = 0;
        byte p = (byte) player;
        byte enemy = (byte) (player == 1 ? 2 : 1);

        // Horizontal
        score += countLine(game, x, y, p, 1, 0) * 10;
        score += countLine(game, x, y, enemy, 1, 0) * 8;  // Defend

        // Vertical
        score += countLine(game, x, y, p, 0, 1) * 10;
        score += countLine(game, x, y, enemy, 0, 1) * 8;

        // Diagonals
        score += countLine(game, x, y, p, 1, 1) * 10;
        score += countLine(game, x, y, enemy, 1, 1) * 8;
        score += countLine(game, x, y, p, 1, -1) * 10;
        score += countLine(game, x, y, enemy, 1, -1) * 8;

        // Center bonus
        int cx = game.getBoardSize() / 2;
        int dist = Math.abs(x - cx) + Math.abs(y - cx);
        score -= dist * 2;

        return score;
    }

    private static int countLine(OfflineGame game, int x, int y, byte p, int dx, int dy) {
        int count = 0;
        int boardSize = game.getBoardSize();
        for (int i = 1; i <= 4; i++) {
            int nx = x + i * dx;
            int ny = y + i * dy;
            if (nx < 0 || nx >= boardSize || ny < 0 || ny >= boardSize) break;
            if (game.getCell(nx, ny) == p) count++;
            else break;
        }
        for (int i = 1; i <= 4; i++) {
            int nx = x - i * dx;
            int ny = y - i * dy;
            if (nx < 0 || nx >= boardSize || ny < 0 || ny >= boardSize) break;
            if (game.getCell(nx, ny) == p) count++;
            else break;
        }
        return count;
    }
}
