<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quay số trúng thưởng</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg1: #0a0e1a;
            --bg2: #1a1f35;
            --bg3: #2d1b4e;
            --accent: #00d9ff;
            --accent-2: #8b5cf6;
            --accent-3: #ec4899;
            --gold: #ffd700;
            --gold-2: #ffed4e;
            --success: #10b981;
            --danger: #ef4444;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            min-height: 100vh;
            background: 
                radial-gradient(ellipse 1200px 800px at 0% 0%, rgba(0,217,255,0.15), transparent 50%),
                radial-gradient(ellipse 1000px 700px at 100% 0%, rgba(139,92,246,0.15), transparent 50%),
                radial-gradient(ellipse 800px 600px at 50% 100%, rgba(236,72,153,0.1), transparent 50%),
                linear-gradient(135deg, var(--bg1) 0%, var(--bg2) 50%, var(--bg3) 100%);
            background-attachment: fixed;
            color: #e2e8f0;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            font-weight: 400;
            letter-spacing: -0.01em;
            position: relative;
            overflow-x: hidden;
        }
        
        /* Animated background particles */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                radial-gradient(2px 2px at 20% 30%, rgba(0,217,255,0.3), transparent),
                radial-gradient(2px 2px at 60% 70%, rgba(139,92,246,0.3), transparent),
                radial-gradient(1px 1px at 50% 50%, rgba(236,72,153,0.2), transparent);
            background-size: 200% 200%;
            animation: particleMove 20s ease infinite;
            pointer-events: none;
            z-index: 0;
        }
        
        @keyframes particleMove {
            0%, 100% { background-position: 0% 0%, 100% 100%, 50% 50%; }
            50% { background-position: 100% 100%, 0% 0%, 50% 50%; }
        }
        
        .lottery-container {
            max-width: 1400px;
            width: 100%;
            text-align: center;
            position: relative;
            z-index: 1;
        }
        
        .lottery-main {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            margin-top: 40px;
            align-items: start;
        }
        
        @media (max-width: 1200px) {
            .lottery-main {
                grid-template-columns: 1fr;
                gap: 30px;
            }
        }
        
        .lottery-title {
            font-family: 'Poppins', 'Inter', sans-serif;
            font-size: 56px;
            font-weight: 900;
            margin-bottom: 30px;
            background: linear-gradient(135deg, var(--accent) 0%, var(--accent-2) 50%, var(--gold) 100%);
            background-size: 200% 200%;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: gradientShift 3s ease infinite;
            letter-spacing: -0.02em;
            line-height: 1.2;
            text-shadow: 0 0 60px rgba(0,217,255,0.4);
            filter: drop-shadow(0 4px 20px rgba(0,217,255,0.3));
            position: relative;
        }
        
        .lottery-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 200px;
            height: 4px;
            background: linear-gradient(90deg, transparent, var(--accent), var(--gold), var(--accent), transparent);
            border-radius: 2px;
            animation: shimmer 2s ease-in-out infinite;
        }
        
        @keyframes gradientShift {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }
        
        @keyframes shimmer {
            0%, 100% { opacity: 0.5; transform: translateX(-50%) scaleX(1); }
            50% { opacity: 1; transform: translateX(-50%) scaleX(1.2); }
        }
        
        .slot-machine {
            background: rgba(10, 14, 26, 0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 2px solid;
            border-image: linear-gradient(135deg, var(--accent), var(--accent-2), var(--accent-3)) 1;
            border-radius: 24px;
            padding: 50px;
            margin: 30px 0;
            box-shadow: 
                0 25px 80px rgba(0,0,0,0.6),
                0 0 0 1px rgba(0,217,255,0.1),
                inset 0 0 80px rgba(0,217,255,0.05),
                inset 0 0 40px rgba(139,92,246,0.05);
            position: relative;
            overflow: hidden;
            z-index: 1;
            transition: all 0.4s ease;
        }
        
        .slot-machine:hover {
            box-shadow: 
                0 30px 100px rgba(0,0,0,0.7),
                0 0 0 1px rgba(0,217,255,0.2),
                inset 0 0 100px rgba(0,217,255,0.1),
                inset 0 0 60px rgba(139,92,246,0.1);
            transform: translateY(-2px);
        }
        
        .slot-machine::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, 
                transparent 30%, 
                rgba(0,217,255,0.1) 50%, 
                transparent 70%);
            animation: rotate 8s linear infinite;
            z-index: -1;
        }
        
        .slot-machine::after {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(-45deg, 
                transparent 30%, 
                rgba(139,92,246,0.1) 50%, 
                transparent 70%);
            animation: rotate 10s linear infinite reverse;
            z-index: -1;
        }
        
        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .slot-window {
            background: linear-gradient(180deg, #050812 0%, #0a0e1a 50%, #050812 100%);
            border: 3px solid;
            border-image: linear-gradient(180deg, var(--accent), var(--accent-2)) 1;
            border-radius: 20px;
            height: 320px;
            margin: 25px 0;
            position: relative;
            overflow: hidden;
            box-shadow: 
                inset 0 0 60px rgba(0,0,0,0.9),
                inset 0 0 30px rgba(0,217,255,0.1),
                0 0 50px rgba(0,217,255,0.4),
                0 0 100px rgba(139,92,246,0.2);
        }
        
        .slot-window::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(180deg, 
                rgba(0,217,255,0.1) 0%, 
                transparent 50%, 
                rgba(139,92,246,0.1) 100%);
            pointer-events: none;
            z-index: 1;
        }
        
        .slot-reel {
            position: absolute;
            width: 100%;
            top: 0;
            left: 0;
            will-change: transform;
            z-index: 0;
        }
        
        .slot-item {
            height: 107px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', 'Poppins', sans-serif;
            font-size: 34px;
            font-weight: 700;
            color: #e2e8f0;
            border-bottom: 1px solid rgba(0,217,255,0.15);
            text-shadow: 0 0 25px rgba(0,217,255,0.6);
            white-space: nowrap;
            letter-spacing: -0.01em;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .slot-item::before {
            content: '';
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            background: linear-gradient(90deg, 
                transparent, 
                rgba(0,217,255,0.05), 
                transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .slot-item:hover::before {
            opacity: 1;
        }
        
        .slot-item.highlight {
            background: linear-gradient(180deg, 
                        rgba(0,217,255,0.5), 
                        rgba(139,92,246,0.5),
                        rgba(236,72,153,0.5),
                        rgba(139,92,246,0.5),
                        rgba(0,217,255,0.5)) !important;
            color: var(--gold) !important;
            font-size: 44px !important;
            font-weight: 900 !important;
            box-shadow: 
                0 0 60px rgba(255,215,0,0.8),
                0 0 100px rgba(255,215,0,0.4),
                0 0 150px rgba(255,215,0,0.3),
                inset 0 0 30px rgba(255,215,0,0.2) !important;
            border: 3px solid var(--gold) !important;
            border-left: none !important;
            border-right: none !important;
            animation: winnerPulse 0.6s ease-in-out infinite alternate, winnerGlow 2s ease-in-out infinite !important;
            text-shadow: 
                0 0 30px rgba(255,215,0,1),
                0 0 60px rgba(255,215,0,0.8),
                0 0 90px rgba(255,215,0,0.6) !important;
            z-index: 10 !important;
            position: relative !important;
        }
        
        @keyframes winnerPulse {
            from { 
                transform: scale(1);
            }
            to { 
                transform: scale(1.08);
            }
        }
        
        @keyframes winnerGlow {
            0%, 100% {
                box-shadow: 
                    0 0 60px rgba(255,215,0,0.8),
                    0 0 100px rgba(255,215,0,0.4),
                    inset 0 0 30px rgba(255,215,0,0.2);
            }
            50% {
                box-shadow: 
                    0 0 80px rgba(255,215,0,1),
                    0 0 120px rgba(255,215,0,0.6),
                    inset 0 0 40px rgba(255,215,0,0.3);
            }
        }
        
        .spin-btn {
            font-family: 'Poppins', 'Inter', sans-serif;
            padding: 20px 60px;
            font-size: 26px;
            font-weight: 800;
            background: linear-gradient(135deg, var(--accent) 0%, var(--accent-2) 50%, var(--accent-3) 100%);
            background-size: 200% 200%;
            color: #0a0e1a;
            border: none;
            border-radius: 18px;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 
                0 10px 30px rgba(0,217,255,0.5),
                0 0 20px rgba(139,92,246,0.3),
                inset 0 1px 0 rgba(255,255,255,0.2);
            margin-top: 35px;
            text-transform: uppercase;
            letter-spacing: 2px;
            position: relative;
            z-index: 10;
            overflow: hidden;
            animation: buttonGradient 3s ease infinite;
        }
        
        .spin-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }
        
        .spin-btn:hover:not(:disabled)::before {
            left: 100%;
        }
        
        .spin-btn:hover:not(:disabled) {
            transform: translateY(-4px) scale(1.02);
            box-shadow: 
                0 15px 40px rgba(0,217,255,0.6),
                0 0 30px rgba(139,92,246,0.4),
                inset 0 1px 0 rgba(255,255,255,0.3);
            filter: brightness(1.15);
        }
        
        .spin-btn:active:not(:disabled) {
            transform: translateY(-2px) scale(0.98);
        }
        
        .spin-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            background: linear-gradient(135deg, #475569, #64748b);
            animation: none;
        }
        
        @keyframes buttonGradient {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }
        
        .toggle-panel-btn {
            font-family: 'Poppins', 'Inter', sans-serif;
            margin-bottom: 15px;
            padding: 10px 20px;
            font-size: 14px;
            font-weight: 700;
            background: rgba(56,189,248,0.2);
            color: var(--accent);
            border: 2px solid var(--accent);
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .toggle-panel-btn:hover {
            background: rgba(56,189,248,0.3);
            transform: translateY(-2px);
        }
        
        .top-winners-panel.collapsed {
            max-height: 80px;
            overflow: hidden;
        }
        
        .top-winners-panel.collapsed .top-winners-list,
        .top-winners-panel.collapsed .progress-indicator,
        .top-winners-panel.collapsed form {
            display: none;
        }
        
        .back-btn {
            font-family: 'Inter', 'Poppins', sans-serif;
            position: fixed;
            top: 20px;
            left: 20px;
            padding: 12px 24px;
            background: rgba(10, 14, 26, 0.9);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            color: #e2e8f0;
            text-decoration: none;
            border-radius: 12px;
            border: 2px solid rgba(0,217,255,0.3);
            transition: all 0.3s ease;
            z-index: 100;
            font-weight: 600;
            letter-spacing: -0.01em;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }
        
        .back-btn:hover {
            background: rgba(0,217,255,0.15);
            border-color: var(--accent);
            transform: translateX(-3px);
            box-shadow: 0 6px 20px rgba(0,217,255,0.3);
        }
        
        .eligible-info {
            font-family: 'Inter', 'Poppins', sans-serif;
            margin-bottom: 25px;
            color: #cbd5e1;
            font-size: 20px;
            font-weight: 500;
            letter-spacing: -0.01em;
            padding: 15px 25px;
            background: rgba(0,217,255,0.05);
            border-radius: 15px;
            border: 1px solid rgba(0,217,255,0.2);
            display: inline-block;
            backdrop-filter: blur(10px);
        }
        
        .eligible-count {
            color: var(--accent);
            font-weight: 800;
            font-size: 24px;
            text-shadow: 0 0 20px rgba(0,217,255,0.6);
            animation: countPulse 2s ease-in-out infinite;
        }
        
        @keyframes countPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        
        .error-message {
            font-family: 'Inter', 'Poppins', sans-serif;
            color: #ff6b6b;
            background: rgba(239,68,68,0.15);
            backdrop-filter: blur(10px);
            padding: 18px 25px;
            border-radius: 15px;
            margin: 25px 0;
            border: 2px solid rgba(239,68,68,0.5);
            font-weight: 600;
            letter-spacing: -0.01em;
            box-shadow: 0 8px 25px rgba(239,68,68,0.2);
            animation: errorShake 0.5s ease;
        }
        
        @keyframes errorShake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
        
        form {
            display: inline-block;
        }
        
        /* Bảng Top 5 */
        .top-winners-panel {
            background: rgba(10, 14, 26, 0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 2px solid;
            border-image: linear-gradient(135deg, var(--gold), var(--accent-2), var(--gold)) 1;
            border-radius: 24px;
            padding: 35px;
            box-shadow: 
                0 25px 80px rgba(0,0,0,0.6),
                0 0 0 1px rgba(255,215,0,0.1),
                inset 0 0 80px rgba(255,215,0,0.05),
                inset 0 0 40px rgba(139,92,246,0.05);
            position: relative;
            overflow: hidden;
            z-index: 1;
            transition: all 0.5s ease;
        }
        
        .top-winners-panel:hover {
            box-shadow: 
                0 30px 100px rgba(0,0,0,0.7),
                0 0 0 1px rgba(255,215,0,0.2),
                inset 0 0 100px rgba(255,215,0,0.1),
                inset 0 0 60px rgba(139,92,246,0.1);
            transform: translateY(-2px);
        }
        
        .top-winners-panel.hidden {
            opacity: 0;
            pointer-events: none;
            transform: translateX(20px);
        }
        
        .top-winners-panel::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,215,0,0.1), transparent);
            animation: rotate 8s linear infinite;
            z-index: -1;
        }
        
        .top-winners-panel::after {
            content: '';
            position: absolute;
            bottom: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(-45deg, transparent, rgba(139,92,246,0.1), transparent);
            animation: rotate 10s linear infinite reverse;
            z-index: -1;
        }
        
        .top-winners-title {
            font-family: 'Poppins', 'Inter', sans-serif;
            font-size: 36px;
            font-weight: 900;
            margin-bottom: 30px;
            background: linear-gradient(135deg, var(--gold) 0%, #ffed4e 50%, var(--gold) 100%);
            background-size: 200% 200%;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: -0.02em;
            text-align: center;
            animation: gradientShift 3s ease infinite;
            filter: drop-shadow(0 4px 20px rgba(255,215,0,0.4));
            position: relative;
        }
        
        .top-winners-title::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 50%;
            transform: translateX(-50%);
            width: 150px;
            height: 3px;
            background: linear-gradient(90deg, transparent, var(--gold), transparent);
            border-radius: 2px;
        }
        
        .top-winners-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .winner-item {
            background: linear-gradient(135deg, rgba(0,217,255,0.12), rgba(139,92,246,0.12));
            border: 2px solid rgba(0,217,255,0.3);
            border-radius: 18px;
            padding: 22px;
            display: flex;
            align-items: center;
            gap: 22px;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }
        
        .winner-item::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 6px;
            background: linear-gradient(180deg, var(--accent), var(--accent-2), var(--accent-3));
            box-shadow: 0 0 15px rgba(0,217,255,0.6);
        }
        
        .winner-item::after {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.5s ease;
        }
        
        .winner-item:hover {
            transform: translateX(8px) translateY(-2px);
            border-color: var(--accent);
            box-shadow: 
                0 12px 35px rgba(0,217,255,0.4),
                0 0 20px rgba(139,92,246,0.3);
            background: linear-gradient(135deg, rgba(0,217,255,0.18), rgba(139,92,246,0.18));
        }
        
        .winner-item:hover::after {
            left: 100%;
        }
        
        .winner-item.top1 {
            background: linear-gradient(135deg, rgba(255,215,0,0.25), rgba(255,237,78,0.25));
            border-color: var(--gold);
            box-shadow: 
                0 0 40px rgba(255,215,0,0.5),
                0 8px 25px rgba(255,215,0,0.3);
            animation: top1Glow 3s ease-in-out infinite;
        }
        
        .winner-item.top1::before {
            background: linear-gradient(180deg, var(--gold), #ffed4e, var(--gold));
            width: 8px;
            box-shadow: 0 0 20px rgba(255,215,0,0.8);
        }
        
        @keyframes top1Glow {
            0%, 100% {
                box-shadow: 
                    0 0 40px rgba(255,215,0,0.5),
                    0 8px 25px rgba(255,215,0,0.3);
            }
            50% {
                box-shadow: 
                    0 0 60px rgba(255,215,0,0.7),
                    0 8px 35px rgba(255,215,0,0.5);
            }
        }
        
        .winner-rank {
            font-family: 'Poppins', 'Inter', sans-serif;
            font-size: 40px;
            font-weight: 900;
            min-width: 70px;
            text-align: center;
            background: linear-gradient(135deg, var(--accent), var(--accent-2));
            background-size: 200% 200%;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            filter: drop-shadow(0 2px 10px rgba(0,217,255,0.5));
            animation: gradientShift 3s ease infinite;
        }
        
        .winner-item.top1 .winner-rank {
            background: linear-gradient(135deg, var(--gold), #ffed4e, var(--gold));
            background-size: 200% 200%;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 48px;
            filter: drop-shadow(0 2px 15px rgba(255,215,0,0.6));
        }
        
        .winner-info {
            flex: 1;
            text-align: left;
        }
        
        .winner-info-name {
            font-family: 'Poppins', 'Inter', sans-serif;
            font-size: 26px;
            font-weight: 800;
            color: #e2e8f0;
            margin-bottom: 6px;
            letter-spacing: -0.01em;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .winner-item.top1 .winner-info-name {
            color: var(--gold);
            text-shadow: 
                0 0 25px rgba(255,215,0,0.8),
                0 2px 10px rgba(0,0,0,0.3);
        }
        
        .winner-info-score {
            font-family: 'Inter', 'Poppins', sans-serif;
            font-size: 19px;
            font-weight: 600;
            color: #cbd5e1;
            letter-spacing: -0.01em;
        }
        
        .winner-medal {
            font-size: 44px;
        }
        
        .empty-slot {
            background: rgba(30,41,59,0.4);
            backdrop-filter: blur(5px);
            border: 2px dashed rgba(0,217,255,0.3);
            border-radius: 18px;
            padding: 45px 25px;
            text-align: center;
            color: #64748b;
            font-family: 'Inter', 'Poppins', sans-serif;
            font-size: 19px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .empty-slot:hover {
            border-color: rgba(0,217,255,0.5);
            background: rgba(30,41,59,0.6);
            color: #94a3b8;
        }
        
        .reset-btn {
            font-family: 'Poppins', 'Inter', sans-serif;
            margin-top: 25px;
            padding: 14px 35px;
            font-size: 17px;
            font-weight: 700;
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 50%, #b91c1c 100%);
            background-size: 200% 200%;
            color: white;
            border: none;
            border-radius: 14px;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 
                0 6px 20px rgba(239,68,68,0.4),
                inset 0 1px 0 rgba(255,255,255,0.2);
            text-transform: uppercase;
            letter-spacing: 1.5px;
            position: relative;
            overflow: hidden;
            animation: buttonGradient 3s ease infinite;
        }
        
        .reset-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }
        
        .reset-btn:hover::before {
            left: 100%;
        }
        
        .reset-btn:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 
                0 8px 25px rgba(239,68,68,0.6),
                inset 0 1px 0 rgba(255,255,255,0.3);
            filter: brightness(1.15);
        }
        
        .reset-btn:active {
            transform: translateY(-1px) scale(0.98);
        }
        
        .progress-indicator {
            font-family: 'Inter', 'Poppins', sans-serif;
            margin-top: 20px;
            padding: 12px 18px;
            background: rgba(0,217,255,0.12);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            border: 1px solid rgba(0,217,255,0.3);
            color: var(--accent);
            font-weight: 700;
            font-size: 15px;
            box-shadow: 0 4px 15px rgba(0,217,255,0.2);
            display: inline-block;
        }
        
        .toggle-panel-btn {
            font-family: 'Poppins', 'Inter', sans-serif;
            margin-bottom: 20px;
            padding: 12px 25px;
            font-size: 15px;
            font-weight: 700;
            background: rgba(0,217,255,0.15);
            backdrop-filter: blur(10px);
            color: var(--accent);
            border: 2px solid rgba(0,217,255,0.4);
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            box-shadow: 0 4px 15px rgba(0,217,255,0.2);
        }
        
        .toggle-panel-btn:hover {
            background: rgba(0,217,255,0.25);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,217,255,0.3);
            border-color: var(--accent);
        }
    </style>
</head>
<body>
    <a href="home" class="back-btn">← Về trang chủ</a>
    
    <div class="lottery-container">
        <h1 class="lottery-title">🎰 QUAY SỐ TRÚNG THƯỞNG 🎰</h1>
        
        <div class="eligible-info">
            Có <span class="eligible-count">${eligiblePlayers.size()}</span> người chơi đủ điều kiện (điểm > 4000)
        </div>
        
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
        <div class="lottery-main">
            <!-- Bên trái: Slot Machine -->
            <div class="slot-machine">
                <div class="slot-window" id="slotWindow">
                    <div class="slot-reel" id="slotReel"></div>
                </div>
                
                <c:choose>
                    <c:when test="${eligiblePlayers.size() == 0}">
                        <button class="spin-btn" disabled>
                            Không có người chơi đủ điều kiện
                        </button>
                    </c:when>
                    <c:when test="${isFull}">
                        <button class="spin-btn" disabled>
                            Bảng xếp hạng đã đầy!
                        </button>
                    </c:when>
                    <c:otherwise>
                        <form method="post" action="lottery" id="lotteryForm" onsubmit="document.getElementById('spinBtn').disabled=true; document.getElementById('spinBtn').textContent='Đang quay số...';">
                            <button class="spin-btn" type="submit" id="spinBtn">
                                🎲 QUAY SỐ
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
                
            </div>
            
            <!-- Bên phải: Bảng Top 5 -->
            <div class="top-winners-panel" id="topWinnersPanel">
                <button class="toggle-panel-btn" id="togglePanelBtn" onclick="togglePanel()">
                    ▼ Ẩn/Hiện Bảng Xếp Hạng
                </button>
                <h2 class="top-winners-title">🏆 TOP 5 NGƯỜI TRÚNG THƯỞNG 🏆</h2>
                
                <div class="top-winners-list">
                    <!-- Hiển thị 5 vị trí, điền từng vị trí -->
                    <c:forEach begin="1" end="5" var="rank">
                        <c:set var="foundWinner" value="${null}" />
                        <c:forEach var="winner" items="${topWinners}">
                            <c:if test="${winner.rank == rank}">
                                <c:set var="foundWinner" value="${winner}" />
                            </c:if>
                        </c:forEach>
                        
                        <c:choose>
                            <c:when test="${foundWinner != null}">
                                <!-- Hiển thị người trúng -->
                                <div class="winner-item <c:if test='${foundWinner.rank == 1}'>top1</c:if>" data-rank="${foundWinner.rank}">
                                    <div class="winner-rank">
                                        <c:choose>
                                            <c:when test="${foundWinner.rank == 1}">🥇</c:when>
                                            <c:when test="${foundWinner.rank == 2}">🥈</c:when>
                                            <c:when test="${foundWinner.rank == 3}">🥉</c:when>
                                            <c:otherwise>#${foundWinner.rank}</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="winner-info">
                                        <div class="winner-info-name"><c:out value="${foundWinner.name}" /></div>
                                        <div class="winner-info-score">Điểm: ${foundWinner.score}</div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Hiển thị slot trống -->
                                <div class="empty-slot" data-rank="${rank}">
                                    <div style="font-size: 48px; margin-bottom: 10px; opacity: 0.3;">🎯</div>
                                    <div>Vị trí ${rank} đang trống</div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                
                <c:if test="${currentCount > 0}">
                    <div class="progress-indicator">
                        Đã quay: ${currentCount}/5
                    </div>
                </c:if>
                
                <form method="post" action="lotteryReset" onsubmit="return confirm('Bạn có chắc muốn xóa bảng xếp hạng? Tất cả ${currentCount} người trúng sẽ bị xóa.');" style="margin-top: 20px;">
                    <button type="submit" class="reset-btn">
                        🗑️ Clear Bảng Xếp Hạng
                    </button>
                </form>
            </div>
        </div>
    </div>
    
    <c:if test="${not empty winner}">
    <!-- Hidden data để JavaScript đọc -->
    <div id="winnerData" style="display:none;" 
         data-name="<c:out value='${winner.name}' escapeXml='true' />"
         data-score="<c:out value='${winner.score}' />"></div>
    <div id="eligiblePlayersData" style="display:none;">
        <c:forEach var="player" items="${eligiblePlayers}" varStatus="st">
        <span data-name="<c:out value='${player.name}' escapeXml='true' />" 
              data-score="<c:out value='${player.score}' />"></span>
        </c:forEach>
    </div>
    </c:if>
    
    <script>
        // Đọc dữ liệu từ hidden divs khi DOM sẵn sàng
        window.addEventListener('DOMContentLoaded', function() {
            var winnerData = null;
            var eligiblePlayers = [];
            
            var winnerDiv = document.getElementById('winnerData');
            if (winnerDiv) {
                // Có winner từ server - KHÔNG ẩn bảng, chỉ chờ để thêm vào sau
                winnerData = {
                    name: winnerDiv.getAttribute('data-name'),
                    score: parseInt(winnerDiv.getAttribute('data-score'))
                };
                
                var playersDiv = document.getElementById('eligiblePlayersData');
                if (playersDiv) {
                    var playerSpans = playersDiv.querySelectorAll('span');
                    playerSpans.forEach(function(span) {
                        eligiblePlayers.push({
                            name: span.getAttribute('data-name'),
                            score: parseInt(span.getAttribute('data-score'))
                        });
                    });
                }
                
                // Bắt đầu animation nếu có winner
                if (winnerData && eligiblePlayers.length > 0) {
                    startLotteryAnimation(winnerData, eligiblePlayers);
                }
            }
        });
        
        function startLotteryAnimation(winnerData, eligiblePlayers) {
            console.log('Bắt đầu animation quay số với', eligiblePlayers.length, 'người chơi');
            
            // Bảng top 5 đã được ẩn ở DOMContentLoaded nếu có winner
            const slotReel = document.getElementById('slotReel');
            if (!slotReel) {
                console.error('Không tìm thấy slotReel!');
                return;
            }
            
            slotReel.innerHTML = '';
            slotReel.style.transition = 'none';
            slotReel.style.transform = 'translateY(0)';
            
            // Tạo danh sách dài với nhiều items để quay liên tục
            const displayItems = [];
            const itemCount = 200; // Tạo 200 items để quay mượt
            
            // Tạo danh sách ngẫu nhiên
            for (let i = 0; i < itemCount; i++) {
                const player = eligiblePlayers[Math.floor(Math.random() * eligiblePlayers.length)];
                displayItems.push(player);
            }
            
            // Đảm bảo người trúng có mặt trong danh sách, đặt ở vị trí gần cuối
            const winnerPosition = Math.floor(itemCount * 0.85); // Đặt ở 85% của danh sách
            displayItems[winnerPosition] = winnerData;
            
            console.log('Winner position:', winnerPosition, 'Winner data:', winnerData);
            
            // Render tất cả items
            displayItems.forEach(function(player, index) {
                const item = document.createElement('div');
                item.className = 'slot-item';
                item.textContent = player.name + ' (' + player.score + ' điểm)';
                item.dataset.index = index;
                item.dataset.name = player.name;
                item.dataset.score = player.score;
                slotReel.appendChild(item);
            });
            
            // Đảm bảo slotReel có đủ chiều cao (sử dụng 107px thay vì 100px)
            slotReel.style.height = (itemCount * 107) + 'px';
            
            // Bắt đầu quay với animation mượt mà
            let currentPosition = 0;
            let spinSpeed = 15; // Tốc độ ban đầu (milliseconds) - nhanh hơn
            const minSpinSpeed = 15;
            const maxSpinSpeed = 200;
            const spinDuration = 3500; // Tổng thời gian quay 3.5 giây
            let startTime = Date.now();
            let spinInterval;
            let isStopped = false;
            
            function animate() {
                if (isStopped) return;
                
                const elapsed = Date.now() - startTime;
                const progress = Math.min(elapsed / spinDuration, 1);
                
                // Giảm tốc dần khi gần kết thúc (sau 60% thời gian)
                let currentSpeed;
                if (progress < 0.6) {
                    // Giai đoạn đầu: quay nhanh
                    currentSpeed = minSpinSpeed;
                } else {
                    // Giai đoạn cuối: giảm tốc dần
                    const slowProgress = (progress - 0.6) / 0.4; // 0 đến 1
                    currentSpeed = minSpinSpeed + (maxSpinSpeed - minSpinSpeed) * slowProgress;
                }
                
                // Di chuyển xuống (sử dụng 107px thay vì 100px)
                currentPosition++;
                const offset = -currentPosition * 107;
                slotReel.style.transform = 'translateY(' + offset + 'px)';
                
                // Kiểm tra nếu đã đến vị trí người trúng và đã qua 60% thời gian
                if (progress >= 0.6 && currentPosition >= winnerPosition) {
                    // Dừng lại ở người trúng
                    isStopped = true;
                    if (spinInterval) clearTimeout(spinInterval);
                    stopOnWinner(slotReel, winnerPosition, winnerData);
                    return;
                }
                
                // Tiếp tục quay nếu chưa hết thời gian
                if (progress >= 1) {
                    // Fallback: dừng sau thời gian quy định
                    isStopped = true;
                    if (spinInterval) clearTimeout(spinInterval);
                    stopOnWinner(slotReel, winnerPosition, winnerData);
                } else {
                    // Tiếp tục animation với tốc độ hiện tại
                    if (spinInterval) clearTimeout(spinInterval);
                    spinInterval = setTimeout(animate, currentSpeed);
                }
            }
            
            // Bắt đầu animation
            startTime = Date.now();
            spinInterval = setTimeout(animate, spinSpeed);
        }
        
        function stopOnWinner(slotReel, winnerIndex, winnerData) {
            console.log('Dừng ở người trúng:', winnerData.name, 'Score:', winnerData.score);
            const offset = -winnerIndex * 107; // Sử dụng height 107px thay vì 100px
            
            // Smooth scroll đến vị trí người trúng
            slotReel.style.transition = 'transform 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94)';
            slotReel.style.transform = 'translateY(' + offset + 'px)';
            
            // Đợi scroll hoàn tất rồi mới highlight
            setTimeout(function() {
                // Tìm và highlight item trúng - so sánh cả name và score để đảm bảo đúng
                const items = slotReel.querySelectorAll('.slot-item');
                let foundWinnerItem = null;
                
                items.forEach(function(item, index) {
                    item.classList.remove('highlight');
                    // Lấy text content và so sánh với winnerData
                    const itemText = item.textContent.trim();
                    const expectedText = winnerData.name + ' (' + winnerData.score + ' điểm)';
                    
                    // So sánh chính xác
                    if (itemText === expectedText && index === winnerIndex) {
                        foundWinnerItem = item;
                        item.classList.add('highlight');
                        console.log('Đã highlight item:', itemText, 'tại index:', index);
                    }
                });
                
                // Nếu không tìm thấy bằng text, dùng index như fallback
                if (!foundWinnerItem && items[winnerIndex]) {
                    items[winnerIndex].classList.add('highlight');
                    console.log('Highlight bằng index fallback:', winnerIndex);
                }
                
                // Thêm người trúng vào bảng sau khi highlight
                addWinnerToBoard(winnerData);
            }, 900); // Đợi scroll animation hoàn tất (800ms + 100ms buffer)
        }
        
        function togglePanel() {
            var panel = document.getElementById('topWinnersPanel');
            var btn = document.getElementById('togglePanelBtn');
            if (panel && btn) {
                panel.classList.toggle('collapsed');
                if (panel.classList.contains('collapsed')) {
                    btn.textContent = '▶ Hiện Bảng Xếp Hạng';
                } else {
                    btn.textContent = '▼ Ẩn Bảng Xếp Hạng';
                }
            }
        }
        
        function addWinnerToBoard(winnerData) {
            console.log('Thêm người trúng vào bảng:', winnerData.name, 'Score:', winnerData.score);
            
            var topWinnersList = document.querySelector('.top-winners-list');
            if (!topWinnersList) {
                console.error('Không tìm thấy top-winners-list!');
                return;
            }
            
            // Tìm vị trí trống đầu tiên (slot có rank thấp nhất)
            var emptySlots = topWinnersList.querySelectorAll('.empty-slot');
            if (emptySlots.length === 0) {
                console.log('Không còn vị trí trống!');
                return; // Không còn vị trí trống
            }
            
            var firstEmptySlot = emptySlots[0];
            var rank = parseInt(firstEmptySlot.getAttribute('data-rank'));
            
            console.log('Thêm vào rank:', rank);
            
            // Tạo element mới cho người trúng
            var winnerItem = document.createElement('div');
            winnerItem.className = 'winner-item' + (rank === 1 ? ' top1' : '');
            winnerItem.setAttribute('data-rank', rank);
            winnerItem.setAttribute('data-winner-name', winnerData.name);
            winnerItem.setAttribute('data-winner-score', winnerData.score);
            
            var rankHTML = '';
            if (rank === 1) rankHTML = '🥇';
            else if (rank === 2) rankHTML = '🥈';
            else if (rank === 3) rankHTML = '🥉';
            else rankHTML = '#' + rank;
            
            // Escape HTML để tránh XSS
            var safeName = winnerData.name.replace(/</g, '&lt;').replace(/>/g, '&gt;');
            
            winnerItem.innerHTML = 
                '<div class="winner-rank">' + rankHTML + '</div>' +
                '<div class="winner-info">' +
                    '<div class="winner-info-name">' + safeName + '</div>' +
                    '<div class="winner-info-score">Điểm: ' + winnerData.score + '</div>' +
                '</div>';
            
            // Thay thế slot trống bằng người trúng với animation
            winnerItem.style.opacity = '0';
            winnerItem.style.transform = 'translateY(-20px)';
            firstEmptySlot.parentNode.replaceChild(winnerItem, firstEmptySlot);
            
            // Animation fade in
            setTimeout(function() {
                winnerItem.style.transition = 'all 0.5s ease';
                winnerItem.style.opacity = '1';
                winnerItem.style.transform = 'translateY(0)';
                
                // Verify sau khi thêm
                var verifyName = winnerItem.getAttribute('data-winner-name');
                var verifyScore = winnerItem.getAttribute('data-winner-score');
                console.log('Đã thêm vào bảng - Name:', verifyName, 'Score:', verifyScore);
            }, 10);
            
            // Cập nhật progress indicator
            var progressIndicator = document.querySelector('.progress-indicator');
            if (progressIndicator) {
                var currentText = progressIndicator.textContent;
                var match = currentText.match(/(\d+)\/5/);
                if (match) {
                    var current = parseInt(match[1]) + 1;
                    progressIndicator.textContent = 'Đã quay: ' + current + '/5';
                } else {
                    progressIndicator.textContent = 'Đã quay: 1/5';
                }
            } else {
                // Tạo progress indicator nếu chưa có
                var panel = document.querySelector('.top-winners-panel');
                if (panel) {
                    var newIndicator = document.createElement('div');
                    newIndicator.className = 'progress-indicator';
                    newIndicator.textContent = 'Đã quay: 1/5';
                    var resetForm = panel.querySelector('form');
                    if (resetForm) {
                        panel.insertBefore(newIndicator, resetForm);
                    } else {
                        panel.appendChild(newIndicator);
                    }
                }
            }
        }
    </script>
</body>
</html>
