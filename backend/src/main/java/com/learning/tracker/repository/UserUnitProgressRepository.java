package com.learning.tracker.repository;

import com.learning.tracker.model.UserUnitProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface UserUnitProgressRepository extends JpaRepository<UserUnitProgress, Long> {
    List<UserUnitProgress> findByUserId(Long userId);
    Optional<UserUnitProgress> findByUserIdAndUnitId(Long userId, Long unitId);
    List<UserUnitProgress> findByUserIdAndUnitCourseId(Long userId, Long courseId);
    void deleteByUserId(Long userId);
    void deleteByUnitId(Long unitId);
    void deleteByUnitCourseId(Long courseId);
    void deleteByUserIdAndUnitCourseId(Long userId, Long courseId);
}
