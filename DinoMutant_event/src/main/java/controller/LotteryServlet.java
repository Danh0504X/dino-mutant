/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import model.Player;
import model.LotteryWinner;
import LotteryDAO.LotteryDAO;
import java.io.IOException;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import static DAO.DBConnection.getConnection;

@WebServlet("/lottery")
public class LotteryServlet extends HttpServlet {
    
    private LotteryDAO lotteryDAO = new LotteryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ServletContext context = getServletContext();
        // Lấy danh sách người chơi đủ điều kiện (> 4000 điểm)
        List<Player> eligiblePlayers = getEligiblePlayers();
        
        // Lấy top 5 người trúng
        req.setAttribute("eligiblePlayers", eligiblePlayers);
        req.setAttribute("topWinners", lotteryDAO.getTopWinners(context));
        req.setAttribute("isFull", lotteryDAO.isFull(context));
        req.setAttribute("currentCount", lotteryDAO.getCurrentCount(context));
        req.getRequestDispatcher("views/lottery.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ServletContext context = getServletContext();
        
        // Kiểm tra nếu đã đủ 5 người
        if (lotteryDAO.isFull(context)) {
            req.setAttribute("error", "Bảng xếp hạng đã đầy! Vui lòng reset để quay lại.");
            List<Player> eligiblePlayers = getEligiblePlayers();
            req.setAttribute("eligiblePlayers", eligiblePlayers);
            req.setAttribute("topWinners", lotteryDAO.getTopWinners(context));
            req.setAttribute("isFull", true);
            req.setAttribute("currentCount", lotteryDAO.getCurrentCount(context));
            req.getRequestDispatcher("views/lottery.jsp").forward(req, resp);
            return;
        }
        
        // Xử lý quay số và forward kết quả về JSP
        List<Player> eligiblePlayers = getEligiblePlayers();
        
        // Lọc ra những người đã có trong bảng xếp hạng
        List<LotteryWinner> currentTopWinners = lotteryDAO.getTopWinners(context);
        List<String> winnerNames = new ArrayList<>();
        for (LotteryWinner w : currentTopWinners) {
            winnerNames.add(w.getName());
        }
        
        // Loại bỏ những người đã trúng
        List<Player> filteredPlayers = new ArrayList<>();
        for (Player player : eligiblePlayers) {
            if (!winnerNames.contains(player.getName())) {
                filteredPlayers.add(player);
            }
        }
        
        if (filteredPlayers.isEmpty()) {
            String errorMsg = eligiblePlayers.isEmpty() 
                ? "Không có người chơi nào đủ điều kiện (điểm > 4000)"
                : "Tất cả người chơi đủ điều kiện đã trúng thưởng!";
            req.setAttribute("error", errorMsg);
            req.setAttribute("eligiblePlayers", eligiblePlayers);
            req.setAttribute("topWinners", currentTopWinners);
            req.setAttribute("isFull", lotteryDAO.isFull(context));
            req.setAttribute("currentCount", lotteryDAO.getCurrentCount(context));
            req.getRequestDispatcher("views/lottery.jsp").forward(req, resp);
            return;
        }
        
        // Chọn người trúng thưởng bằng thuật toán weighted random (từ danh sách đã lọc)
        // Quay lại nhiều lần nếu cần để đảm bảo không chọn người đã trúng
        Player winner = null;
        int maxRetries = 10; // Tối đa quay lại 10 lần
        int retryCount = 0;
        
        while (winner == null && retryCount < maxRetries) {
            Player selectedPlayer = selectWinner(filteredPlayers);
            
            if (selectedPlayer == null) {
                break; // Không còn người để chọn
            }
            
            // Kiểm tra lại điểm (đảm bảo > 4000)
            if (selectedPlayer.getScore() <= 4000) {
                // Loại bỏ người này khỏi danh sách và quay lại
                filteredPlayers.remove(selectedPlayer);
                retryCount++;
                continue;
            }
            
            // Kiểm tra lại xem người này đã có trong bảng chưa (double check)
            boolean alreadyExists = false;
            for (LotteryWinner w : currentTopWinners) {
                if (w.getName().equals(selectedPlayer.getName())) {
                    alreadyExists = true;
                    break;
                }
            }
            
            if (alreadyExists) {
                // Người này đã có trong bảng, loại bỏ và quay lại
                filteredPlayers.remove(selectedPlayer);
                retryCount++;
                continue;
            }
            
            // Người này hợp lệ, chấp nhận
            winner = selectedPlayer;
        }
        
        if (winner == null) {
            String errorMsg = filteredPlayers.isEmpty() 
                ? "Không còn người chơi hợp lệ để quay (tất cả đã trúng hoặc không đủ điều kiện)"
                : "Lỗi khi chọn người trúng thưởng sau " + maxRetries + " lần thử";
            req.setAttribute("error", errorMsg);
            req.setAttribute("eligiblePlayers", eligiblePlayers);
            req.setAttribute("topWinners", currentTopWinners);
            req.setAttribute("isFull", lotteryDAO.isFull(context));
            req.setAttribute("currentCount", lotteryDAO.getCurrentCount(context));
            req.getRequestDispatcher("views/lottery.jsp").forward(req, resp);
            return;
        }
        
        // Lưu người trúng vào top 5
        lotteryDAO.addWinner(winner.getName(), winner.getScore(), context);
        
        // Gửi kết quả về JSP
        req.setAttribute("winner", winner);
        req.setAttribute("eligiblePlayers", eligiblePlayers);
        // Gửi danh sách TRƯỚC KHI thêm người trúng mới (để bảng hiển thị người cũ, người mới sẽ được thêm bằng JS)
        req.setAttribute("topWinners", currentTopWinners);
        req.setAttribute("isFull", lotteryDAO.isFull(context));
        req.setAttribute("currentCount", lotteryDAO.getCurrentCount(context) - 1); // Trừ 1 vì chưa hiển thị người mới
        req.getRequestDispatcher("views/lottery.jsp").forward(req, resp);
    }

