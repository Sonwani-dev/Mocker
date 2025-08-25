<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="userId" content="${userId}">
    <title>MockTestPro - Test</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/test-demo.css">
    <script src="${pageContext.request.contextPath}/resources/js/theme.js"></script>
    <style>
        .modal { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; }
        .modal.show { display: flex; }
        .modal .modal-content { background: #fff; width: min(720px, 92%); max-height: 80vh; overflow: auto; border-radius: 12px; padding: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.25); }
        .modal .modal-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 16px; }
        .btn-primary { background: #007aff; color: #fff; border: 0; padding: 10px 16px; border-radius: 8px; cursor: pointer; }
        .btn-primary:hover { background: #0062cc; }
        pre { margin: 0; font-family: inherit; }
    </style>
    <script>
        // Server-provided test metadata
        window.TEST_DATA = {
            mockTestId: ${mockTestId},
            durationMinutes: ${durationMinutes},
            numberOfQuestions: ${numberOfQuestions}
        };
    </script>
</head>
<body data-ctx="${pageContext.request.contextPath}">
    <div class="floating-elements">
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
    </div>

    <jsp:include page="navbar.jsp" />

    <main class="test-page">
        <!-- Rules Modal -->
        <div id="rulesModal" class="modal">
            <div class="modal-content">
                <h2>Test Rules</h2>
                <pre style="white-space: pre-wrap;">${rulesText}</pre>
                <div class="modal-actions">
                    <button id="continueToTheory" class="btn-primary">Continue</button>
                </div>
            </div>
        </div>

        <!-- Theory Modal -->
        <div id="theoryModal" class="modal">
            <div class="modal-content">
                <h2>Test Theory</h2>
                <pre style="white-space: pre-wrap; max-height: 50vh; overflow: auto;">${theoryText}</pre>
                <div class="modal-actions">
                    <button id="startTestBtn" class="btn-primary">Start Test</button>
                </div>
            </div>
        </div>
        <div class="test-container">
            <div class="test-header">
                <div class="breadcrumbs">
                    <a href="${pageContext.request.contextPath}/topic/${topicId}/mocktests" class="back-link">← Back to Tests</a>
                </div>
                <div class="test-meta" 
                    data-mocktest-id="${mockTestId}" 
                    data-topic-id="${topicId}"
                    data-duration-minutes="${durationMinutes}"
                    data-total-questions="${numberOfQuestions}">
                    <div class="meta-item">
                        <span class="meta-label">Time Left:</span>
                        <span id="timer" class="meta-value">--:--</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Question:</span>
                        <span id="qProgress" class="meta-value">1 / ${numberOfQuestions}</span>
                    </div>
                </div>
            </div>

            <div class="question-card" id="questionCard">
                <div class="question-header">
                    <div id="questionNumber" class="q-number">Q1</div>
                    <div class="progress-bar"><div id="progressFill"></div></div>
                </div>
                <h2 class="question-text"><span class="topic-title">${topicName}</span> · <span class="test-title">Mock Test ${testNumber}</span></h2>
                <div id="questionText" class="question-text"></div>
                <div id="optionsContainer" class="options"></div>
                <div id="explanation" class="explanation" style="display:none;"></div>
                <div class="question-actions">
                    <button id="skipBtn" class="btn-secondary">Skip</button>
                    <button id="nextBtn" class="btn-primary">Next →</button>
                </div>
            </div>
        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const rulesModal = document.getElementById('rulesModal');
            const theoryModal = document.getElementById('theoryModal');
            const continueBtn = document.getElementById('continueToTheory');
            const startBtn = document.getElementById('startTestBtn');
            const questionCard = document.getElementById('questionCard');
            const meta = document.querySelector('.test-meta');
            const mockTestId = meta ? meta.getAttribute('data-mocktest-id') : null;
            const startedKey = mockTestId ? `mtp_started_${mockTestId}` : null;
            
            // Initially hide question card until user passes both modals
            if (questionCard) questionCard.style.display = 'none';
            
            // If test was already started (reload), skip modals and resume immediately
            try {
                if (startedKey && sessionStorage.getItem(startedKey) === '1') {
                    rulesModal.style.display = 'none';
                    theoryModal.style.display = 'none';
                    if (questionCard) questionCard.style.display = 'block';
                    if (window.startTest) window.startTest();
                    return;
                }
            } catch (e) { /* ignore */ }
            
            // Show rules modal initially
            rulesModal.style.display = 'flex';
            
            continueBtn.addEventListener('click', function() {
                rulesModal.style.display = 'none';
                theoryModal.style.display = 'flex';
            });
            
            startBtn.addEventListener('click', function() {
                theoryModal.style.display = 'none';
                if (questionCard) questionCard.style.display = 'block';
                try { if (startedKey) sessionStorage.setItem(startedKey, '1'); } catch (e) {}
                if (window.startTest) window.startTest();
            });
        });
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/test-demo.js"></script>
</body>
</html>


