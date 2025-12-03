/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

public class LotteryWinner {
    private int rank; // 1-5
    private String name;
    private int score;
    private LocalDateTime winTime;
    
    public LotteryWinner() {}
    
    public LotteryWinner(int rank, String name, int score, LocalDateTime winTime) {
        this.rank = rank;
        this.name = name;
        this.score = score;
        this.winTime = winTime;
    }
    
    public int getRank() {
        return rank;
    }
    
    public void setRank(int rank) {
        this.rank = rank;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public int getScore() {
        return score;
    }
    
    public void setScore(int score) {
        this.score = score;
    }
    
    public LocalDateTime getWinTime() {
        return winTime;
    }
    
    public void setWinTime(LocalDateTime winTime) {
        this.winTime = winTime;
    }
}



