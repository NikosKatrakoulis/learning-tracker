package com.learning.tracker.dto;

public record CourseFeedbackDto(
        Long id,
        Long userId,
        String username,
        String fullName,
        Integer rating,
        String comment,
        String createdAt
) {}
