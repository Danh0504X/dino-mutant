package controller;

import PlayerDAO.DaoPlayer;
import PlayerDAO.IDaoPlayer;
import HistoryDAO.HistoryUpdateDAO;
import HistoryDAO.IHistoryUpdateDAO;
import RequestDAO.IRequestDAO;
import RequestDAO.RequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Player;
import model.HistoryUpdate;
import model.ScoreRequest;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private final IDaoPlayer playerDAO = new DaoPlayer();
    private final IHistoryUpdateDAO historyDAO = new HistoryUpdateDAO();
    private final IRequestDAO requestDAO = new RequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminUsername") == null) {
            resp.sendRedirect("login");
            return;
        }
        List<Player> players = playerDAO.getAllPlayers();
        List<HistoryUpdate> history = historyDAO.findRecent(50);
        List<ScoreRequest> requests = requestDAO.findPending(50);
        req.setAttribute("players", players);
        req.setAttribute("history", history);
        req.setAttribute("requests", requests);
        req.getRequestDispatcher("views/admin.jsp").forward(req, resp);
    }
} 