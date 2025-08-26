(function() {
    const meta = document.querySelector('.test-meta');
    const mockTestId = meta?.getAttribute('data-mocktest-id');
    const totalQuestions = parseInt(meta?.getAttribute('data-total-questions') || '1', 10);
    const topicId = meta?.getAttribute('data-topic-id');
    const durationMinutes = parseInt(meta?.getAttribute('data-duration-minutes') || '30', 10);

    const timerEl = document.getElementById('timer');
    const qProgressEl = document.getElementById('qProgress');
    const qNumberEl = document.getElementById('questionNumber');
    const qTextEl = document.getElementById('questionText');
    const optionsEl = document.getElementById('optionsContainer');
    const explanationEl = document.getElementById('explanation');
    const nextBtn = document.getElementById('nextBtn');
    const skipBtn = document.getElementById('skipBtn');
    const progressFill = document.getElementById('progressFill');

    // State loaded from server
    let questions = [];

    // Clear saved progress on real navigations (keep on reload only)
    try {
        const navEntries = performance.getEntriesByType && performance.getEntriesByType('navigation');
        const navType = navEntries && navEntries[0] ? navEntries[0].type : (performance.navigation && performance.navigation.type === 1 ? 'reload' : 'navigate');
        if (navType !== 'reload') {
            sessionStorage.removeItem(`mtp_progress_${mockTestId}`);
        }
    } catch (e) { /* ignore */ }

    // Restore progress after reload
    const saved = sessionStorage.getItem(`mtp_progress_${mockTestId}`);
    let currentIndex = saved ? Math.min(parseInt(saved, 10) || 0, 0) : 0;
    let answered = false;
    const answers = []; // {questionId, selectedOptionId|null, correct:boolean|null}

    function formatTime(seconds) {
        const m = Math.floor(seconds / 60).toString().padStart(2, '0');
        const s = (seconds % 60).toString().padStart(2, '0');
        return `${m}:${s}`;
    }

    let remainingSeconds = durationMinutes * 60;
    let timerId = null;
    const remainingKey = mockTestId ? `mtp_remaining_${mockTestId}` : null;

    function renderQuestion(index) {
        console.log('Rendering question at index:', index, 'questions length:', questions.length);
        const q = questions[index];
        if (!q) {
            console.log('No question found at index:', index);
            return;
        }

        answered = false;
        // While skip is available (unanswered), Next should be disabled per requirement
        nextBtn.disabled = true;
        if (skipBtn) skipBtn.style.display = '';
        explanationEl.style.display = 'none';
        explanationEl.textContent = '';

        qNumberEl.textContent = `Q${index + 1}`;
        qTextEl.textContent = q.text;
        qProgressEl.textContent = `${index + 1} / ${Math.max(totalQuestions, questions.length)}`;
        const progressPct = ((index) / Math.max(totalQuestions, questions.length)) * 100;
        progressFill.style.width = `${progressPct}%`;

        optionsEl.innerHTML = '';
        q.options.forEach((opt, i) => {
            const btn = document.createElement('button');
            btn.className = 'option-btn';
            btn.textContent = opt.text;
            btn.addEventListener('click', () => handleAnswer(btn, q.questionId, opt.optionId));
            optionsEl.appendChild(btn);
        });
    }

    async function handleAnswer(button, questionId, optionId) {
        if (answered) return;
        answered = true;

        // lock all buttons
        Array.from(optionsEl.querySelectorAll('.option-btn')).forEach(b => {
            b.disabled = true;
        });

        try {
            const res = await fetch(`${document.body.getAttribute('data-ctx') || ''}/api/mocktest/answer`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ questionId, optionId })
            });
            const data = await res.json();
            if (data.correct) {
                button.classList.add('correct');
                answers[currentIndex] = { questionId, selectedOptionId: optionId, correct: true };
            } else {
                button.classList.add('wrong');
                if (data.explanation) {
                    explanationEl.textContent = data.explanation;
                    explanationEl.style.display = 'block';
                }
                const opts = Array.from(optionsEl.querySelectorAll('.option-btn'));
                const correctBtnIdx = questions[currentIndex].options.findIndex(o => o.optionId === data.correctOptionId);
                if (correctBtnIdx >= 0) {
                    opts[correctBtnIdx].classList.add('correct');
                }
                answers[currentIndex] = { questionId, selectedOptionId: optionId, correct: false };
            }
            // After selecting any option: hide Skip and enable Next
            if (skipBtn) skipBtn.style.display = 'none';
            nextBtn.disabled = false;
        } catch (e) {
            console.error(e);
        } finally {
        }
    }

    function goNext() {
        if (currentIndex < questions.length - 1) {
            currentIndex += 1;
            sessionStorage.setItem(`mtp_progress_${mockTestId}`, String(currentIndex));
            renderQuestion(currentIndex);
        } else {
            // reached end of available questions
            progressFill.style.width = '100%';
            nextBtn.disabled = true;
            showAnalysis();
        }
    }

    nextBtn.addEventListener('click', () => {
        // If unanswered, record as skipped
        if (!answers[currentIndex]) {
            answers[currentIndex] = { questionId: questions[currentIndex].questionId, selectedOptionId: null, correct: null };
        }
        goNext();
    });

    if (skipBtn) {
        skipBtn.addEventListener('click', () => {
            answers[currentIndex] = { questionId: questions[currentIndex].questionId, selectedOptionId: null, correct: null };
            goNext();
        });
    }

    // Clear progress when clicking back to tests
    const backLink = document.querySelector('.breadcrumbs .back-link');
    if (backLink) {
        backLink.addEventListener('click', () => {
            try { sessionStorage.removeItem(`mtp_progress_${mockTestId}`); } catch (e) {}
        });
    }

    async function showAnalysis() {
        const total = questions.length;
        let correct = 0, incorrect = 0, unanswered = 0;
        answers.forEach(a => {
            if (!a || a.selectedOptionId === null) unanswered += 1;
            else if (a.correct) correct += 1;
            else incorrect += 1;
        });
        const percent = total > 0 ? Math.round((correct / total) * 100) : 0;

        // Persist completion (best-effort; userId is server-side only, so we skip if not available)
        try {
            const userIdMeta = document.querySelector('meta[name="userId"]');
            const userId = userIdMeta ? userIdMeta.getAttribute('content') : null;
            if (userId) {
                await fetch(`${document.body.getAttribute('data-ctx') || ''}/api/mocktest/complete`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ userId: Number(userId), mockTestId: Number(mockTestId), correct, total })
                });
            }
        } catch (e) { console.warn('Failed to persist attempt', e); }

        // Clear persisted progress for this test to prevent starting mid-way on navigation
        try { sessionStorage.removeItem(`mtp_progress_${mockTestId}`); } catch (e) {}

        // Redirect to analysis page with query params
        const base = document.body.getAttribute('data-ctx') || '';
        const params = new URLSearchParams({
            mockTestId: String(mockTestId),
            topicId: String(topicId || ''),
            total: String(total),
            correct: String(correct),
            incorrect: String(incorrect),
            unanswered: String(unanswered),
            percent: String(percent)
        });
        window.location.href = `${base}/mocktest/analysis?${params.toString()}`;
    }

    async function startTestInternal() {
        // load config
        try {
            const base = document.body.getAttribute('data-ctx') || '';
            console.log('Loading test data for mockTestId:', mockTestId);
            const [cfgRes, qRes] = await Promise.all([
                fetch(`${base}/api/mocktest/${mockTestId}/config`),
                fetch(`${base}/api/mocktest/${mockTestId}/questions`)
            ]);
            const cfg = await cfgRes.json();
            questions = await qRes.json();
            console.log('Loaded config:', cfg);
            console.log('Loaded questions:', questions);

            // Update timer and total from server if provided
            const cfgMinutes = parseInt(cfg.durationMinutes || durationMinutes, 10);
            const savedRemain = remainingKey ? parseInt(sessionStorage.getItem(remainingKey) || '0', 10) : 0;
            remainingSeconds = savedRemain > 0 ? savedRemain : (cfgMinutes * 60);
            timerEl.textContent = formatTime(remainingSeconds);
            timerId = setInterval(() => {
                remainingSeconds -= 1;
                try { if (remainingKey) sessionStorage.setItem(remainingKey, String(Math.max(remainingSeconds, 0))); } catch (e) {}
                if (remainingSeconds < 0) {
                    clearInterval(timerId);
                    // Time up: redirect back to tests
                    const base = document.body.getAttribute('data-ctx') || '';
                    const resolvedTopicId = topicId || (new URLSearchParams(window.location.search).get('topicId')) || '';
                    try { sessionStorage.removeItem(`mtp_progress_${mockTestId}`); } catch (e) {}
                    try { if (remainingKey) sessionStorage.removeItem(remainingKey); } catch (e) {}
                    window.location.href = `${base}/topic/${resolvedTopicId}/mocktests`;
                    return;
                }
                timerEl.textContent = formatTime(remainingSeconds);
            }, 1000);

            // Clamp index if saved before we know the length
            const savedIdx = sessionStorage.getItem(`mtp_progress_${mockTestId}`);
            if (savedIdx) {
                currentIndex = Math.min(parseInt(savedIdx, 10) || 0, questions.length - 1);
            }
            renderQuestion(currentIndex);
        } catch (e) {
            console.error('Failed to load test data', e);
        }
    }

    // Expose start function to page script after rules/theory are acknowledged
    window.startTest = function() {
        // Avoid duplicate starts
        if (timerId !== null) return;
        startTestInternal();
    };

    // Persist remaining time on unload just in case
    window.addEventListener('beforeunload', function() {
        try { if (remainingKey) sessionStorage.setItem(remainingKey, String(Math.max(remainingSeconds, 0))); } catch (e) {}
    });

    // Clear started flag when leaving via back link
    const testBackLink = document.querySelector('.breadcrumbs .back-link');
    if (testBackLink) {
        testBackLink.addEventListener('click', () => {
            const startedKey = `mtp_started_${mockTestId}`;
            try { sessionStorage.removeItem(startedKey); } catch (e) {}
            try { if (remainingKey) sessionStorage.removeItem(remainingKey); } catch (e) {}
        });
    }
})();


