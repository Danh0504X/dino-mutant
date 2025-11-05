<%-- 
    Document   : login
    Created on : Oct 2, 2025, 6:20:40 AM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Admin Login</title>
    <style>
        body { font-family: Arial, sans-serif; margin:0; min-height:100vh; display:flex; align-items:center; justify-content:center; background: linear-gradient(180deg,#0f172a,#1e293b); color:#e2e8f0; }
        .container { width: 100%; max-width: 400px; padding: 20px; background: rgba(17,24,39,0.85); border:1px solid rgba(255,255,255,0.06); border-radius: 12px; box-shadow: 0 8px 32px rgba(0,0,0,0.35); }
        h2 { margin-top:0; }
        label { display:block; margin: 10px 0 6px; color:#cbd5e1; }
        input[type=text], input[type=password] { width: 100%; padding: 12px 14px; border-radius: 10px; border:1px solid #1f2937; background:#0b1220; color:#e2e8f0; }
        .btn { padding: 10px 16px; background: linear-gradient(135deg, #38bdf8, #a78bfa); color: #0b1220; text-decoration: none; border: none; border-radius: 10px; cursor: pointer; font-weight:700; }
        .actions { display:flex; align-items:center; gap: 10px; margin-top:12px; }
        .link { color:#93a3b8; }
        .error { color: #f87171; margin-bottom: 8px; font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <h2>Admin Login</h2>
    <c:if test="${param.error == '1'}">
        <div class="error">Invalid username or password</div>
    </c:if>
    <form method="post" action="login">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" required>
        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>
        <div class="actions">
            <button class="btn" type="submit">Login</button>
            <a class="link" href="home">Back to Leaderboard</a>
        </div>
    </form>
</div>
</body>
</html>