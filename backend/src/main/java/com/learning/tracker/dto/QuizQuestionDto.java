package com.learning.tracker.dto;

import java.util.List;

public record QuizQuestionDto(Long id, Long unitId, String questionText, String correctOption, Integer orderIndex, List<QuizOptionDto> options) {}
