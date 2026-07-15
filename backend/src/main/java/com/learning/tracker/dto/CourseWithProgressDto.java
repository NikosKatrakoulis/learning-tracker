package com.learning.tracker.dto;

public record CourseWithProgressDto(
        Long id,
        String title,
        String description,
        int totalUnits,
        int completedUnits,
        double completionPercentage
) {}
