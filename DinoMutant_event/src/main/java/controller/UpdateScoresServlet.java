package controller;

import HistoryDAO.HistoryUpdateDAO;
import HistoryDAO.IHistoryUpdateDAO;
import PlayerDAO.DaoPlayer;
import PlayerDAO.IDaoPlayer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.HistoryUpdate;
import model.Player;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name="UpdateScoresServlet", urlPatterns={"/updateScores"})
public class UpdateScoresServlet extends HttpServlet {
    private final IDaoPlayer playerDAO = new DaoPlayer();
    private final IHistoryUpdateDAO historyDAO = new HistoryUpdateDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminUsername") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.setContentType("application/json");
            PrintWriter out = resp.getWriter();
            out.print("{\"status\":\"error\",\"message\":\"Unauthorized\"}");
            out.flush();
            return;
        }
        
        String adminUsername = (String) session.getAttribute("adminUsername");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            // Đọc JSON từ request body
            BufferedReader reader = req.getReader();
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonBuilder.append(line);
            }
            String jsonString = jsonBuilder.toString();
            
            System.out.println("Received JSON: " + jsonString);
            
            // Parse JSON đơn giản (không dùng thư viện bên ngoài)
            List<Player> playersToUpdate = parseJsonToPlayers(jsonString);
            
            System.out.println("Parsed players count: " + playersToUpdate.size());
            
            if (playersToUpdate.isEmpty()) {
                out.print("{\"status\":\"error\",\"message\":\"No players to update\"}");
                out.flush();
                return;
            }
            
            // Lấy thông tin cũ của players để lưu vào history
            List<Player> oldPlayers = new ArrayList<>();
            for (Player p : playersToUpdate) {
                Player oldPlayer = playerDAO.getPlayerById(p.getId());
                if (oldPlayer != null) {
                    oldPlayers.add(oldPlayer);
                }
            }
            
            // Thực hiện batch update
            playerDAO.batchUpdatePlayers(playersToUpdate);
            
            // Lưu vào history cho mỗi player đã thay đổi
            for (int i = 0; i < playersToUpdate.size(); i++) {
                Player newPlayer = playersToUpdate.get(i);
                // Tìm oldPlayer tương ứng
                Player oldPlayer = null;
                for (Player old : oldPlayers) {
                    if (old.getId() == newPlayer.getId()) {
                        oldPlayer = old;
                        break;
                    }
                }
                
                if (oldPlayer != null && oldPlayer.getScore() != newPlayer.getScore()) {
                    HistoryUpdate hu = new HistoryUpdate();
                    hu.setPlayerName(oldPlayer.getName()); // Sử dụng tên từ oldPlayer
                    hu.setOldScore(oldPlayer.getScore());
                    hu.setNewScore(newPlayer.getScore());
                    hu.setAdminUsername(adminUsername);
                    hu.setReason("Batch update via admin panel");
                    historyDAO.insert(hu);
                }
            }
            
            // Trả về response thành công
            out.print("{\"status\":\"success\",\"message\":\"Updated " + playersToUpdate.size() + " players successfully\"}");
            out.flush();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error in UpdateScoresServlet: " + e.getMessage());
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            String errorMessage = e.getMessage();
            if (errorMessage == null) {
                errorMessage = "Internal server error";
            }
            // Escape JSON special characters
            errorMessage = errorMessage.replace("\\", "\\\\")
                                      .replace("\"", "\\\"")
                                      .replace("\n", "\\n")
                                      .replace("\r", "\\r");
            out.print("{\"status\":\"error\",\"message\":\"" + errorMessage + "\"}");
            out.flush();
        }
    }
    
    /**
     * Parse JSON string đơn giản thành List<Player>
     * Format JSON mong đợi: [{"id":1,"score":100},{"id":2,"score":200}]
     */
    private List<Player> parseJsonToPlayers(String json) {
        List<Player> players = new ArrayList<>();
        if (json == null || json.trim().isEmpty()) {
            return players;
        }
        
        json = json.trim();
        
        // Loại bỏ dấu ngoặc vuông ngoài cùng
        if (json.startsWith("[")) {
            json = json.substring(1);
        }
        if (json.endsWith("]")) {
            json = json.substring(0, json.length() - 1);
        }
        json = json.trim();
        
        if (json.isEmpty()) {
            return players;
        }
        
        // Tách các object JSON bằng regex phức tạp hơn
        // Tìm tất cả các object { ... }
        int startIdx = 0;
        while (startIdx < json.length()) {
            int objStart = json.indexOf('{', startIdx);
            if (objStart == -1) break;
            
            int objEnd = findMatchingBrace(json, objStart);
            if (objEnd == -1) break;
            
            String objStr = json.substring(objStart + 1, objEnd);
            Player player = parsePlayerObject(objStr);
            if (player != null && player.getId() > 0) {
                players.add(player);
            }
            
            startIdx = objEnd + 1;
        }
        
        return players;
    }
    
    /**
     * Tìm vị trí dấu ngoặc nhọn đóng tương ứng
     */
    private int findMatchingBrace(String str, int start) {
        int depth = 1;
        for (int i = start + 1; i < str.length(); i++) {
            if (str.charAt(i) == '{') {
                depth++;
            } else if (str.charAt(i) == '}') {
                depth--;
                if (depth == 0) {
                    return i;
                }
            }
        }
        return -1;
    }
    
    /**
     * Parse một object JSON thành Player
     */
    private Player parsePlayerObject(String objStr) {
        Player player = new Player();
        objStr = objStr.trim();
        
        System.out.println("Parsing object: " + objStr);
        
        // Tách các cặp key-value
        String[] pairs = objStr.split(",");
        for (String pair : pairs) {
            pair = pair.trim();
            int colonIdx = pair.indexOf(':');
            if (colonIdx == -1) {
                System.out.println("Skipping invalid pair (no colon): " + pair);
                continue;
            }
            
            String key = pair.substring(0, colonIdx).trim();
            String value = pair.substring(colonIdx + 1).trim();
            
            // Loại bỏ dấu ngoặc kép
            key = key.replace("\"", "").replace("'", "").trim();
            value = value.replace("\"", "").replace("'", "").trim();
            
            System.out.println("Key: " + key + ", Value: " + value);
            
            try {
                if ("id".equals(key)) {
                    int id = Integer.parseInt(value);
                    player.setId(id);
                    System.out.println("Set ID: " + id);
                } else if ("score".equals(key)) {
                    int score = Integer.parseInt(value);
                    player.setScore(score);
                    System.out.println("Set Score: " + score);
                }
            } catch (NumberFormatException e) {
                System.err.println("Number format error for key=" + key + ", value=" + value + ": " + e.getMessage());
            }
        }
        
        System.out.println("Parsed player: ID=" + player.getId() + ", Score=" + player.getScore());
        return player;
    }
}

