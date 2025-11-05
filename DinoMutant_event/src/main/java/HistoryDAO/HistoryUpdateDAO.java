package HistoryDAO;

import DAO.DBConnection;
import model.HistoryUpdate;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class HistoryUpdateDAO implements IHistoryUpdateDAO {
    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    @Override
    public void insert(HistoryUpdate update) {
        String sql = "INSERT INTO history_updates (player_name, old_score, new_score, admin_username, update_time, reason) VALUES (?, ?, ?, ?, GETDATE(), ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, update.getPlayerName());
            if (update.getOldScore() == null) ps.setNull(2, Types.INTEGER); else ps.setInt(2, update.getOldScore());
            if (update.getNewScore() == null) ps.setNull(3, Types.INTEGER); else ps.setInt(3, update.getNewScore());
            ps.setString(4, update.getAdminUsername());
            ps.setString(5, update.getReason());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<HistoryUpdate> findRecent(int limit) {
        List<HistoryUpdate> list = new ArrayList<>();
        String sql = "SELECT TOP (?) id, player_name, old_score, new_score, admin_username, update_time, reason FROM history_updates ORDER BY update_time DESC, id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HistoryUpdate hu = new HistoryUpdate(
                            rs.getInt("id"),
                            rs.getString("player_name"),
                            (Integer)rs.getObject("old_score"),
                            (Integer)rs.getObject("new_score"),
                            rs.getString("admin_username"),
                            rs.getTimestamp("update_time").toLocalDateTime(),
                            rs.getString("reason")
                    );
                    list.add(hu);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
} 