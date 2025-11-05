package RequestDAO;

import DAO.DBConnection;
import model.ScoreRequest;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RequestDAO implements IRequestDAO {
    private Connection getConnection() throws SQLException { return DBConnection.getConnection(); }

    @Override
    public void insert(ScoreRequest r) {
        String sql = "INSERT INTO score_requests (player_name, current_score, requested_score, reason, requester_name, status, created_at) VALUES (?,?,?,?,?, 'PENDING', GETDATE())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getPlayerName());
            if (r.getCurrentScore() == null) ps.setNull(2, Types.INTEGER); else ps.setInt(2, r.getCurrentScore());
            if (r.getRequestedScore() == null) ps.setNull(3, Types.INTEGER); else ps.setInt(3, r.getRequestedScore());
            ps.setString(4, r.getReason());
            ps.setString(5, r.getRequesterName());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<ScoreRequest> findPending(int limit) {
        List<ScoreRequest> list = new ArrayList<>();
        String sql = "SELECT TOP 50 id, player_name, current_score, requested_score, reason, requester_name, status, created_at FROM score_requests WHERE status='PENDING' ORDER BY created_at DESC, id DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ScoreRequest r = new ScoreRequest();
                    r.setId(rs.getInt("id"));
                    r.setPlayerName(rs.getString("player_name"));
                    r.setCurrentScore((Integer) rs.getObject("current_score"));
                    r.setRequestedScore((Integer) rs.getObject("requested_score"));
                    r.setReason(rs.getString("reason"));
                    r.setRequesterName(rs.getString("requester_name"));
                    r.setStatus(rs.getString("status"));
                    r.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void updateStatus(int id, String status) {
        String sql = "UPDATE score_requests SET status=? WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public ScoreRequest findById(int id) {
        String sql = "SELECT id, player_name, current_score, requested_score, reason, requester_name, status, created_at FROM score_requests WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ScoreRequest r = new ScoreRequest();
                    r.setId(rs.getInt("id"));
                    r.setPlayerName(rs.getString("player_name"));
                    r.setCurrentScore((Integer) rs.getObject("current_score"));
                    r.setRequestedScore((Integer) rs.getObject("requested_score"));
                    r.setReason(rs.getString("reason"));
                    r.setRequesterName(rs.getString("requester_name"));
                    r.setStatus(rs.getString("status"));
                    r.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    return r;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
} 