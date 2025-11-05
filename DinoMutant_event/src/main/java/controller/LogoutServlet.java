package controller;

import HistoryDAO.HistoryUpdateDAO;
import HistoryDAO.IHistoryUpdateDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            Object adminObj = session.getAttribute("adminUsername");
            Object deltaObj = session.getAttribute("sessionTotalDelta");
            if (adminObj != null && deltaObj instanceof Integer) {
                String adminUsername = (String) adminObj;
                int delta = (Integer) deltaObj;
                // Optionally, write to history_updates as a note
                IHistoryUpdateDAO historyDAO = new HistoryUpdateDAO();
                model.HistoryUpdate hu = new model.HistoryUpdate();
                hu.setPlayerName("TOTAL");
                hu.setOldScore(null);
                hu.setNewScore(null);
                hu.setAdminUsername(adminUsername);
                hu.setReason("Admin session total delta: " + (delta >= 0 ? "+" : "") + delta);
                historyDAO.insert(hu);
            }
            session.invalidate();
        }
        resp.sendRedirect("home");
    }
} 