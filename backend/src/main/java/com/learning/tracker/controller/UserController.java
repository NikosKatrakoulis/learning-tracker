package com.learning.tracker.controller;

import com.learning.tracker.dto.*;

import com.learning.tracker.model.User;
import com.learning.tracker.service.LearningService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Per-user operations: account management, course assignment, unit progress, quiz results and feedback.
 * The userId comes from the URL and is not compared with the authenticated user, so any logged-in
 * user can act on any other user's data.
 */

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UserController {
    private final LearningService learningService;

    // Binds the entity directly; the service hashes the password before saving.
    @PostMapping
    public UserDto createUser(@RequestBody User user) {
        return learningService.createUser(user);
    }

    // The service signals a wrong old password with a RuntimeException, mapped here to 400.
    @PutMapping("/{userId}/password")
    public ResponseEntity<?> updatePassword(@PathVariable Long userId, @RequestBody Map<String, String> request) {
        String oldPassword = request.get("oldPassword");
        String newPassword = request.get("password");
        try {
            learningService.updatePassword(userId, oldPassword, newPassword);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    @GetMapping("/{userId}/progress")
    public List<UserUnitProgressDto> getProgress(@PathVariable Long userId) {
        return learningService.getUserProgress(userId);
    }

    // Assigned courses with completed/total unit counts and completion percentage.
    @GetMapping("/{userId}/courses")
    public List<CourseWithProgressDto> getCoursesByUser(@PathVariable Long userId) {
        return learningService.getCoursesByUser(userId);
    }

    @GetMapping("/{userId}/courses/unassigned")
    public List<CourseDto> getUnassignedCourses(@PathVariable Long userId) {
        return learningService.getUnassignedCourses(userId);
    }

    // Idempotent: assigning an already-assigned course is a no-op.
    @PostMapping("/{userId}/courses/{courseId}")
    public ResponseEntity<Void> assignCourse(@PathVariable Long userId, @PathVariable Long courseId) {
        learningService.assignCourseToUser(userId, courseId);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/{userId}/units/{unitId}/complete")
    public UserUnitProgressDto completeUnit(@PathVariable Long userId, @PathVariable Long unitId) {
        return learningService.completeUnit(userId, unitId);
    }

    // Removes the progress record entirely rather than flipping a flag.
    @PostMapping("/{userId}/units/{unitId}/unmark")
    public ResponseEntity<Void> unmarkUnit(@PathVariable Long userId, @PathVariable Long unitId) {
        learningService.unmarkUnit(userId, unitId);
        return ResponseEntity.ok().build();
    }

    // Score, percentage and grade are computed by the client and stored as received.
    @PostMapping("/{userId}/units/{unitId}/quiz-result")
    public ResponseEntity<Void> saveQuizResult(@PathVariable Long userId, @PathVariable Long unitId,
                                               @RequestBody SaveQuizResultRequest req) {
        learningService.saveQuizResult(userId, unitId, req);
        return ResponseEntity.ok().build();
    }

    // One summary row per quiz unit: attempt count, best and latest result.
    @GetMapping("/{userId}/quiz-summaries")
    public List<QuizAttemptSummaryDto> getQuizSummaries(@PathVariable Long userId) {
        return learningService.getQuizSummariesForUser(userId);
    }

    // Α user has at most one feedback entry per course.
    @PostMapping("/{userId}/courses/{courseId}/feedback")
    public CourseFeedbackDto saveFeedback(@PathVariable Long userId, @PathVariable Long courseId,
                                          @RequestBody SaveFeedbackRequest req) {
        return learningService.saveFeedback(userId, courseId, req);
    }

    // When the user has not left feedback for this course yet.
    @GetMapping("/{userId}/courses/{courseId}/feedback")
    public ResponseEntity<CourseFeedbackDto> getFeedback(@PathVariable Long userId, @PathVariable Long courseId) {
        return learningService.getUserFeedbackForCourse(userId, courseId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{userId}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long userId) {
        learningService.deleteUser(userId);
        return ResponseEntity.ok().build();
    }

    // Also deletes the user's progress in that course
    @DeleteMapping("/{userId}/courses/{courseId}")
    public ResponseEntity<Void> unassignCourse(@PathVariable Long userId, @PathVariable Long courseId) {
        learningService.unassignCourseFromUser(userId, courseId);
        return ResponseEntity.ok().build();
    }
}
