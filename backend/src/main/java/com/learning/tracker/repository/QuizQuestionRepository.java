package com.learning.tracker.repository;

import com.learning.tracker.model.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface QuizQuestionRepository extends JpaRepository<QuizQuestion, Long> {
    List<QuizQuestion> findByUnitIdOrderByOrderIndex(Long unitId);

    @Modifying
    @Query("DELETE FROM QuizQuestion q WHERE q.unit.id = :unitId")
    void deleteByUnitId(Long unitId);

    @Modifying
    @Query("DELETE FROM QuizQuestion q WHERE q.unit.course.id = :courseId")
    void deleteByUnitCourseId(Long courseId);
}
