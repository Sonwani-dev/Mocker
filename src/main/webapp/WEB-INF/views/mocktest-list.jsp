<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mock Tests for ${topic.name}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pe-dashboard.css">
    <style>
        body {
            background: linear-gradient(120deg, #e3f0ff 0%, #f7faff 100%);
        }
        .mocktest-page-container {
            max-width: 1200px;
            margin: 48px auto;
            padding: 40px 32px 48px;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0,40,120,0.10);
            min-height: 70vh;
        }
        .mocktest-header {
            text-align: center;
            margin-bottom: 32px;
        }
        .mocktest-header h1 {
            font-size: 2.2em;
            font-weight: 700;
            color: #1a237e;
            margin-bottom: 8px;
            letter-spacing: 1px;
        }
        .mocktest-cards {
            display: flex;
            flex-wrap: wrap;
            gap: 32px;
            justify-content: center;
            margin-top: 16px;
        }
        .mocktest-card {
            background: linear-gradient(120deg, #f7faff 60%, #e3f0ff 100%);
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,40,120,0.07);
            padding: 48px 24px 24px 24px; /* top padding increased */
            width: 320px;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            position: relative;
            transition: box-shadow 0.2s, transform 0.2s;
            border: 1.5px solid #e3eafc;
        }
        .mocktest-card:hover {
            box-shadow: 0 8px 32px rgba(25, 118, 210, 0.13);
            transform: translateY(-4px) scale(1.025);
            border-color: #90caf9;
        }
        .mocktest-badge {
            position: absolute;
            top: 18px;
            right: 18px;
            background: #1976d2;
            color: #fff;
            font-size: 0.85em;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 12px;
            letter-spacing: 0.5px;
            box-shadow: 0 1px 4px rgba(25, 118, 210, 0.08);
        }
        .mocktest-title {
            font-size: 1.18em;
            font-weight: 700;
            color: #1a237e;
            margin-bottom: 10px;
            letter-spacing: 0.5px;
            padding-right: 60px;
            word-wrap: break-word;
            word-break: break-word;
            overflow-wrap: break-word;
            max-width: 100%;
        }
        .mocktest-desc {
            font-size: 1em;
            color: #374151;
            margin-bottom: 18px;
            min-height: 48px;
        }
        .mocktest-status {
            margin-top: auto;
            width: 100%;
            display: flex;
            justify-content: flex-end;
        }
        .btn-start {
            background: linear-gradient(90deg, #1976d2 60%, #42a5f5 100%);
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 9px 26px;
            font-size: 1.08em;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, box-shadow 0.2s;
            text-decoration: none;
            box-shadow: 0 2px 8px rgba(25, 118, 210, 0.08);
        }
        .btn-start:hover {
            background: linear-gradient(90deg, #1565c0 60%, #1976d2 100%);
            box-shadow: 0 4px 16px rgba(25, 118, 210, 0.13);
        }
        .mocktest-locked {
            color: #b0b8c9;
            font-weight: 600;
            font-size: 1.05em;
        }
        .mocktest-attempted {
            color: #43a047;
            font-weight: 600;
            font-size: 1.05em;
        }
        .back-to-topics-btn {
            display: inline-block;
            margin: 0 auto;
            background: linear-gradient(90deg, #00897B 0%, #26A69A 100%);
            color: #fff;
            border: none;
            border-radius: 22px;
            padding: 9px 28px;
            font-size: 1.08em;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(0, 150, 136, 0.15);
            text-decoration: none;
            transition: background 0.2s, box-shadow 0.2s;
            outline: none;
        }
        .back-to-topics-btn:hover,
        .back-to-topics-btn:focus {
            background: linear-gradient(90deg, #00695C 0%, #00897B 100%);
            box-shadow: 0 4px 16px rgba(0, 150, 136, 0.25);
            text-decoration: none;
        }
        @media (max-width: 900px) {
            .mocktest-page-container {
                padding: 10px 2vw 20px;
            }
            .mocktest-cards {
                gap: 16px;
            }
            .mocktest-card {
                width: 95vw;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="mocktest-page-container">
        <div class="mocktest-header">
            <h1>Mock Tests for ${topic.name}</h1>
            <a href="${pageContext.request.contextPath}/pe-subjects" class="back-to-topics-btn">&larr; Back to Topics</a>
        </div>
        <div class="mocktest-cards">
            <c:forEach var="mockTest" items="${mockTests}">
                <div class="mocktest-card">
                    <span class="mocktest-badge">${mockTest.testNumber}</span>
                    <div class="mocktest-title">
                        ${mockTest.name}
                    </div>
                    <div class="mocktest-desc">
                        <c:choose>
                            <c:when test="${not empty mockTest.description}">
                                ${mockTest.description}
                            </c:when>
                            <c:otherwise>
                                Practice questions for this topic.
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="mocktest-status">
                        <c:choose>
                            <c:when test="${mockTest.attempted}">
                                <c:choose>
                                    <c:when test="${!hasPaid}">
                                        <a href="${pageContext.request.contextPath}/pricing" class="btn-start" style="background: linear-gradient(90deg, #1976d2 60%, #42a5f5 100%);">Upgrade</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="mocktest-attempted">Attempted</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:when test="${mockTest.unlocked && !mockTest.attempted}">
                                <a href="${pageContext.request.contextPath}/mocktest/start/${mockTest.id}" class="btn-start">Start</a>
                            </c:when>
                            <c:otherwise>
                                <span class="mocktest-locked">Locked</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>
