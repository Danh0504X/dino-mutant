/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package AdminDAO;

import model.Admin;

public interface IAdminDAO {
    Admin findByUsername(String username);
    boolean validateCredentials(String username, String password);
} 