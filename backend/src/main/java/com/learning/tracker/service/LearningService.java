package com.learning.tracker.service;

import com.learning.tracker.dto.*;
import com.learning.tracker.mapper.*;
import com.learning.tracker.model.*;
import com.learning.tracker.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class LearningService {
    private final CourseRepository courseRepository;
    private final UnitRepository unitRepository;
    private final UserUnitProgressRepository progressRepository;
    private final UserCourseRepository userCourseRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    private final QuizQuestionRepository quizQuestionRepository;
    private final QuizOptionRepository quizOptionRepository;
    private final QuizResultRepository quizResultRepository;
    private final CourseFeedbackRepository feedbackRepository;

    private final CourseMapper courseMapper;
    private final UnitMapper unitMapper;
    private final UserMapper userMapper;
    private final ProgressMapper progressMapper;

    // ── Courses ──────────────────────────────────────────────────────────────

    public List<CourseDto> getAllCourses() {
        return courseMapper.toDtoList(courseRepository.findAll());
    }

    public List<UnitDto> getUnitsByCourse(Long courseId) {
        return unitMapper.toDtoList(unitRepository.findByCourseIdOrderByOrderIndex(courseId));
    }

    public java.util.Optional<Unit> getUnitById(Long unitId) {
        return unitRepository.findById(unitId);
    }

    @Transactional
    public CourseDto createCourse(Course course) {
        return courseMapper.toDto(courseRepository.save(course));
    }

    @Transactional
    public UnitDto createUnit(Long courseId, Unit unit) {
        Course course = courseRepository.findById(courseId).orElseThrow();
        unit.setCourse(course);

        // If the requested orderIndex is already taken, shift all units at that position and above
        List<Unit> conflicting = unitRepository
                .findByCourseIdAndOrderIndexGreaterThanEqualOrderByOrderIndex(courseId, unit.getOrderIndex());
        if (!conflicting.isEmpty() && conflicting.get(0).getOrderIndex().equals(unit.getOrderIndex())) {
            conflicting.forEach(u -> u.setOrderIndex(u.getOrderIndex() + 1));
            unitRepository.saveAll(conflicting);
        }

        return unitMapper.toDto(unitRepository.save(unit));
    }

    @Transactional
    public UnitDto createQuizUnit(Long courseId, CreateQuizUnitRequest req) {
        Course course = courseRepository.findById(courseId).orElseThrow();

        Unit unit = new Unit();
        unit.setCourse(course);
        unit.setTitle(req.title());
        unit.setSection(req.section());
        unit.setContent("");
        unit.setOrderIndex(req.orderIndex());
        unit.setUnitType("quiz");

        List<Unit> conflicting = unitRepository
                .findByCourseIdAndOrderIndexGreaterThanEqualOrderByOrderIndex(courseId, unit.getOrderIndex());
        if (!conflicting.isEmpty() && conflicting.get(0).getOrderIndex().equals(unit.getOrderIndex())) {
            conflicting.forEach(u -> u.setOrderIndex(u.getOrderIndex() + 1));
            unitRepository.saveAll(conflicting);
        }

        Unit saved = unitRepository.save(unit);

        if (req.questions() != null) {
            for (CreateQuizUnitRequest.CreateQuizQuestionRequest qReq : req.questions()) {
                QuizQuestion question = new QuizQuestion();
                question.setUnit(saved);
                question.setQuestionText(qReq.questionText());
                question.setCorrectOption(qReq.correctOption());
                question.setOrderIndex(qReq.orderIndex());
                QuizQuestion savedQ = quizQuestionRepository.save(question);

                if (qReq.options() != null) {
                    for (CreateQuizUnitRequest.CreateQuizOptionRequest oReq : qReq.options()) {
                        QuizOption option = new QuizOption();
                        option.setQuestion(savedQ);
                        option.setOptionLetter(oReq.optionLetter());
                        option.setOptionText(oReq.optionText());
                        quizOptionRepository.save(option);
                    }
                }
            }
        }

        return unitMapper.toDto(saved);
    }

    public List<QuizQuestionDto> getQuizForUnit(Long unitId) {
        return quizQuestionRepository.findByUnitIdOrderByOrderIndex(unitId).stream()
                .map(q -> new QuizQuestionDto(
                        q.getId(),
                        q.getUnit().getId(),
                        q.getQuestionText(),
                        q.getCorrectOption(),
                        q.getOrderIndex(),
                        q.getOptions().stream()
                                .map(o -> new QuizOptionDto(o.getId(), o.getOptionLetter(), o.getOptionText()))
                                .collect(Collectors.toList())
                ))
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteCourse(Long courseId) {
        progressRepository.deleteByUnitCourseId(courseId);
        quizResultRepository.deleteAll(quizResultRepository.findAll().stream()
                .filter(r -> r.getUnit().getCourse().getId().equals(courseId)).toList());
        quizOptionRepository.deleteByQuestionUnitCourseId(courseId);
        quizQuestionRepository.deleteByUnitCourseId(courseId);
        userCourseRepository.deleteByCourseId(courseId);
        unitRepository.deleteByCourseId(courseId);
        courseRepository.deleteById(courseId);
    }

    @Transactional
    public void deleteUnit(Long unitId) {
        progressRepository.deleteByUnitId(unitId);
        quizResultRepository.deleteAll(quizResultRepository.findAll().stream()
                .filter(r -> r.getUnit().getId().equals(unitId)).toList());
        quizOptionRepository.deleteByQuestionUnitId(unitId);
        quizQuestionRepository.deleteByUnitId(unitId);
        unitRepository.deleteById(unitId);
    }

    // ── Users ────────────────────────────────────────────────────────────────

    @Transactional
    public UserDto createUser(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userMapper.toDto(userRepository.save(user));
    }

    @Transactional
    public void updatePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId).orElseThrow();
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new RuntimeException("Invalid old password");
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    @Transactional
    public void deleteUser(Long userId) {
        progressRepository.deleteByUserId(userId);
        quizResultRepository.deleteAll(quizResultRepository.findByUserIdOrderByAttemptedAtDesc(userId));
        userCourseRepository.deleteByUserId(userId);
        userRepository.deleteById(userId);
    }

    // ── Progress ─────────────────────────────────────────────────────────────

    public List<UserUnitProgressDto> getUserProgress(Long userId) {
        return progressMapper.toDtoList(progressRepository.findByUserId(userId));
    }

    @Transactional
    public UserUnitProgressDto completeUnit(Long userId, Long unitId) {
        User user = userRepository.findById(userId).orElseThrow();
        Unit unit = unitRepository.findById(unitId).orElseThrow();

        UserUnitProgress progress = progressRepository.findByUserIdAndUnitId(userId, unitId)
                .orElse(new UserUnitProgress());

        progress.setUser(user);
        progress.setUnit(unit);
        progress.setCompleted(true);
        progress.setCompletionDate(LocalDateTime.now());

        return progressMapper.toDto(progressRepository.save(progress));
    }

    @Transactional
    public void unmarkUnit(Long userId, Long unitId) {
        progressRepository.findByUserIdAndUnitId(userId, unitId).ifPresent(progressRepository::delete);
    }

    // ── User-Course assignments ───────────────────────────────────────────────

    public List<CourseWithProgressDto> getCoursesByUser(Long userId) {
        List<UserUnitProgress> progressList = progressRepository.findByUserId(userId);
        return userCourseRepository.findByUserId(userId).stream()
                .map(UserCourse::getCourse)
                .map(course -> {
                    int totalUnits = unitRepository.findByCourseIdOrderByOrderIndex(course.getId()).size();
                    int completedUnits = (int) progressList.stream()
                            .filter(p -> p.getUnit().getCourse().getId().equals(course.getId()) && p.isCompleted())
                            .count();
                    double pct = totalUnits == 0 ? 0.0
                            : Math.round(completedUnits * 1000.0 / totalUnits) / 10.0;
                    return new CourseWithProgressDto(course.getId(), course.getTitle(), course.getDescription(),
                            totalUnits, completedUnits, pct);
                })
                .toList();
    }

    public List<CourseDto> getUnassignedCourses(Long userId) {
        List<Long> assignedIds = userCourseRepository.findByUserId(userId).stream()
                .map(uc -> uc.getCourse().getId())
                .toList();

        return courseMapper.toDtoList(
                courseRepository.findAll().stream()
                        .filter(c -> !assignedIds.contains(c.getId()))
                        .toList()
        );
    }

    @Transactional
    public void assignCourseToUser(Long userId, Long courseId) {
        User user = userRepository.findById(userId).orElseThrow();
        Course course = courseRepository.findById(courseId).orElseThrow();

        if (userCourseRepository.findByUserIdAndCourseId(userId, courseId).isEmpty()) {
            UserCourse uc = new UserCourse();
            uc.setUser(user);
            uc.setCourse(course);
            userCourseRepository.save(uc);
        }
    }

    @Transactional
    public void unassignCourseFromUser(Long userId, Long courseId) {
        userCourseRepository.findByUserIdAndCourseId(userId, courseId)
                .ifPresent(userCourseRepository::delete);
        progressRepository.deleteByUserIdAndUnitCourseId(userId, courseId);
    }

    // ── Quiz results ─────────────────────────────────────────────────────────

    @Transactional
    public void saveQuizResult(Long userId, Long unitId, SaveQuizResultRequest req) {
        User user = userRepository.findById(userId).orElseThrow();
        Unit unit = unitRepository.findById(unitId).orElseThrow();
        QuizResult result = new QuizResult();
        result.setUser(user);
        result.setUnit(unit);
        result.setScore(req.score());
        result.setTotal(req.total());
        result.setPercentage(req.percentage());
        result.setGrade(req.grade());
        result.setAttemptedAt(LocalDateTime.now());
        quizResultRepository.save(result);
    }

    public List<QuizAttemptSummaryDto> getQuizSummariesForUser(Long userId) {
        List<QuizResult> results = quizResultRepository.findByUserIdOrderByAttemptedAtDesc(userId);
        Map<Long, List<QuizResult>> byUnit = results.stream()
                .collect(Collectors.groupingBy(r -> r.getUnit().getId()));
        return byUnit.entrySet().stream()
                .map(e -> {
                    List<QuizResult> list = e.getValue();
                    int best = list.stream().mapToInt(QuizResult::getPercentage).max().orElse(0);
                    QuizResult last = list.get(0);
                    return new QuizAttemptSummaryDto(
                            e.getKey(),
                            last.getUnit().getTitle(),
                            last.getUnit().getCourse().getTitle(),
                            list.size(),
                            best,
                            last.getPercentage(),
                            last.getGrade()
                    );
                })
                .sorted(Comparator.comparing(QuizAttemptSummaryDto::courseTitle)
                        .thenComparing(QuizAttemptSummaryDto::unitTitle))
                .collect(Collectors.toList());
    }

    // ── Employees ────────────────────────────────────────────────────────────

    public List<UserDto> getAllEmployees() {
        return userMapper.toDtoList(userRepository.findByRole("USER"));
    }

    public Map<String, Object> getEmployeeReport(Long userId) {
        User user = userRepository.findById(userId).orElseThrow();
        List<UserUnitProgress> progressList = progressRepository.findByUserId(userId);

        List<Course> assignedCourses = userCourseRepository.findByUserId(userId).stream()
                .map(UserCourse::getCourse)
                .toList();

        List<Map<String, Object>> courseProgress = assignedCourses.stream().map(course -> {
            long totalUnits = unitRepository.findByCourseIdOrderByOrderIndex(course.getId()).size();
            long completedUnits = progressList.stream()
                    .filter(p -> p.getUnit().getCourse().getId().equals(course.getId()) && p.isCompleted())
                    .count();

            Map<String, Object> map = new java.util.HashMap<>();
            map.put("courseTitle", course.getTitle());
            map.put("totalUnits", totalUnits);
            map.put("completedUnits", completedUnits);
            map.put("remainingUnits", totalUnits - completedUnits);
            return map;
        }).toList();

        return Map.of(
                "employeeId", user.getId(),
                "employeeName", user.getFullName(),
                "username", user.getUsername(),
                "courses", courseProgress
        );
    }

    // ── PDF storage ──────────────────────────────────────────────────────────

    @Transactional
    public UnitDto storePdf(Long unitId, byte[] data, String fileName) {
        Unit unit = unitRepository.findById(unitId).orElseThrow();
        unit.setPdfData(data);
        unit.setPdfName(fileName);
        return unitMapper.toDto(unitRepository.save(unit));
    }

    // ── Course feedback ───────────────────────────────────────────────────────

    @Transactional
    public CourseFeedbackDto saveFeedback(Long userId, Long courseId, SaveFeedbackRequest req) {
        User user = userRepository.findById(userId).orElseThrow();
        Course course = courseRepository.findById(courseId).orElseThrow();
        CourseFeedback fb = feedbackRepository.findByUserIdAndCourseId(userId, courseId)
                .orElseGet(CourseFeedback::new);
        fb.setUser(user);
        fb.setCourse(course);
        fb.setRating(req.rating());
        fb.setComment(req.comment());
        fb.setCreatedAt(LocalDateTime.now());
        return toFeedbackDto(feedbackRepository.save(fb));
    }

    public java.util.Optional<CourseFeedbackDto> getUserFeedbackForCourse(Long userId, Long courseId) {
        return feedbackRepository.findByUserIdAndCourseId(userId, courseId).map(this::toFeedbackDto);
    }

    public List<CourseFeedbackDto> getFeedbackForCourse(Long courseId) {
        return feedbackRepository.findByCourseIdOrderByCreatedAtDesc(courseId).stream()
                .map(this::toFeedbackDto)
                .collect(Collectors.toList());
    }

    private CourseFeedbackDto toFeedbackDto(CourseFeedback fb) {
        return new CourseFeedbackDto(
                fb.getId(),
                fb.getUser().getId(),
                fb.getUser().getUsername(),
                fb.getUser().getFullName(),
                fb.getRating(),
                fb.getComment(),
                fb.getCreatedAt().toString()
        );
    }
}
