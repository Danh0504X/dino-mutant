package model;

import java.time.LocalDateTime;

public class ScoreRequest {
    private int id;
    private String playerName;
    private Integer currentScore;
    private Integer requestedScore;
    private String reason;
    private String requesterName;
    private String status; // PENDING, APPROVED, DENIED
    private LocalDateTime createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getPlayerName() { return playerName; }
    public void setPlayerName(String playerName) { this.playerName = playerName; }

    public Integer getCurrentScore() { return currentScore; }
    public void setCurrentScore(Integer currentScore) { this.currentScore = currentScore; }

    public Integer getRequestedScore() { return requestedScore; }
    public void setRequestedScore(Integer requestedScore) { this.requestedScore = requestedScore; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getRequesterName() { return requesterName; }
    public void setRequesterName(String requesterName) { this.requesterName = requesterName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
} 