package com.learning.tracker.controller;

import com.learning.tracker.dto.*;
import com.learning.tracker.model.Course;
import com.learning.tracker.model.Unit;
import java.io.IOException;
import java.util.List;
import com.learning.tracker.service.LearningService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/courses")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CourseController {
    private final LearningService learningService;

    @GetMapping
    public List<CourseDto> getAllCourses() {
        return learningService.getAllCourses();
    }

    @PostMapping
    public CourseDto createCourse(@RequestBody Course course) {
        return learningService.createCourse(course);
    }

    @GetMapping("/{courseId}/units")
    public List<UnitDto> getUnits(@PathVariable Long courseId) {
        return learningService.getUnitsByCourse(courseId);
    }

    @PostMapping("/{courseId}/units")
    public UnitDto createUnit(@PathVariable Long courseId, @RequestBody Unit unit) {
        return learningService.createUnit(courseId, unit);
    }

    @PostMapping("/{courseId}/quiz-units")
    public UnitDto createQuizUnit(@PathVariable Long courseId, @RequestBody CreateQuizUnitRequest req) {
        return learningService.createQuizUnit(courseId, req);
    }

    @GetMapping("/units/{unitId}/quiz")
    public List<QuizQuestionDto> getQuiz(@PathVariable Long unitId) {
        return learningService.getQuizForUnit(unitId);
    }

    @GetMapping("/units/{unitId}/pdf")
    public ResponseEntity<Resource> getPdf(@PathVariable Long unitId) {
        var unitOpt = learningService.getUnitById(unitId);
        if (unitOpt.isEmpty()) return ResponseEntity.notFound().build();
        Unit unit = unitOpt.get();

        // Serve from DB if available
        if (unit.getPdfData() != null) {
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(new ByteArrayResource(unit.getPdfData()));
        }

        // Fallback: classpath (legacy seeded files)
        if (unit.getPdfPath() != null) {
            Resource resource = new ClassPathResource("lessons/" + unit.getPdfPath());
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(resource);
        }

        return ResponseEntity.notFound().build();
    }

    @PostMapping("/units/{unitId}/pdf")
    public ResponseEntity<UnitDto> uploadPdf(@PathVariable Long unitId,
                                             @RequestParam("file") MultipartFile file) throws IOException {
        UnitDto dto = learningService.storePdf(unitId, file.getBytes(), file.getOriginalFilename());
        return ResponseEntity.ok(dto);
    }

    @DeleteMapping("/{courseId}")
    public ResponseEntity<Void> deleteCourse(@PathVariable Long courseId) {
        learningService.deleteCourse(courseId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/units/{unitId}")
    public ResponseEntity<Void> deleteUnit(@PathVariable Long unitId) {
        learningService.deleteUnit(unitId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{courseId}/feedback")
    public List<CourseFeedbackDto> getFeedback(@PathVariable Long courseId) {
        return learningService.getFeedbackForCourse(courseId);
    }
}
