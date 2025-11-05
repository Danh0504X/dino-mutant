/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */

public class Player {
    private int id;     // ID duy nhất cho mỗi người chơi
    private String name; 
    private int score;

    // Constructor
    public Player(int id, String name, int score) {
        this.id = id;
        this.name = name;
        this.score = score;
    }

    // Constructor không tham số
    public Player() {}

    // Getter và Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    @Override
    public String toString() {
        return "Player{id=" + id + ", name='" + name + "', score=" + score + "}";
    }
}