package com.learning.tracker.dto;

import java.util.List;

public record CreateQuizUnitRequest(
        String title,
        String section,
        Integer orderIndex,
        List<CreateQuizQuestionRequest> questions
) {
    public record CreateQuizQuestionRequest(
            String questionText,
            String correctOption,
            Integer orderIndex,
            List<CreateQuizOptionRequest> options
    ) {}

    public record CreateQuizOptionRequest(
            String optionLetter,
            String optionText
    ) {}
}
