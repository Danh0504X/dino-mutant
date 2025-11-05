/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package HistoryDAO;

import model.HistoryUpdate;
import java.util.List;

public interface IHistoryUpdateDAO {
    void insert(HistoryUpdate update);
    List<HistoryUpdate> findRecent(int limit);
} 