package com.learning.tracker.repository;

import com.learning.tracker.model.QuizResult;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuizResultRepository extends JpaRepository<QuizResult, Long> {

    // Newest first. getQuizSummariesForUser relies on this order to pick each unit's latest attempt.
    List<QuizResult> findByUserIdOrderByAttemptedAtDesc(Long userId);
}
