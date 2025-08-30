<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leaderboard - MockTestPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }
        
        .leaderboard-page {
            padding: 140px 24px 60px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .leaderboard-header {
            text-align: center;
            margin-bottom: 40px;
            color: white;
        }
        
        .leaderboard-title {
            font-size: 3rem;
            font-weight: 800;
            margin-bottom: 16px;
            text-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }
        
        .leaderboard-subtitle {
            font-size: 1.2rem;
            font-weight: 400;
            opacity: 0.9;
        }
        
        .leaderboard-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            padding: 32px;
            margin-bottom: 32px;
        }
        
        .filters-section {
            display: flex;
            gap: 16px;
            margin-bottom: 32px;
            flex-wrap: wrap;
            justify-content: center;
        }
        
        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .filter-label {
            font-weight: 600;
            color: #555;
            font-size: 14px;
        }
        
        .filter-select {
            padding: 12px 16px;
            border: 2px solid #e1e5e9;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 500;
            background: white;
            color: #333;
            cursor: pointer;
            transition: all 0.2s ease;
            min-width: 180px;
        }
        
        .filter-select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .leaderboard-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 24px;
        }
        
        .leaderboard-table th {
            background: #f8f9fa;
            padding: 20px 16px;
            text-align: left;
            font-weight: 700;
            font-size: 14px;
            color: #555;
            border-bottom: 2px solid #e9ecef;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .leaderboard-table td {
            padding: 20px 16px;
            border-bottom: 1px solid #f1f3f4;
            font-size: 15px;
            vertical-align: middle;
        }
        
        .leaderboard-table tbody tr {
            transition: all 0.2s ease;
        }
        
        .leaderboard-table tbody tr:hover {
            background: #f8f9fa;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        
        .rank-cell {
            text-align: center;
            font-weight: 800;
            font-size: 1.5rem;
            width: 80px;
        }
        
        .rank-1 {
            color: #ffd700;
            text-shadow: 0 2px 8px rgba(255, 215, 0, 0.3);
        }
        
        .rank-2 {
            color: #c0c0c0;
            text-shadow: 0 2px 8px rgba(192, 192, 192, 0.3);
        }
        
        .rank-3 {
            color: #cd7f32;
            text-shadow: 0 2px 8px rgba(205, 127, 50, 0.3);
        }
        
        .user-name {
            font-weight: 600;
            color: #333;
        }
        
        .score-cell {
            text-align: center;
            font-weight: 700;
        }
        
        .score-90 { color: #28a745; }
        .score-80 { color: #17a2b8; }
        .score-70 { color: #ffc107; }
        .score-60 { color: #fd7e14; }
        .score-below { color: #dc3545; }
        
        .stats-cell {
            text-align: center;
            color: #666;
            font-weight: 500;
        }
        
        .time-cell {
            text-align: center;
            color: #666;
            font-weight: 500;
        }
        
        .loading {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        
        .loading-spinner {
            width: 40px;
            height: 40px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        
        .no-data-icon {
            font-size: 3rem;
            margin-bottom: 16px;
            opacity: 0.5;
        }
        
        .refresh-btn {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-top: 20px;
        }
        
        .refresh-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        
        .stats-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 32px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 24px;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.2);
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 8px;
        }
        
        .stat-label {
            font-size: 14px;
            opacity: 0.9;
            font-weight: 500;
        }
        
        @media (max-width: 768px) {
            .leaderboard-page {
                padding: 120px 16px 40px;
            }
            
            .leaderboard-title {
                font-size: 2rem;
            }
            
            .leaderboard-card {
                padding: 20px;
            }
            
            .filters-section {
                flex-direction: column;
                align-items: center;
            }
            
            .filter-select {
                min-width: 100%;
                max-width: 300px;
            }
            
            .leaderboard-table {
                font-size: 14px;
            }
            
            .leaderboard-table th,
            .leaderboard-table td {
                padding: 12px 8px;
            }
            
            .rank-cell {
                width: 60px;
                font-size: 1.2rem;
            }
            
            .stats-summary {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    
    <main class="leaderboard-page">
        <div class="leaderboard-header">
            <h1 class="leaderboard-title">🏆 Leaderboard</h1>
            <p class="leaderboard-subtitle">Compete with the best performers across all tests</p>
        </div>
        
        <div class="leaderboard-card">
            <!-- Filters Section -->
            <div class="filters-section">
                <div class="filter-group">
                    <label class="filter-label">View By</label>
                    <select id="viewFilter" class="filter-select">
                        <option value="overall">Overall Performance</option>
                        <option value="topic">By Topic</option>
                        <option value="test">By Test</option>
                    </select>
                </div>
                
                <div class="filter-group" id="topicFilterGroup" style="display: none;">
                    <label class="filter-label">Select Topic</label>
                    <select id="topicFilter" class="filter-select">
                        <option value="">Loading topics...</option>
                    </select>
                </div>
                
                <div class="filter-group" id="testFilterGroup" style="display: none;">
                    <label class="filter-label">Select Test</label>
                    <select id="testFilter" class="filter-select">
                        <option value="">Loading tests...</option>
                    </select>
                </div>
            </div>
            
            <!-- Stats Summary -->
            <div class="stats-summary">
                <div class="stat-card">
                    <div class="stat-value" id="totalUsers">-</div>
                    <div class="stat-label">Total Participants</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="avgScore">-</div>
                    <div class="stat-label">Average Score</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="topScore">-</div>
                    <div class="stat-label">Top Score</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="totalTests">-</div>
                    <div class="stat-label">Tests Taken</div>
                </div>
            </div>
            
            <!-- Leaderboard Table -->
            <div id="leaderboardContent">
                <div class="loading">
                    <div class="loading-spinner"></div>
                    <p>Loading leaderboard data...</p>
                </div>
            </div>
        </div>
    </main>
    
    <script>
        (function() {
            let currentFilter = 'overall';
            let currentTopicId = null;
            let currentTestId = null;
            
            // DOM elements
            const viewFilter = document.getElementById('viewFilter');
            const topicFilterGroup = document.getElementById('topicFilterGroup');
            const testFilterGroup = document.getElementById('testFilterGroup');
            const topicFilter = document.getElementById('topicFilter');
            const testFilter = document.getElementById('testFilter');
            const leaderboardContent = document.getElementById('leaderboardContent');
            
            // Initialize
            document.addEventListener('DOMContentLoaded', function() {
                setupEventListeners();
                loadLeaderboard();
            });
            
            function setupEventListeners() {
                viewFilter.addEventListener('change', function() {
                    currentFilter = this.value;
                    updateFilterVisibility();
                    loadLeaderboard();
                });
                
                topicFilter.addEventListener('change', function() {
                    currentTopicId = this.value;
                    if (currentFilter === 'topic') {
                        loadLeaderboard();
                    }
                    if (currentFilter === 'test') {
                        loadTestsForTopic(currentTopicId);
                    }
                });
                
                testFilter.addEventListener('change', function() {
                    currentTestId = this.value;
                    if (currentFilter === 'test') {
                        loadLeaderboard();
                    }
                });
            }
            
            function updateFilterVisibility() {
                topicFilterGroup.style.display = currentFilter === 'topic' || currentFilter === 'test' ? 'block' : 'none';
                testFilterGroup.style.display = currentFilter === 'test' ? 'block' : 'none';
                
                if (currentFilter === 'topic' || currentFilter === 'test') {
                    loadTopics();
                }
            }
            
            async function loadTopics() {
                try {
                    const response = await fetch('${pageContext.request.contextPath}/api/topics');
                    const topics = await response.json();
                    
                    topicFilter.innerHTML = '<option value="">All Topics</option>';
                                     topics.forEach(function(topic) {
                     const option = document.createElement('option');
                     option.value = topic.id;
                     option.textContent = topic.name;
                     topicFilter.appendChild(option);
                 });
                } catch (error) {
                    console.error('Failed to load topics:', error);
                }
            }
            
            async function loadTestsForTopic(topicId) {
                if (!topicId) return;
                
                try {
                    const response = await fetch('${pageContext.request.contextPath}/api/topics/' + topicId + '/tests');
                    const tests = await response.json();
                    
                    testFilter.innerHTML = '<option value="">All Tests</option>';
                                         tests.forEach(function(test) {
                         const option = document.createElement('option');
                         option.value = test.id;
                         option.textContent = test.name || 'Test ' + test.testNumber;
                         testFilter.appendChild(option);
                     });
                } catch (error) {
                    console.error('Failed to load tests:', error);
                }
            }
            
            async function loadLeaderboard() {
                showLoading();
                
                try {
                    let url = '${pageContext.request.contextPath}/api/leaderboard';
                    const params = new URLSearchParams();
                    
                    if (currentFilter === 'topic' && currentTopicId) {
                        params.append('topicId', currentTopicId);
                    } else if (currentFilter === 'test' && currentTestId) {
                        params.append('testId', currentTestId);
                    }
                    
                    if (params.toString()) {
                        url += '?' + params.toString();
                    }
                    
                    const response = await fetch(url);
                    const data = await response.json();
                    
                    if (data.success) {
                        renderLeaderboard(data.leaderboard);
                        updateStats(data.stats);
                    } else {
                        showError(data.message || 'Failed to load leaderboard');
                    }
                } catch (error) {
                    console.error('Error loading leaderboard:', error);
                    showError('Failed to load leaderboard data');
                }
            }
            
            function renderLeaderboard(leaderboard) {
                if (!leaderboard || leaderboard.length === 0) {
                    showNoData();
                    return;
                }
                
                                 let table = '<table class="leaderboard-table">';
                 table += '<thead><tr>';
                 table += '<th>Rank</th>';
                 table += '<th>User Name</th>';
                 table += '<th>Average Score</th>';
                 table += '<th>Tests Taken</th>';
                 table += '<th>Total Time</th>';
                 table += '</tr></thead><tbody>';
                 
                 leaderboard.forEach(function(user, index) {
                     table += '<tr>';
                     table += '<td class="rank-cell ' + getRankClass(index + 1) + '">' + (index + 1) + '</td>';
                     table += '<td class="user-name">' + (user.userName || '') + '</td>';
                     table += '<td class="score-cell ' + getScoreClass(user.avgScore) + '">' + (user.avgScore ? user.avgScore.toFixed(1) : '0.0') + '%</td>';
                     table += '<td class="stats-cell">' + (user.totalTests || 0) + '</td>';
                     table += '<td class="time-cell">' + formatTime(user.totalTimeTaken || 0) + '</td>';
                     table += '</tr>';
                 });
                 
                 table += '</tbody></table>';
                
                leaderboardContent.innerHTML = table;
            }
            
            function getRankClass(rank) {
                if (rank === 1) return 'rank-1';
                if (rank === 2) return 'rank-2';
                if (rank === 3) return 'rank-3';
                return '';
            }
            
            function getScoreClass(score) {
                if (score >= 90) return 'score-90';
                if (score >= 80) return 'score-80';
                if (score >= 70) return 'score-70';
                if (score >= 60) return 'score-60';
                return 'score-below';
            }
            
            function formatTime(minutes) {
                if (minutes < 60) return minutes + 'm';
                const hours = Math.floor(minutes / 60);
                const mins = minutes % 60;
                return hours + 'h ' + mins + 'm';
            }
            
            function updateStats(stats) {
                if (stats) {
                    document.getElementById('totalUsers').textContent = stats.totalUsers || '-';
                    document.getElementById('avgScore').textContent = (stats.avgScore || 0).toFixed(1) + '%';
                    document.getElementById('topScore').textContent = (stats.topScore || 0).toFixed(1) + '%';
                    document.getElementById('totalTests').textContent = stats.totalTests || '-';
                }
            }
            
            function              showLoading() {
                 leaderboardContent.innerHTML = 
                     '<div class="loading">' +
                         '<div class="loading-spinner"></div>' +
                         '<p>Loading leaderboard data...</p>' +
                     '</div>';
             }
            
            function              showNoData() {
                 leaderboardContent.innerHTML = 
                     '<div class="no-data">' +
                         '<div class="no-data-icon">📊</div>' +
                         '<h3>No Data Available</h3>' +
                         '<p>No leaderboard data found for the selected criteria.</p>' +
                         '<button class="refresh-btn" onclick="loadLeaderboard()">Refresh</button>' +
                     '</div>';
             }
            
            function              showError(message) {
                 leaderboardContent.innerHTML = 
                     '<div class="no-data">' +
                         '<div class="no-data-icon">⚠️</div>' +
                         '<h3>Error</h3>' +
                         '<p>' + (message || 'Unknown error') + '</p>' +
                         '<button class="refresh-btn" onclick="loadLeaderboard()">Try Again</button>' +
                     '</div>';
             }
            
            // Make loadLeaderboard globally accessible
            window.loadLeaderboard = loadLeaderboard;
        })();
    </script>
</body>
</html>
