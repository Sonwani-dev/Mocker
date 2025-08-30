<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Test - ${mockTest.name}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <style>
        .test-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .test-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .info-item {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 10px;
            text-align: center;
        }
        
        .info-label {
            font-size: 12px;
            opacity: 0.8;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .info-value {
            font-size: 18px;
            font-weight: bold;
            margin-top: 5px;
        }
        
        .question-container {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-left: 5px solid #667eea;
        }
        
        .question-number {
            background: #667eea;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-bottom: 15px;
        }
        
        .question-text {
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 20px;
            line-height: 1.6;
        }
        
        .options-container {
            display: grid;
            gap: 10px;
        }
        
        .option {
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }
        
        .option.correct {
            background: #d4edda;
            border-color: #28a745;
            color: #155724;
        }
        
        .option-label {
            background: #667eea;
            color: white;
            width: 25px;
            height: 25px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 12px;
            margin-right: 12px;
        }
        
        .option.correct .option-label {
            background: #28a745;
        }
        
        .explanation {
            background: #f8f9fa;
            border-left: 4px solid #17a2b8;
            padding: 15px;
            margin-top: 15px;
            border-radius: 0 8px 8px 0;
        }
        
        .explanation-title {
            font-weight: bold;
            color: #17a2b8;
            margin-bottom: 8px;
        }
        
        .back-button {
            background: #6c757d;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 20px;
            transition: background 0.3s ease;
        }
        
        .back-button:hover {
            background: #5a6268;
            color: white;
            text-decoration: none;
        }
        
        .theory-container {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-left: 5px solid #17a2b8;
        }
        
        .theory-container h3 {
            color: #17a2b8;
            margin-bottom: 15px;
            font-size: 18px;
        }
        
        .theory-content {
            line-height: 1.6;
            color: #333;
            white-space: pre-wrap;
            font-size: 14px;
        }
        
        .no-questions {
            text-align: center;
            padding: 50px;
            color: #6c757d;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="floating-elements">
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
    </div>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-button">← Back to Dashboard</a>
        
        <div class="test-header">
            <h1>${mockTest.name}</h1>
            <p>${mockTest.description}</p>
            
            <div class="test-info">
                <div class="info-item">
                    <div class="info-label">Topic</div>
                    <div class="info-value">${mockTest.topic.name}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Test Number</div>
                    <div class="info-value">${mockTest.testNumber}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Questions</div>
                    <div class="info-value">${mockTest.numberOfQuestions}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Duration</div>
                    <div class="info-value">${mockTest.durationMinutes} min</div>
                </div>
            </div>
        </div>
        
        <!-- Test Theory Section -->
        <c:if test="${not empty mockTest.theoryText}">
            <div class="theory-container">
                <h3>Test Theory</h3>
                <div class="theory-content">
                    ${mockTest.theoryText}
                </div>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty questionsWithAnswers}">
                <div class="no-questions">
                    <h3>No questions found for this test.</h3>
                    <p>This test might not have any questions uploaded yet.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="qa" items="${questionsWithAnswers}" varStatus="status">
                    <div class="question-container">
                        <div class="question-number">${status.index + 1}</div>
                        <div class="question-text">${qa.question.text}</div>
                        
                        <div class="options-container">
                            <c:forEach var="option" items="${qa.answerOptions}">
                                <div class="option ${option.isCorrect ? 'correct' : ''}">
                                    <div class="option-label">
                                        <c:choose>
                                            <c:when test="${option.orderIndex == 1}">A</c:when>
                                            <c:when test="${option.orderIndex == 2}">B</c:when>
                                            <c:when test="${option.orderIndex == 3}">C</c:when>
                                            <c:when test="${option.orderIndex == 4}">D</c:when>
                                        </c:choose>
                                    </div>
                                    <div class="option-text">${option.text}</div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <c:if test="${not empty qa.question.explanation}">
                            <div class="explanation">
                                <div class="explanation-title">Explanation:</div>
                                <div>${qa.question.explanation}</div>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
