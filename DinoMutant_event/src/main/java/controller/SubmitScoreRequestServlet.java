package controller;

import RequestDAO.IRequestDAO;
import RequestDAO.RequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/request-score")
public class SubmitScoreRequestServlet extends HttpServlet {
    private final IRequestDAO requestDAO = new RequestDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String playerName = req.getParameter("playerName");
        String currentScore = req.getParameter("currentScore");
        String requestedScore = req.getParameter("requestedScore");
        String reason = req.getParameter("reason");
        String requesterName = req.getParameter("requesterName");

        model.ScoreRequest r = new model.ScoreRequest();
        r.setPlayerName(playerName);
        try { r.setCurrentScore(currentScore == null || currentScore.isEmpty() ? null : Integer.parseInt(currentScore)); } catch (NumberFormatException ignored) {}
        try { r.setRequestedScore(requestedScore == null || requestedScore.isEmpty() ? null : Integer.parseInt(requestedScore)); } catch (NumberFormatException ignored) {}
        r.setReason(reason);
        r.setRequesterName(requesterName);
        r.setStatus("PENDING");
        requestDAO.insert(r);

        resp.sendRedirect("home?request_submitted=1");
    }
} 