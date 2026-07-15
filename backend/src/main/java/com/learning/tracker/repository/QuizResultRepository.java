package com.learning.tracker.repository;

import com.learning.tracker.model.QuizResult;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuizResultRepository extends JpaRepository<QuizResult, Long> {
    List<QuizResult> findByUserIdOrderByAttemptedAtDesc(Long userId);
}
