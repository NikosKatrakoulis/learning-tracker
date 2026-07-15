package com.learning.tracker.dto;

public record SaveQuizResultRequest(Integer score, Integer total, Integer percentage, String grade) {}
