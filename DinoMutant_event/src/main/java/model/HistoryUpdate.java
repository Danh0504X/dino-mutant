package model;

import java.time.LocalDateTime;

public class HistoryUpdate {
    private int id;
    private String playerName;
    private Integer oldScore;
    private Integer newScore;
    private String adminUsername;
    private LocalDateTime updateTime;
    private String reason;

    public HistoryUpdate() {}

    public HistoryUpdate(int id, String playerName, Integer oldScore, Integer newScore, String adminUsername, LocalDateTime updateTime, String reason) {
        this.id = id;
        this.playerName = playerName;
        this.oldScore = oldScore;
        this.newScore = newScore;
        this.adminUsername = adminUsername;
        this.updateTime = updateTime;
        this.reason = reason;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPlayerName() {
        return playerName;
    }

    public void setPlayerName(String playerName) {
        this.playerName = playerName;
    }

    public Integer getOldScore() {
        return oldScore;
    }

    public void setOldScore(Integer oldScore) {
        this.oldScore = oldScore;
    }

    public Integer getNewScore() {
        return newScore;
    }

    public void setNewScore(Integer newScore) {
        this.newScore = newScore;
    }

    public String getAdminUsername() {
        return adminUsername;
    }

    public void setAdminUsername(String adminUsername) {
        this.adminUsername = adminUsername;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
} 