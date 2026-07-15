package com.learning.tracker.dto;

public record QuizAttemptSummaryDto(
        Long unitId,
        String unitTitle,
        String courseTitle,
        Integer attempts,
        Integer bestPercentage,
        Integer lastPercentage,
        String lastGrade
) {}
