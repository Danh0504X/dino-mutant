-- Script tạo bảng lưu lịch sử quay thưởng
-- Database: Dino_Mutant

USE Dino_Mutant;
GO

-- Tạo bảng lottery_winners nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lottery_winners]') AND type in (N'U'))
BEGIN
    CREATE TABLE lottery_winners (
        id INT IDENTITY(1,1) PRIMARY KEY,
        rank_number INT NOT NULL,
        winner_name NVARCHAR(255) NOT NULL,
        winner_score INT NOT NULL,
        win_time DATETIME NOT NULL DEFAULT GETDATE(),
        session_id NVARCHAR(255) NULL, -- Để phân biệt các phiên quay khác nhau
        created_at DATETIME NOT NULL DEFAULT GETDATE()
    );
    
    -- Tạo index để tìm kiếm nhanh
    CREATE INDEX idx_rank ON lottery_winners(rank_number);
    CREATE INDEX idx_session ON lottery_winners(session_id);
    CREATE INDEX idx_win_time ON lottery_winners(win_time DESC);
    
    PRINT 'Bảng lottery_winners đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT 'Bảng lottery_winners đã tồn tại.';
END
GO

-- Tạo view để lấy top 5 hiện tại (phiên mới nhất)
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_current_top5')
    DROP VIEW vw_current_top5;
GO

CREATE VIEW vw_current_top5 AS
SELECT TOP 5
    rank_number,
    winner_name,
    winner_score,
    win_time,
    session_id
FROM lottery_winners
WHERE session_id = (SELECT TOP 1 session_id FROM lottery_winners ORDER BY created_at DESC)
ORDER BY rank_number;
GO

PRINT 'View vw_current_top5 đã được tạo thành công!';
GO



