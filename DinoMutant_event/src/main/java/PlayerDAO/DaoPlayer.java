/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package PlayerDAO;

import model.Player;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import DAO.DBConnection;
public class DaoPlayer implements IDaoPlayer {

    // Sử dụng DBConnection để lấy kết nối
    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    @Override
    public void addPlayer(Player player) {
        String sql = "INSERT INTO players (name, score) VALUES (?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, player.getName());
            stmt.setInt(2, player.getScore());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Player> getAllPlayers() {
        List<Player> players = new ArrayList<>();
        String sql = "SELECT id, name, score FROM players ORDER BY score DESC, name ASC";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Player player = new Player(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("score")
                );
                players.add(player);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return players;
    }

    @Override
    public Player getPlayerByName(String name) {
        String sql = "SELECT id, name, score FROM players WHERE name = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Player(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getInt("score")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Player getPlayerById(int id) {
        String sql = "SELECT id, name, score FROM players WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Player(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getInt("score")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void updatePlayer(Player player) {
        String sql = "UPDATE players SET name = ?, score = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, player.getName());
            stmt.setInt(2, player.getScore());
            stmt.setInt(3, player.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deletePlayer(String name) {
        String sql = "DELETE FROM players WHERE name = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void batchUpdatePlayers(List<Player> players) {
        if (players == null || players.isEmpty()) {
            System.out.println("batchUpdatePlayers: No players to update");
            return;
        }
        String sql = "UPDATE players SET score = ? WHERE id = ?";
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn == null) {
                throw new SQLException("Cannot get database connection");
            }
            
            // Tắt auto-commit để đảm bảo transaction
            boolean originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                for (Player player : players) {
                    if (player == null || player.getId() <= 0) {
                        System.out.println("Skipping invalid player: " + player);
                        continue;
                    }
                    stmt.setInt(1, player.getScore());
                    stmt.setInt(2, player.getId());
                    stmt.addBatch();
                    System.out.println("Added to batch: Player ID=" + player.getId() + ", Score=" + player.getScore());
                }
                int[] results = stmt.executeBatch();
                System.out.println("Batch update executed. Affected rows: " + java.util.Arrays.toString(results));
                
                // Commit transaction
                conn.commit();
                System.out.println("Transaction committed successfully");
            } catch (SQLException e) {
                // Rollback nếu có lỗi
                if (conn != null && !conn.isClosed()) {
                    conn.rollback();
                    System.err.println("Transaction rolled back due to error: " + e.getMessage());
                }
                throw e;
            } finally {
                // Khôi phục auto-commit
                if (conn != null && !conn.isClosed()) {
                    conn.setAutoCommit(originalAutoCommit);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Batch update failed: " + e.getMessage());
            throw new RuntimeException("Batch update failed: " + e.getMessage(), e);
        } finally {
            // Đảm bảo đóng connection
            if (conn != null) {
                try {
                    if (!conn.isClosed()) {
                        conn.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}