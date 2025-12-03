<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Leaderboard</title>
    <style>
        :root {
            --bg1: #0f172a;
            --bg2: #1e293b;
            --accent: #38bdf8;
            --accent-2: #a78bfa;
            --gold: #fbbf24;
            --silver: #cbd5e1;
            --bronze: #f59e0b;
        }
        @keyframes floatIn { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        @keyframes pulseGlow { 0% { box-shadow: 0 0 0 rgba(56,189,248,0.0); } 50% { box-shadow: 0 0 24px rgba(56,189,248,0.25); } 100% { box-shadow: 0 0 0 rgba(56,189,248,0.0); } }
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background: radial-gradient(1000px 600px at 10% 10%, rgba(56,189,248,0.12), transparent 60%),
                        radial-gradient(800px 500px at 90% 0%, rgba(167,139,250,0.12), transparent 60%),
                        linear-gradient(180deg, var(--bg1), var(--bg2));
            color: #e2e8f0;
        }
        .container { max-width: 1100px; margin: 24px auto; padding: 0 16px; }
        .nav { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
        .brand { display:flex; align-items:center; gap:10px; font-weight: 700; letter-spacing: 0.5px; }
        .brand .dot { width:10px; height:10px; background: var(--accent); border-radius:50%; animation: pulseGlow 3s infinite; }
        .btn { padding: 10px 16px; background: linear-gradient(135deg, var(--accent), var(--accent-2)); color: #0b1220; text-decoration: none; border-radius: 10px; font-size: 14px; font-weight: 700; transition: transform 0.15s ease, filter 0.15s ease; }
        .btn:hover { transform: translateY(-1px); filter: brightness(1.05); }
        .tag { padding: 4px 10px; border-radius: 999px; font-size: 12px; color: #0f172a; margin-left: 8px; font-weight: bold; }
        .gold { background: var(--gold); }
        .silver { background: var(--silver); }
        .bronze { background: var(--bronze); }
        .top-row { display:flex; gap:14px; margin: 18px 0; }
        .top-player { flex:1; text-align:center; padding: 16px; border-radius: 12px; background: rgba(17,24,39,0.8); border: 1px solid rgba(255,255,255,0.06); animation: floatIn 320ms ease both; }
        .top-player h3 { margin: 6px 0 8px; font-size: 18px; color: #cbd5e1; }
        .top-player .score { font-size: 22px; font-weight: 800; color: #fff; }
        .top-player .medal { display:inline-block; margin-bottom:6px; padding: 4px 10px; border-radius: 999px; color:#111827; font-weight: 800; }
        .top-player:nth-child(1) .medal { background: var(--gold); }
        .top-player:nth-child(2) .medal { background: var(--silver); }
        .top-player:nth-child(3) .medal { background: var(--bronze); }
        .card { background: rgba(17,24,39,0.85); padding: 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.06); box-shadow: 0 8px 32px rgba(0,0,0,0.35); animation: floatIn 420ms ease both; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border-bottom: 1px solid #1f2937; padding: 12px 10px; text-align: left; }
        th { color: #cbd5e1; font-weight: 700; }
        tr:hover { background: rgba(11,18,32,0.9); }
        h1 { margin: 6px 0 14px; font-size: 28px; color: #e2e8f0; }
        .flash { margin-bottom: 12px; color: #10b981; font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <div class="nav">
        <div class="brand"><span class="dot"></span> Guild Leaderboard</div>
        <div>
            <span style="margin-right:10px;">TopVN: <strong>${totalScore}</strong> (base + members)</span>
            <a class="btn" href="lottery" style="background: linear-gradient(135deg, var(--gold), #f59e0b); margin-right: 8px;">🎰 Quay thưởng</a>
            <a class="btn" href="login">Admin Login</a>
            <a class="btn" href="views/request.jsp">Request Score Change</a>
        </div>
    </div>

    <c:if test="${param.request_submitted == '1'}">
        <div class="flash">Your request has been submitted. Admins will review it soon.</div>
    </c:if>

    <div class="top-row">
        <div class="top-player">
            <div class="medal">TOP 1</div>
            <h3>${players[0].name}</h3>
            <div class="score">${players[0].score}</div>
        </div>
        <div class="top-player">
            <div class="medal">TOP 2</div>
            <h3>${players[1].name}</h3>
            <div class="score">${players[1].score}</div>
        </div>
        <div class="top-player">
            <div class="medal">TOP 3</div>
            <h3>${players[2].name}</h3>
            <div class="score">${players[2].score}</div>
        </div>
    </div>

    <div class="card">
        <h1>Leaderboard</h1>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Score</th>
                    <th class="actions">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="player" items="${players}" varStatus="st">
                    <tr>
                        <td>
                            ${st.index + 1}
                            <c:choose>
                                <c:when test="${st.index == 0}"><span class="tag gold">TOP 1</span></c:when>
                                <c:when test="${st.index == 1}"><span class="tag silver">TOP 2</span></c:when>
                                <c:when test="${st.index == 2}"><span class="tag bronze">TOP 3</span></c:when>
                            </c:choose>
                        </td>
                        <td>${player.name}</td>
                        <td>${player.score}</td>
                        <td class="actions">
                            <a class="btn" href="views/request.jsp?playerName=${player.name}&currentScore=${player.score}">✏️ Request change</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>