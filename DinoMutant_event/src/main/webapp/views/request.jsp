<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Request Score Change</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 24px;
            background: #f0f4f8;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            max-width: 560px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            transition: box-shadow 0.3s ease;
        }
        .container:hover {
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }
        label {
            display: block;
            margin: 12px 0 6px;
            font-weight: bold;
            color: #333;
        }
        input[type=text], input[type=number], textarea {
            width: 100%;
            padding: 12px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-bottom: 12px;
            font-size: 16px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        input[type=text]:focus, input[type=number]:focus, textarea:focus {
            border-color: #1976d2;
            box-shadow: 0 0 8px rgba(25, 118, 210, 0.3);
            outline: none;
        }
        .btn {
            padding: 12px 20px;
            background: #1976d2;
            color: #fff;
            text-decoration: none;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s ease, transform 0.2s ease;
        }
        .btn:hover {
            background: #125aa0;
            transform: translateY(-2px);
        }
        .btn:active {
            background: #0d3c7f;
            transform: translateY(0);
        }
        .nav a {
            color: #1976d2;
            text-decoration: none;
            font-size: 16px;
            font-weight: bold;
            transition: color 0.3s ease;
        }
        .nav a:hover {
            color: #125aa0;
        }
        h2 {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
            text-align: center;
        }
        textarea {
            resize: vertical;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="nav">
        <a href="home">← Back to Leaderboard</a>
    </div>
    <h2>Request Score Change</h2>
    <form method="post" action="${pageContext.request.contextPath}/request-score">
        <label for="playerName">Player Name</label>
        <input type="text" id="playerName" name="playerName" required value="${param.playerName}">

        <label for="currentScore">Current Score (optional)</label>
        <input type="number" id="currentScore" name="currentScore" value="${param.currentScore}">

        <label for="requestedScore">Requested New Score (optional)</label>
        <input type="number" id="requestedScore" name="requestedScore" required>

        <label for="reason">Reason (optional)</label>
        <textarea id="reason" name="reason" rows="3" placeholder="Why should this be updated?"></textarea>

        <label for="requesterName">Your Name (optional)</label>
        <input type="text" id="requesterName" name="requesterName" placeholder="Your nickname or contact">

        <div style="text-align: center;">
            <button class="btn" type="submit">Submit Request</button>
        </div>
    </form>
</div>

</body>
</html>