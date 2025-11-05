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
    </style>
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
</body>
</html>