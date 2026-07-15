package com.learning.tracker.repository;

import com.learning.tracker.model.CourseFeedback;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface CourseFeedbackRepository extends JpaRepository<CourseFeedback, Long> {
    List<CourseFeedback> findByCourseIdOrderByCreatedAtDesc(Long courseId);
    Optional<CourseFeedback> findByUserIdAndCourseId(Long userId, Long courseId);
}
