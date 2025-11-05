package controller;

import HistoryDAO.HistoryUpdateDAO;
import HistoryDAO.IHistoryUpdateDAO;
import PlayerDAO.DaoPlayer;
import PlayerDAO.IDaoPlayer;
import RequestDAO.IRequestDAO;
import RequestDAO.RequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.HistoryUpdate;
import model.Player;
import model.ScoreRequest;
import java.io.IOException;

@WebServlet("/request/action")
public class RequestActionServlet extends HttpServlet {
    private final IRequestDAO requestDAO = new RequestDAO();
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

        int id = Integer.parseInt(req.getParameter("id"));
        String action = req.getParameter("action"); // APPROVE or DENY

        ScoreRequest r = requestDAO.findById(id);
        if (r == null) { resp.sendRedirect("admin?error=req_not_found"); return; }

        if ("DENY".equalsIgnoreCase(action)) {
            requestDAO.updateStatus(id, "DENIED");
            resp.sendRedirect(req.getContextPath() + "/admin?req_denied=1");
            return;
        }

        // APPROVE: apply score if requestedScore present
        if (r.getRequestedScore() != null) {
            Player p = playerDAO.getPlayerByName(r.getPlayerName());
            if (p != null) {
                Integer oldScore = p.getScore();
                p.setScore(r.getRequestedScore());
                playerDAO.updatePlayer(p);

                HistoryUpdate hu = new HistoryUpdate();
                hu.setPlayerName(p.getName());
                hu.setOldScore(oldScore);
                hu.setNewScore(p.getScore());
                hu.setAdminUsername(adminUsername);
                hu.setReason("Approved user request: " + (r.getReason() == null ? "" : r.getReason()));
                historyDAO.insert(hu);
            }
        }
        requestDAO.updateStatus(id, "APPROVED");
        resp.sendRedirect(req.getContextPath() + "/admin?req_approved=1");
    }
} 