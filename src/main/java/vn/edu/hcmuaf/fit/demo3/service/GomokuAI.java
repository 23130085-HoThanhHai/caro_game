package vn.edu.hcmuaf.fit.demo3.service;

import vn.edu.hcmuaf.fit.demo3.model.OfflineGame;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public final class GomokuAI {
    private static final Random random = new Random();
    private static final int[][] DIRECTIONS = new int[][]{
            {1, 0}, {0, 1}, {1, 1}, {1, -1}
    };

    private GomokuAI() {}

    public static int[] makeMove(OfflineGame game) {
        switch (game.getDifficulty()) {
            case EASY:
                return makeRandomMove(game);
            case MEDIUM:
                return makeMediumMove(game);
            case HARD:
                return makeHardMove(game);
            default:
                return makeRandomMove(game);
        }
    }

    // Easy: Random valid move
    private static int[] makeRandomMove(OfflineGame game) {
        List<int[]> validMoves = generateAllMoves(game);
        if (validMoves.isEmpty()) return null;
        return validMoves.get(random.nextInt(validMoves.size()));
    }

    // Medium: Heuristic scoring + threat detection
    private static int[] makeMediumMove(OfflineGame game) {
        int[] winningMove = findWinningMove(game, 2);
        if (winningMove != null) return winningMove;
        int[] blockingMove = findWinningMove(game, 1);
        if (blockingMove != null) return blockingMove;

        // Score all empty cells nearby existing stones
        int bestScore = Integer.MIN_VALUE;
        int[] bestMove = null;
        int boardSize = game.getBoardSize();

        for (int x = 0; x < boardSize; x++) {
            for (int y = 0; y < boardSize; y++) {
                if (!game.isCellEmpty(x, y)) continue;
                if (!isNearbyStone(game, x, y)) continue;

                int score = scoreCellMedium(game, x, y);
                if (score > bestScore) {
                    bestScore = score;
                    bestMove = new int[]{x, y};
                }
            }
        }

        if (bestMove != null) return bestMove;

        // Fallback: center move
        int c = boardSize / 2;
        return new int[]{c, c};
    }

    // Hard: Minimax with alpha-beta pruning
    private static int[] makeHardMove(OfflineGame game) {
        int[] winningMove = findWinningMove(game, 2);
        if (winningMove != null) return winningMove;
        int[] blockingMove = findWinningMove(game, 1);
        if (blockingMove != null) return blockingMove;

        int bestScore = Integer.MIN_VALUE;
        int[] bestMove = null;
        int depth = game.getMoves().size() < 6 ? 3 : 4;

        List<int[]> topMoves = generateTopMoves(game, 12);
        for (int[] move : topMoves) {
            game.setCell(move[0], move[1], (byte) 2);
            int score = minimax(game, depth - 1, Integer.MIN_VALUE, Integer.MAX_VALUE, false);
            game.setCell(move[0], move[1], (byte) 0);

            if (score > bestScore) {
                bestScore = score;
                bestMove = move;
            }
        }

        if (bestMove != null) return bestMove;
        return topMoves.isEmpty() ? makeRandomMove(game) : topMoves.get(0);
    }

    private static int minimax(OfflineGame game, int depth, int alpha, int beta, boolean isMaximizing) {
        if (hasWinner(game, 2)) return 1_000_000 + depth;
        if (hasWinner(game, 1)) return -1_000_000 - depth;

        if (depth == 0) {
            return evaluateBoard(game);
        }

        List<int[]> moves = generateTopMoves(game, 6);
        if (moves.isEmpty()) return evaluateBoard(game);

        if (isMaximizing) {
            int maxEval = Integer.MIN_VALUE;
            for (int[] move : moves) {
                game.setCell(move[0], move[1], (byte) 2);
                int eval = minimax(game, depth - 1, alpha, beta, false);
                game.setCell(move[0], move[1], (byte) 0);

                maxEval = Math.max(maxEval, eval);
                alpha = Math.max(alpha, eval);
                if (beta <= alpha) break;
            }
            return maxEval;
        } else {
            int minEval = Integer.MAX_VALUE;
            for (int[] move : moves) {
                game.setCell(move[0], move[1], (byte) 1);
                int eval = minimax(game, depth - 1, alpha, beta, true);
                game.setCell(move[0], move[1], (byte) 0);

                minEval = Math.min(minEval, eval);
                beta = Math.min(beta, eval);
                if (beta <= alpha) break;
            }
            return minEval;
        }
    }

    private static int evaluateBoard(OfflineGame game) {
        int score = 0;
        int boardSize = game.getBoardSize();

        for (int x = 0; x < boardSize; x++) {
            for (int y = 0; y < boardSize; y++) {
                if (game.getCell(x, y) != 0) continue;
                score += scoreCellHard(game, x, y);
            }
        }

        return score;
    }

    private static int scoreCellHard(OfflineGame game, int x, int y) {
        int attack = evaluateMoveForPlayer(game, x, y, 2);
        int defense = evaluateMoveForPlayer(game, x, y, 1);
        int score = attack * 2 + defense * 3;

        // Center bonus (opening strategy)
        int cx = game.getBoardSize() / 2;
        int dist = Math.abs(x - cx) + Math.abs(y - cx);
        if (game.getMoves().size() < 5) {
            score -= dist * 2;
        }

        return score;
    }

    private static int scoreCellMedium(OfflineGame game, int x, int y) {
        int attack = evaluateMoveForPlayer(game, x, y, 2);
        int defense = evaluateMoveForPlayer(game, x, y, 1);
        int score = attack + (defense * 2);
        return score;
    }

    private static int evaluateMoveForPlayer(OfflineGame game, int x, int y, int player) {
        int score = 0;
        byte p = (byte) player;
        int boardSize = game.getBoardSize();

        for (int[] direction : DIRECTIONS) {
            int dx = direction[0];
            int dy = direction[1];
            int connected = 1;
            int openEnds = 0;

            int nx = x + dx;
            int ny = y + dy;
            while (nx >= 0 && nx < boardSize && ny >= 0 && ny < boardSize && game.getCell(nx, ny) == p) {
                connected++;
                nx += dx;
                ny += dy;
            }
            if (nx >= 0 && nx < boardSize && ny >= 0 && ny < boardSize && game.getCell(nx, ny) == 0) {
                openEnds++;
            }

            nx = x - dx;
            ny = y - dy;
            while (nx >= 0 && nx < boardSize && ny >= 0 && ny < boardSize && game.getCell(nx, ny) == p) {
                connected++;
                nx -= dx;
                ny -= dy;
            }
            if (nx >= 0 && nx < boardSize && ny >= 0 && ny < boardSize && game.getCell(nx, ny) == 0) {
                openEnds++;
            }

            score += scoreConnected(connected, openEnds);
        }
        return score;
    }

    private static int scoreConnected(int connected, int openEnds) {
        if (connected >= 5) return 1_000_000;
        if (connected == 4 && openEnds == 2) return 200_000;
        if (connected == 4 && openEnds == 1) return 50_000;
        if (connected == 3 && openEnds == 2) return 20_000;
        if (connected == 3 && openEnds == 1) return 3_000;
        if (connected == 2 && openEnds == 2) return 500;
        if (connected == 2 && openEnds == 1) return 100;
        if (connected == 1 && openEnds == 2) return 30;
        return 0;
    }

    private static int[] findWinningMove(OfflineGame game, int player) {
        int boardSize = game.getBoardSize();
        for (int x = 0; x < boardSize; x++) {
            for (int y = 0; y < boardSize; y++) {
                if (!game.isCellEmpty(x, y)) continue;
                if (isWinningMove(game, x, y, player)) {
                    return new int[]{x, y};
                }
            }
        }
        return null;
    }

    private static boolean isWinningMove(OfflineGame game, int x, int y, int player) {
        if (!game.isCellEmpty(x, y)) return false;
        game.setCell(x, y, (byte) player);
        boolean win = GomokuRules.isWinning(game, x, y, player);
        game.setCell(x, y, (byte) 0);
        return win;
    }

    private static boolean hasWinner(OfflineGame game, int player) {
        int boardSize = game.getBoardSize();
        for (int x = 0; x < boardSize; x++) {
            for (int y = 0; y < boardSize; y++) {
                if (game.getCell(x, y) == player && GomokuRules.isWinning(game, x, y, player)) {
                    return true;
                }
            }
        }
        return false;
    }

    private static List<int[]> generateTopMoves(OfflineGame game, int count) {
        List<int[]> candidates = new ArrayList<>();
        int boardSize = game.getBoardSize();

        for (int x = 0; x < boardSize; x++) {
            for (int y = 0; y < boardSize; y++) {
                if (!game.isCellEmpty(x, y)) continue;
                if (!isNearbyStone(game, x, y) && game.getMoves().size() > 0) continue;
                candidates.add(new int[]{x, y});
            }
        }

        candidates.sort((a, b) -> Integer.compare(scoreCellHard(game, b[0], b[1]), scoreCellHard(game, a[0], a[1])));
        return candidates.subList(0, Math.min(count, candidates.size()));
    }

    private static List<int[]> generateAllMoves(OfflineGame game) {
        List<int[]> moves = new ArrayList<>();
        int boardSize = game.getBoardSize();

        for (int x = 0; x < boardSize; x++) {
            for (int y = 0; y < boardSize; y++) {
                if (game.isCellEmpty(x, y)) {
                    moves.add(new int[]{x, y});
                }
            }
        }

        return moves;
    }

    private static boolean isNearbyStone(OfflineGame game, int x, int y) {
        int range = 2;
        for (int dx = -range; dx <= range; dx++) {
            for (int dy = -range; dy <= range; dy++) {
                if (dx == 0 && dy == 0) continue;
                byte cell = game.getCell(x + dx, y + dy);
                if (cell == 1 || cell == 2) return true;
            }
        }
        return false;
    }
}

