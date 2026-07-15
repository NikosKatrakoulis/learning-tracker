package com.learning.tracker.dto;

public record UnitDto(Long id, Long courseId, String title, String section, String content, Integer orderIndex, String unitType, String pdfPath, String pdfName) {}
