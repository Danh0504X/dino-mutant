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
import java.io.IOException;

@WebServlet(name="UpdateScoreServlet", urlPatterns={"/updateScore"})
public class UpdateScoreServlet extends HttpServlet {
    private final IDaoPlayer playerDAO = new DaoPlayer();
    private final IHistoryUpdateDAO historyDAO = new HistoryUpdateDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminUsername") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String adminUsername = (String) session.getAttribute("adminUsername");

        int playerId = Integer.parseInt(req.getParameter("playerId"));
        String name = req.getParameter("name");
        String incrementStr = req.getParameter("increment");
        String newScoreStr = req.getParameter("newScore");
        String reason = req.getParameter("reason");

        Player player = playerDAO.getPlayerById(playerId);
        if (player == null) {
            resp.sendRedirect("admin?error=player_not_found");
            return;
        }

        Integer oldScore = player.getScore();
        Integer newScore = null;
        int sessionDelta = 0;

        if (incrementStr != null && !incrementStr.isEmpty()) {
            int inc = Integer.parseInt(incrementStr);
            newScore = oldScore + inc;
        } else if (newScoreStr != null && !newScoreStr.isEmpty()) {
            newScore = Integer.parseInt(newScoreStr);
        }

        if (name != null && !name.trim().isEmpty()) {
            player.setName(name.trim());
        }
        if (newScore != null) {
            player.setScore(newScore);
            sessionDelta = (newScore - oldScore);
        }

        playerDAO.updatePlayer(player);

        // Track session total delta
        Object existing = session.getAttribute("sessionTotalDelta");
        int accumulated = (existing instanceof Integer) ? (Integer) existing : 0;
        session.setAttribute("sessionTotalDelta", accumulated + sessionDelta);

        HistoryUpdate hu = new HistoryUpdate();
        hu.setPlayerName(player.getName());
        hu.setOldScore(oldScore);
        hu.setNewScore(newScore);
        hu.setAdminUsername(adminUsername);
        hu.setReason(reason);
        historyDAO.insert(hu);

        resp.sendRedirect(req.getContextPath() + "/admin?updated=1");
    }
}