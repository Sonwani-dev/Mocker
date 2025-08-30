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
        .analysis-card { max-width: 1000px; margin: 0 auto; background: #fff; border: 1px solid rgba(0,0,0,0.06); border-radius: 24px; box-shadow: 0 24px 80px rgba(0,0,0,0.12); padding: 28px; }
        .analysis-stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-top: 16px; }
        .stat { background: #f8f9fa; border-radius: 16px; padding: 16px; text-align: center; }
        .stat .label { color: #6c757d; font-weight: 600; font-size: 13px; }
        .stat .value { font-weight: 800; font-size: 22px; margin-top: 6px; }
        .cta { margin-top: 20px; display: flex; gap: 10px; justify-content: flex-end; }
        .btn { padding: 12px 18px; border-radius: 14px; border: none; cursor: pointer; font-weight: 700; }
        .btn-primary { background: linear-gradient(135deg, var(--primary, #007AFF), var(--secondary, #5856D6)); color: #fff; }
        .btn-secondary { background: #f1f3f5; }
        
        .detailed-results { margin-top: 32px; }
        .question-review { 
            background: #f8f9fa; 
            border-radius: 16px; 
            padding: 24px; 
            margin-bottom: 16px; 
            border-left: 4px solid #dee2e6; 
        }
        .question-review.correct { border-left-color: #28a745; }
        .question-review.incorrect { border-left-color: #dc3545; }
        .question-review.skipped { border-left-color: #6c757d; }
        
        .question-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 16px; 
        }
        .question-number { 
            font-weight: 700; 
            color: #495057; 
            font-size: 18px; 
        }
        .question-status { 
            padding: 6px 16px; 
            border-radius: 20px; 
            font-size: 12px; 
            font-weight: 600; 
            text-transform: uppercase; 
        }
        .status-correct { background: #d4edda; color: #155724; }
        .status-incorrect { background: #f8d7da; color: #721c24; }
        .status-skipped { background: #e2e3e5; color: #383d41; }
        
        .question-text { 
            font-size: 18px; 
            line-height: 1.6; 
            margin-bottom: 20px; 
            color: #212529; 
            font-weight: 500;
        }
        
        .options-list { margin-bottom: 20px; }
        .option-item { 
            padding: 16px 20px; 
            margin-bottom: 12px; 
            border-radius: 12px; 
            border: 2px solid #e9ecef; 
            background: #fff; 
            position: relative; 
            transition: all 0.2s ease;
        }
        .option-item.selected { border-color: #007bff; background: #e3f2fd; }
        .option-item.correct { border-color: #28a745; background: #d4edda; }
        .option-item.incorrect { border-color: #dc3545; background: #f8d7da; }
        
        .option-text { font-size: 16px; color: #495057; }
        
        .explanation { 
            background: #fff3cd; 
            border: 1px solid #ffeaa7; 
            border-radius: 12px; 
            padding: 20px; 
            margin-top: 20px; 
        }
        .explanation-title { 
            font-weight: 700; 
            color: #856404; 
            margin-bottom: 12px; 
            font-size: 16px; 
        }
        .explanation-text { 
            color: #856404; 
            line-height: 1.6; 
            font-size: 15px; 
        }
        
        .no-explanation { 
            color: #6c757d; 
            font-style: italic; 
            font-size: 15px; 
            margin-top: 20px; 
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            text-align: center;
        }
        
        .question-actions { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-top: 24px; 
        }
        
        .question-navigation { 
            display: flex; 
            gap: 12px; 
            align-items: center; 
        }
        
        .question-counter { 
            color: #6c757d; 
            font-size: 14px; 
            font-weight: 600; 
        }
        
        .btn-nav { 
            padding: 10px 16px; 
            border-radius: 10px; 
            border: none; 
            cursor: pointer; 
            font-weight: 600; 
            font-size: 14px; 
            transition: all 0.2s ease;
        }
        .btn-nav:disabled { 
            opacity: 0.5; 
            cursor: not-allowed; 
        }
        .btn-nav:not(:disabled):hover { 
            transform: translateY(-1px); 
            box-shadow: 0 4px 12px rgba(0,0,0,0.15); 
        }
        
        .btn-prev { background: #6c757d; color: #fff; }
        .btn-next { background: #007bff; color: #fff; }
        
        .hidden { display: none; }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <main class="analysis-page">
        <div class="analysis-card">
            <h2>Test Analysis</h2>
            
            <!-- Summary Statistics -->
            <div class="analysis-stats">
                <div class="stat"><div class="label">Total</div><div id="statTotal" class="value">0</div></div>
                <div class="stat"><div class="label">Correct</div><div id="statCorrect" class="value">0</div></div>
                <div class="stat"><div class="label">Incorrect</div><div id="statIncorrect" class="value">0</div></div>
                <div class="stat"><div class="label">Unanswered</div><div id="statUnanswered" class="value">0</div></div>
            </div>
            <div class="analysis-stats" style="grid-template-columns: 1fr;">
                <div class="stat"><div class="label">Overall %</div><div id="statPercent" class="value">0%</div></div>
            </div>
            
            <!-- Question Review Section -->
            <div class="detailed-results">
                <h3>Question Review</h3>
                <div id="questionReview" class="hidden">
                    <div id="currentQuestion" class="question-review">
                        <!-- Question content will be populated here -->
                    </div>
                    <div class="question-actions">
                        <div class="question-navigation">
                            <button id="prevBtn" class="btn-nav btn-prev">← Previous</button>
                            <span class="question-counter" id="questionCounter">Question 1 of 1</span>
                            <button id="nextBtn" class="btn-nav btn-next">Next →</button>
                        </div>
                    </div>
                </div>
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
            const mockTestId = params.get('mockTestId') || '0';
            
            document.getElementById('statTotal').textContent = total;
            document.getElementById('statCorrect').textContent = correct;
            document.getElementById('statIncorrect').textContent = incorrect;
            document.getElementById('statUnanswered').textContent = unanswered;
            document.getElementById('statPercent').textContent = percent + '%';
            
            // Load detailed analysis data from sessionStorage
            let analysisData = null;
            try {
                const storedData = sessionStorage.getItem('mtp_analysis_' + mockTestId);
                if (storedData) {
                    analysisData = JSON.parse(storedData);
                    if (analysisData.questions && analysisData.answers) {
                        showQuestionReview();
                    }
                }
            } catch (e) {
                console.warn('Failed to load detailed analysis data:', e);
            }
            
            let currentQuestionIndex = 0;
            
            function showQuestionReview() {
                if (!analysisData || !analysisData.questions) return;
                
                document.getElementById('questionReview').classList.remove('hidden');
                displayQuestion(currentQuestionIndex);
                updateNavigationButtons();
            }
            
            function displayQuestion(index) {
                if (!analysisData || !analysisData.questions || index < 0 || index >= analysisData.questions.length) return;
                
                const question = analysisData.questions[index];
                const answer = analysisData.answers[index] || {};
                const container = document.getElementById('currentQuestion');
                
                let statusClass = 'skipped';
                let statusText = 'Skipped';
                let statusColor = 'status-skipped';
                
                if (answer.selectedOptionId !== null) {
                    if (answer.correct) {
                        statusClass = 'correct';
                        statusText = 'Correct';
                        statusColor = 'status-correct';
                    } else {
                        statusClass = 'incorrect';
                        statusText = 'Incorrect';
                        statusColor = 'status-incorrect';
                    }
                }
                
                container.className = 'question-review ' + statusClass;
                
                // Build options HTML
                let optionsHtml = '';
                if (question.options && Array.isArray(question.options)) {
                    question.options.forEach(function(option) {
                        let optionClass = 'option-item';
                        if (option.optionId === answer.selectedOptionId) {
                            optionClass += ' selected';
                        }
                        if (option.optionId === answer.correctOptionId) {
                            optionClass += ' correct';
                        } else if (option.optionId === answer.selectedOptionId && !answer.correct) {
                            optionClass += ' incorrect';
                        }
                        
                        optionsHtml += '<div class="' + optionClass + '">';
                        optionsHtml += '<div class="option-text">' + (option.text || '') + '</div>';
                        optionsHtml += '</div>';
                    });
                }
                
                // Build explanation HTML
                let explanationHtml = '';
                if (answer.explanation) {
                    explanationHtml += '<div class="explanation">';
                    explanationHtml += '<div class="explanation-title">Explanation:</div>';
                    explanationHtml += '<div class="explanation-text">' + answer.explanation + '</div>';
                    explanationHtml += '</div>';
                } else {
                    explanationHtml += '<div class="no-explanation">No explanation available for this question.</div>';
                }
                
                const questionHtml = 
                    '<div class="question-header">' +
                        '<div class="question-number">Question ' + (index + 1) + '</div>' +
                        '<div class="question-status ' + statusColor + '">' + statusText + '</div>' +
                    '</div>' +
                    '<div class="question-text">' + (question.text || '') + '</div>' +
                    '<div class="options-list">' + optionsHtml + '</div>' +
                    explanationHtml;
                
                container.innerHTML = questionHtml;
                updateQuestionCounter();
            }
            
            function updateQuestionCounter() {
                const counter = document.getElementById('questionCounter');
                if (analysisData && analysisData.questions) {
                    counter.textContent = 'Question ' + (currentQuestionIndex + 1) + ' of ' + analysisData.questions.length;
                }
            }
            
            function updateNavigationButtons() {
                const prevBtn = document.getElementById('prevBtn');
                const nextBtn = document.getElementById('nextBtn');
                
                if (prevBtn && nextBtn && analysisData && analysisData.questions) {
                    prevBtn.disabled = currentQuestionIndex === 0;
                    nextBtn.disabled = currentQuestionIndex === analysisData.questions.length - 1;
                }
            }
            
            function goToNextQuestion() {
                if (analysisData && analysisData.questions && currentQuestionIndex < analysisData.questions.length - 1) {
                    currentQuestionIndex++;
                    displayQuestion(currentQuestionIndex);
                    updateNavigationButtons();
                }
            }
            
            function goToPreviousQuestion() {
                if (currentQuestionIndex > 0) {
                    currentQuestionIndex--;
                    displayQuestion(currentQuestionIndex);
                    updateNavigationButtons();
                }
            }
            
            // Event listeners for navigation
            document.addEventListener('DOMContentLoaded', function() {
                const nextBtn = document.getElementById('nextBtn');
                const prevBtn = document.getElementById('prevBtn');
                
                if (nextBtn) {
                    nextBtn.addEventListener('click', goToNextQuestion);
                }
                if (prevBtn) {
                    prevBtn.addEventListener('click', goToPreviousQuestion);
                }
            });
        })();
    </script>
</body>
</html>