    /**
     * Lấy danh sách người chơi có điểm > 4000
     */
    private List<Player> getEligiblePlayers() {
        List<Player> players = new ArrayList<>();
        String sql = "SELECT id, name, score FROM players WHERE score > 4000 ORDER BY score DESC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                int score = rs.getInt("score");
                Player player = new Player(id, name, score);
                players.add(player);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return players;
    }

    /**
     * Thuật toán weighted random: người có điểm cao hơn sẽ có tỉ lệ trúng cao hơn NHIỀU LẦN
     * Điểm cao hơn = tỉ lệ trúng cao hơn đáng kể
     */
    private Player selectWinner(List<Player> players) {
        if (players.isEmpty()) {
            return null;
        }
        
        // Tạo trọng số dựa trên điểm số - người điểm cao có tỉ lệ cao hơn NHIỀU LẦN
        int minScore = players.stream().mapToInt(Player::getScore).min().orElse(4000);
        
        // Tính tổng trọng số
        double totalWeight = 0;
        List<Double> weights = new ArrayList<>();
        
        for (Player player : players) {
            int score = player.getScore();
            
            // Công thức cân bằng hơn: weight = base + (score - minScore) * multiplier
            // Giảm tỉ lệ để người điểm cao không quá dễ trúng
            
            double scoreDiff = score - minScore;
            // Base weight = 1 cho tất cả, thêm một phần vừa phải dựa trên điểm
            // Sử dụng căn bậc 2 để giảm sự chênh lệch
            double weight = 1.0 + Math.sqrt(scoreDiff) * 0.1;
            
            // Bonus nhẹ cho người điểm cao (giảm so với trước)
            // Nếu điểm cao hơn 2 lần so với min (8k+), tăng thêm 1.5 lần
            if (score >= minScore * 2) {
                weight *= 1.5; // Tăng nhẹ cho người điểm rất cao
            }
            // Nếu điểm cao hơn 1.5 lần so với min (6k+), tăng thêm 1.2 lần
            else if (score >= minScore * 1.5) {
                weight *= 1.2; // Tăng rất nhẹ cho người điểm cao
            }
            
            weights.add(weight);
            totalWeight += weight;
        }
        
        // Chọn ngẫu nhiên dựa trên trọng số
        Random random = new Random();
        double randomValue = random.nextDouble() * totalWeight;
        
        double cumulativeWeight = 0;
        for (int i = 0; i < players.size(); i++) {
            cumulativeWeight += weights.get(i);
            if (randomValue <= cumulativeWeight) {
                return players.get(i);
            }
        }
        
        // Fallback: trả về người đầu tiên nếu có lỗi
        return players.get(0);
    }
}

