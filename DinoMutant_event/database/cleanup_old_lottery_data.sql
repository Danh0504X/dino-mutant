-- Script xóa dữ liệu lottery cũ (người có điểm <= 4000)
-- Database: Dino_Mutant

USE Dino_Mutant;
GO

-- Xóa tất cả người trúng có điểm <= 4000 (dữ liệu cũ từ trước khi thay đổi điều kiện)
DELETE FROM lottery_winners 
WHERE winner_score <= 4000;

PRINT 'Đã xóa ' + CAST(@@ROWCOUNT AS VARCHAR) + ' người trúng có điểm <= 4000';
GO

-- Kiểm tra lại dữ liệu
SELECT 
    rank_number,
    winner_name,
    winner_score,
    win_time,
    session_id
FROM lottery_winners
ORDER BY win_time DESC;
GO

PRINT 'Hoàn tất!';
GO



