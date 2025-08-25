package com.webapp.mocker;

import java.util.List;
import com.webapp.mocker.models.Question;
import com.webapp.mocker.models.AnswerOption;

public class QuestionWithAnswers {
    private Question question;
    private List<AnswerOption> answerOptions;
    
    public QuestionWithAnswers(Question question, List<AnswerOption> answerOptions) {
        this.question = question;
        this.answerOptions = answerOptions;
    }
    
    public Question getQuestion() {
        return question;
    }
    
    public void setQuestion(Question question) {
        this.question = question;
    }
    
    public List<AnswerOption> getAnswerOptions() {
        return answerOptions;
    }
    
    public void setAnswerOptions(List<AnswerOption> answerOptions) {
        this.answerOptions = answerOptions;
    }
    
    public AnswerOption getCorrectAnswer() {
        return answerOptions.stream()
                .filter(AnswerOption::getIsCorrect)
                .findFirst()
                .orElse(null);
    }
}
