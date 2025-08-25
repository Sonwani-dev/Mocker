<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Analysis</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <style>
        .analysis-page { padding: 140px 24px 60px; }
        .analysis-card { max-width: 800px; margin: 0 auto; background: #fff; border: 1px solid rgba(0,0,0,0.06); border-radius: 24px; box-shadow: 0 24px 80px rgba(0,0,0,0.12); padding: 28px; }
        .analysis-stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-top: 16px; }
        .stat { background: #f8f9fa; border-radius: 16px; padding: 16px; text-align: center; }
        .stat .label { color: #6c757d; font-weight: 600; font-size: 13px; }
        .stat .value { font-weight: 800; font-size: 22px; margin-top: 6px; }
        .cta { margin-top: 20px; display: flex; gap: 10px; justify-content: flex-end; }
        .btn { padding: 12px 18px; border-radius: 14px; border: none; cursor: pointer; font-weight: 700; }
        .btn-primary { background: linear-gradient(135deg, var(--primary, #007AFF), var(--secondary, #5856D6)); color: #fff; }
        .btn-secondary { background: #f1f3f5; }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <main class="analysis-page">
        <div class="analysis-card">
            <h2>Test Analysis</h2>
            <div class="analysis-stats">
                <div class="stat"><div class="label">Total</div><div id="statTotal" class="value">0</div></div>
                <div class="stat"><div class="label">Correct</div><div id="statCorrect" class="value">0</div></div>
                <div class="stat"><div class="label">Incorrect</div><div id="statIncorrect" class="value">0</div></div>
                <div class="stat"><div class="label">Unanswered</div><div id="statUnanswered" class="value">0</div></div>
            </div>
            <div class="analysis-stats" style="grid-template-columns: 1fr;">
                <div class="stat"><div class="label">Overall %</div><div id="statPercent" class="value">0%</div></div>
            </div>
            <div class="cta">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/topic/${param.topicId}/mocktests">← Back to Tests</a>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/mocktest/start/${param.mockTestId}">Retake Test</a>
            </div>
        </div>
    </main>
    <script>
        (function() {
            const params = new URLSearchParams(window.location.search);
            const total = params.get('total') || '0';
            const correct = params.get('correct') || '0';
            const incorrect = params.get('incorrect') || '0';
            const unanswered = params.get('unanswered') || '0';
            const percent = params.get('percent') || '0';
            document.getElementById('statTotal').textContent = total;
            document.getElementById('statCorrect').textContent = correct;
            document.getElementById('statIncorrect').textContent = incorrect;
            document.getElementById('statUnanswered').textContent = unanswered;
            document.getElementById('statPercent').textContent = percent + '%';
        })();
    </script>
</body>
</html>


