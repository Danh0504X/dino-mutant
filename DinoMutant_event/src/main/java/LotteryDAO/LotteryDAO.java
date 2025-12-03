/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package LotteryDAO;

import model.LotteryWinner;
import jakarta.servlet.ServletContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import static DAO.DBConnection.getConnection;

public class LotteryDAO {
    private static final String SESSION_ID_KEY = "lotterySessionId";
    
    /**
     * Lấy hoặc tạo session ID mới
     */
    private String getSessionId(ServletContext context) {
        String sessionId = (String) context.getAttribute(SESSION_ID_KEY);
        if (sessionId == null || sessionId.isEmpty()) {
            sessionId = UUID.randomUUID().toString();
            context.setAttribute(SESSION_ID_KEY, sessionId);
        }
        return sessionId;
    }
    
    /**
     * Reset session ID khi clear bảng
     */
    private void resetSessionId(ServletContext context) {
        context.setAttribute(SESSION_ID_KEY, UUID.randomUUID().toString());
    }
    
    /**
     * Lấy danh sách top 5 từ database
     */
    public List<LotteryWinner> getTopWinners(ServletContext context) {
        List<LotteryWinner> winners = new ArrayList<>();
        String sessionId = getSessionId(context);
        
        String sql = "SELECT rank_number, winner_name, winner_score, win_time " +
                     "FROM lottery_winners " +
                     "WHERE session_id = ? " +
                     "ORDER BY rank_number";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, sessionId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                int rank = rs.getInt("rank_number");
                String name = rs.getString("winner_name");
                int score = rs.getInt("winner_score");
                Timestamp winTime = rs.getTimestamp("win_time");
                
                LocalDateTime localDateTime = winTime != null ? 
                    winTime.toLocalDateTime() : LocalDateTime.now();
                
                LotteryWinner winner = new LotteryWinner(rank, name, score, localDateTime);
                winners.add(winner);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách người trúng từ database: " + e.getMessage());
            e.printStackTrace();
        }
        
        return winners;
    }
    
    /**
     * Thêm người trúng vào top 5
     * @param name Tên người trúng
     * @param score Điểm của người trúng
     * @param context ServletContext để lưu vào database
     * @return true nếu thêm thành công, false nếu đã đủ 5 người hoặc điểm không hợp lệ
     */
    public boolean addWinner(String name, int score, ServletContext context) {
        // VALIDATION: Chỉ cho phép điểm > 4000
        if (score <= 4000) {
            System.err.println("Người trúng không đủ điều kiện: " + name + " với điểm " + score);
            return false;
        }
        
        String sessionId = getSessionId(context);
        
        // Kiểm tra đã đủ 5 người chưa
        List<LotteryWinner> currentWinners = getTopWinners(context);
        if (currentWinners.size() >= 5) {
            return false; // Đã đủ 5 người
        }
        
        int rank = currentWinners.size() + 1;
        
        String sql = "INSERT INTO lottery_winners (rank_number, winner_name, winner_score, session_id, win_time) " +
                     "VALUES (?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, rank);
            stmt.setString(2, name);
            stmt.setInt(3, score);
            stmt.setString(4, sessionId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi thêm người trúng vào database: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra đã đủ 5 người chưa
     */
    public boolean isFull(ServletContext context) {
        List<LotteryWinner> winners = getTopWinners(context);
        return winners.size() >= 5;
    }
    
    /**
     * Lấy số lượng người hiện tại
     */
    public int getCurrentCount(ServletContext context) {
        List<LotteryWinner> winners = getTopWinners(context);
        return winners.size();
    }
    
    /**
     * Reset bảng xếp hạng (xóa tất cả trong session hiện tại và tạo session mới)
     */
    public void reset(ServletContext context) {
        String sessionId = getSessionId(context);
        
        String sql = "DELETE FROM lottery_winners WHERE session_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, sessionId);
            stmt.executeUpdate();
            
            // Tạo session ID mới
            resetSessionId(context);
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi reset bảng xếp hạng: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
