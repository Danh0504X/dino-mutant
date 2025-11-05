
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package PlayerDAO;

import model.Player;
import java.util.List;

public interface IDaoPlayer {
    // Tạo mới người chơi
    void addPlayer(Player player);
    
    // Lấy thông tin của tất cả người chơi
    List<Player> getAllPlayers();
    
    // Lấy thông tin của một người chơi theo tên
    Player getPlayerByName(String name);

    // Lấy thông tin người chơi theo id
    Player getPlayerById(int id);
    
    // Cập nhật thông tin của người chơi (điểm hoặc tên)
    void updatePlayer(Player player);
    
    // Xóa người chơi theo tên
    void deletePlayer(String name);
}