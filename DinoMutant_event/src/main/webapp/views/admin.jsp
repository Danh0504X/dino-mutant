<%-- 
    Document   : admin
    Created on : Oct 2, 2025, 6:16:24 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Admin Panel</title>
    <style>
        :root { --accent:#38bdf8; --bg:#0f172a; --panel:#0b1220; }
        @keyframes floatIn { from{transform:translateY(12px);opacity:0;} to{transform:translateY(0);opacity:1;} }
        body { font-family: Arial, sans-serif; margin: 0; background: linear-gradient(180deg,#0f172a,#1e293b); color:#e2e8f0; }
        .wrap { max-width: 1100px; margin: 24px auto; padding: 0 16px; }
        .nav { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
        .btn { padding: 10px 16px; background: linear-gradient(135deg, #38bdf8, #a78bfa); color: #0b1220; text-decoration: none; border-radius: 10px; font-weight:700; }
        .btn:hover { filter: brightness(1.05); }
        .card { background: rgba(17,24,39,0.85); border:1px solid rgba(255,255,255,0.06); border-radius: 12px; padding: 16px; margin-bottom: 18px; animation: floatIn 300ms ease both; }
        label { display:block; margin: 10px 0 6px; color:#cbd5e1; }
        input[type=text], input[type=number], input[list], textarea { width: 100%; padding: 12px 14px; border-radius: 10px; border:1px solid #1f2937; background:#0b1220; color:#e2e8f0; }
        input[type=radio] { transform: scale(1.15); margin-right:6px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border-bottom: 1px solid #1f2937; padding: 12px 10px; }
        th { background: rgba(255,255,255,0.03); text-align:left; color:#cbd5e1; }
        tr:hover { background: rgba(11,18,32,0.9); }
        .inline { display:inline; }
        .muted { color:#93a3b8; font-size:12px; }
        .row { margin: 6px 0; }
        .score-input:focus { outline: 2px solid var(--accent); border-color: var(--accent) !important; }
        .btn-add-100 { cursor: pointer; border: none; color: white; transition: all 0.2s; }
        .btn-add-100:hover { transform: scale(1.05); filter: brightness(1.1); }
        .btn-add-100:active { transform: scale(0.95); }
        #saveStatus { color: #10b981; }
        #saveStatus.error { color: #ef4444; }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="wrap">
    <div class="nav">
        <div><strong>Admin Panel</strong></div>
        <div>
            <a class="btn" href="${pageContext.request.contextPath}/home">Home</a>
            <a class="btn" href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>

    <c:if test="${param.updated == '1'}"><p style="color:#10b981;">Updated successfully.</p></c:if>
    <c:if test="${param.error == 'player_not_found'}"><p style="color:#ef4444;">Player not found.</p></c:if>
    <c:if test="${param.req_approved == '1'}"><p style="color:#10b981;">Request approved.</p></c:if>
    <c:if test="${param.req_denied == '1'}"><p style="color:#f59e0b;">Request denied.</p></c:if>

    <!-- Bảng quản lý điểm hàng loạt -->
    <div class="card">
        <h3>Quản Lý Điểm Hàng Loạt</h3>
        <div style="margin-bottom: 15px;">
            <button type="button" id="saveAllBtn" class="btn" style="background: linear-gradient(135deg, #10b981, #059669);">
                💾 Lưu Tất Cả Điểm
            </button>
            <span id="saveStatus" style="margin-left: 15px; font-weight: 600;"></span>
        </div>
        <table id="playersTable">
            <thead>
                <tr>
                    <th style="width: 50px;">#</th>
                    <th>Tên Người Chơi</th>
                    <th style="width: 200px;">Điểm</th>
                    <th style="width: 120px;">Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${players}" varStatus="status">
                    <tr data-player-id="${p.id}">
                        <td>${status.index + 1}</td>
                        <td><c:out value="${p.name}" /></td>
                        <td>
                            <input type="number" 
                                   class="score-input" 
                                   data-player-id="${p.id}"
                                   data-original-score="${p.score}"
                                   value="${p.score}" 
                                   style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid #1f2937; background: #0b1220; color: #e2e8f0; text-align: center; font-weight: 600;" />
                        </td>
                        <td>
                            <button type="button" 
                                    class="btn-add-100" 
                                    data-player-id="${p.id}"
                                    style="padding: 6px 12px; font-size: 13px; background: linear-gradient(135deg, #3b82f6, #2563eb);">
                                +100
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="card">
        <h3>Update Player</h3>
        <c:if test="${not empty sessionScope.sessionTotalDelta}">
            <div class="muted">You are changing total: <strong><c:out value="${sessionScope.sessionTotalDelta}"/></strong></div>
        </c:if>
        <form method="post" action="${pageContext.request.contextPath}/updateScore">
            <div class="row">
                <label for="playerSearch">Choose Player</label>
                <input type="text" id="playerSearch" name="playerSearch" list="playerOptions" placeholder="Type to search..." autocomplete="off" required>
                <datalist id="playerOptions">
                    <c:forEach var="p" items="${players}">
                        <option data-id="${p.id}" value="${p.name}">${p.name} (score: ${p.score})</option>
                    </c:forEach>
                </datalist>
                <input type="hidden" id="playerId" name="playerId">
                <span class="muted">Gợi ý theo ký tự, ví dụ gõ "v" để lọc tên bắt đầu bằng v.</span>
            </div>
            <script>
            (function(){
                const input = document.getElementById('playerSearch');
                const hidden = document.getElementById('playerId');
                const options = document.getElementById('playerOptions').children;
                function setIdFromValue(val){
                    hidden.value = '';
                    for (let i = 0; i < options.length; i++) {
                        const opt = options[i];
                        if (opt.value.toLowerCase() === val.toLowerCase()) {
                            hidden.value = opt.getAttribute('data-id');
                            break;
                        }
                    }
                }
                input.addEventListener('change', function(){ setIdFromValue(this.value); });
                input.addEventListener('input', function(){ setIdFromValue(this.value); });
            })();
            </script>
            <label>Rename (optional)</label>
            <input type="text" name="name" placeholder="New name" />
            <label>Increase score</label>
            <label><input type="radio" name="increment" value="100"> +100</label>
            <label><input type="radio" name="increment" value="200"> +200</label>
            <label><input type="radio" name="increment" value="500"> +500</label>
            <label>Or set new score</label>
            <input type="number" name="newScore" placeholder="New Score" />
            <label>Reason (optional)</label>
            <input type="text" name="reason" placeholder="Reason" />
            <div style="margin-top:10px;">
                <input type="submit" value="Save" class="btn" />
            </div>
        </form>
    </div>

    <div class="card">
        <h3>Pending Score Requests</h3>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Player</th>
                    <th>Current</th>
                    <th>Requested</th>
                    <th>Reason</th>
                    <th>Requester</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${requests}">
                    <tr>
                        <td>${r.id}</td>
                        <td>${r.playerName}</td>
                        <td>${r.currentScore}</td>
                        <td>${r.requestedScore}</td>
                        <td>${r.reason}</td>
                        <td>${r.requesterName}</td>
                        <td>
                            <form class="inline" method="post" action="${pageContext.request.contextPath}/request/action">
                                <input type="hidden" name="id" value="${r.id}" />
                                <input type="hidden" name="action" value="APPROVE" />
                                <button class="btn" type="submit">Approve</button>
                            </form>
                            <form class="inline" method="post" action="${pageContext.request.contextPath}/request/action" style="margin-left:6px;">
                                <input type="hidden" name="id" value="${r.id}" />
                                <input type="hidden" name="action" value="DENY" />
                                <button class="btn" type="submit">Deny</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="card">
        <h3>Recent History</h3>
        <table>
            <thead>
                <tr>
                    <th>Time</th>
                    <th>Player</th>
                    <th>Old Score</th>
                    <th>New Score</th>
                    <th>Admin</th>
                    <th>Reason</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="h" items="${history}">
                <tr>
                    <td>${h.updateTime}</td>
                    <td>${h.playerName}</td>
                    <td>${h.oldScore}</td>
                    <td>${h.newScore}</td>
                    <td>${h.adminUsername}</td>
                    <td>${h.reason}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script>
$(document).ready(function() {
    // Xử lý nút +100 điểm cho mỗi player
    $('.btn-add-100').on('click', function() {
        var playerId = $(this).data('player-id');
        var $input = $('.score-input[data-player-id="' + playerId + '"]');
        var currentScore = parseInt($input.val()) || 0;
        var newScore = currentScore + 100;
        $input.val(newScore);
        
        // Highlight input để người dùng biết đã thay đổi
        $input.css('background', '#1e3a5f');
        setTimeout(function() {
            $input.css('background', '#0b1220');
        }, 300);
    });
    
    // Xử lý nút Lưu Tất Cả Điểm
    $('#saveAllBtn').on('click', function() {
        var $btn = $(this);
        var $status = $('#saveStatus');
        
        // Disable button và hiển thị loading
        $btn.prop('disabled', true);
        $btn.text('⏳ Đang lưu...');
        $status.text('').removeClass('error');
        
        // Thu thập dữ liệu từ tất cả input
        var playersData = [];
        $('.score-input').each(function() {
            var playerId = $(this).data('player-id');
            var newScore = parseInt($(this).val());
            var originalScore = parseInt($(this).data('original-score'));
            
            // Chỉ thêm vào danh sách nếu điểm đã thay đổi
            if (newScore !== originalScore) {
                playersData.push({
                    id: playerId,
                    score: newScore
                });
            }
        });
        
        if (playersData.length === 0) {
            $status.text('Không có thay đổi nào để lưu.').addClass('error');
            $btn.prop('disabled', false);
            $btn.text('💾 Lưu Tất Cả Điểm');
            return;
        }
        
        // Gửi AJAX request
        console.log('Sending data:', playersData);
        var requestUrl = '${pageContext.request.contextPath}/updateScores';
        console.log('Request URL:', requestUrl);
        
        $.ajax({
            url: requestUrl,
            type: 'POST',
            contentType: 'application/json; charset=UTF-8',
            dataType: 'json',
            data: JSON.stringify(playersData),
            success: function(response) {
                console.log('Response received:', response);
                if (response && response.status === 'success') {
                    $status.text('✓ ' + (response.message || 'Lưu thành công!')).css('color', '#10b981');
                    
                    // Cập nhật original-score cho các input đã lưu
                    playersData.forEach(function(player) {
                        var $input = $('.score-input[data-player-id="' + player.id + '"]');
                        $input.data('original-score', player.score);
                    });
                    
                    // Reload trang sau 1.5 giây để cập nhật dữ liệu
                    setTimeout(function() {
                        window.location.reload();
                    }, 1500);
                } else {
                    var errorMsg = response && response.message ? response.message : 'Unknown error';
                    $status.text('✗ Lỗi: ' + errorMsg).addClass('error');
                    $btn.prop('disabled', false);
                    $btn.text('💾 Lưu Tất Cả Điểm');
                }
            },
            error: function(xhr, status, error) {
                console.error('AJAX Error:', {xhr: xhr, status: status, error: error});
                console.error('Response Text:', xhr.responseText);
                
                var errorMsg = 'Lỗi kết nối: ' + error;
                if (xhr.status === 0) {
                    errorMsg = 'Không thể kết nối đến server. Vui lòng kiểm tra lại.';
                } else if (xhr.status === 404) {
                    errorMsg = 'Không tìm thấy servlet. Vui lòng kiểm tra URL.';
                } else if (xhr.status === 500) {
                    errorMsg = 'Lỗi server. Vui lòng kiểm tra log.';
                } else if (xhr.status === 401) {
                    errorMsg = 'Chưa đăng nhập. Vui lòng đăng nhập lại.';
                }
                
                try {
                    if (xhr.responseText) {
                        var response = JSON.parse(xhr.responseText);
                        if (response && response.message) {
                            errorMsg = response.message;
                        }
                    }
                } catch (e) {
                    console.error('Parse error:', e);
                    if (xhr.responseText) {
                        errorMsg += ' (Response: ' + xhr.responseText.substring(0, 100) + ')';
                    }
                }
                
                $status.text('✗ ' + errorMsg).addClass('error');
                $btn.prop('disabled', false);
                $btn.text('💾 Lưu Tất Cả Điểm');
            }
        });
    });
    
    // Highlight input khi giá trị thay đổi
    $('.score-input').on('input', function() {
        var $input = $(this);
        var currentValue = parseInt($input.val()) || 0;
        var originalValue = parseInt($input.data('original-score')) || 0;
        
        if (currentValue !== originalValue) {
            $input.css('border-color', '#f59e0b');
        } else {
            $input.css('border-color', '#1f2937');
        }
    });
});
</script>
</body>
</html>