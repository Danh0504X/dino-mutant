/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package SettingsDAO;

import DAO.DBConnection;
import java.sql.*;

public class SettingsDAO implements ISettingsDAO {
    private Connection getConnection() throws SQLException { return DBConnection.getConnection(); }

    @Override
    public int getTribeBasePoints() {
        String sql = "SELECT TOP 1 tribe_base_points FROM settings ORDER BY id DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
} 