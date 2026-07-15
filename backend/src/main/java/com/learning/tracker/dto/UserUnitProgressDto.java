package com.learning.tracker.dto;

import java.time.LocalDateTime;

public record UserUnitProgressDto(Long id, Long userId, Long unitId, boolean completed, LocalDateTime completionDate) {}
