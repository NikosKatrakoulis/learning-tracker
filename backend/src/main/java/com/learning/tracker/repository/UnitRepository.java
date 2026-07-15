package com.learning.tracker.repository;

import com.learning.tracker.model.Unit;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface UnitRepository extends JpaRepository<Unit, Long> {
    List<Unit> findByCourseIdOrderByOrderIndex(Long courseId);
    List<Unit> findByCourseIdAndOrderIndexGreaterThanEqualOrderByOrderIndex(Long courseId, Integer orderIndex);
    void deleteByCourseId(Long courseId);
}
