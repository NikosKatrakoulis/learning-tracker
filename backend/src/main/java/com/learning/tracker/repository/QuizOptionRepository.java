package com.learning.tracker.repository;

import com.learning.tracker.model.QuizOption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface QuizOptionRepository extends JpaRepository<QuizOption, Long> {
    @Modifying
    @Query("DELETE FROM QuizOption o WHERE o.question.unit.id = :unitId")
    void deleteByQuestionUnitId(Long unitId);

    @Modifying
    @Query("DELETE FROM QuizOption o WHERE o.question.unit.course.id = :courseId")
    void deleteByQuestionUnitCourseId(Long courseId);
}
