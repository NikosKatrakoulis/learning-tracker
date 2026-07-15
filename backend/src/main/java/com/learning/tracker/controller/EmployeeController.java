package com.learning.tracker.controller;

import com.learning.tracker.dto.UserDto;
import com.learning.tracker.service.LearningService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/employees")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class EmployeeController {
    private final LearningService learningService;

    @GetMapping
    public List<UserDto> getEmployees() {
        return learningService.getAllEmployees();
    }

    @GetMapping("/{userId}/report")
    public Map<String, Object> getEmployeeReport(@PathVariable Long userId) {
        return learningService.getEmployeeReport(userId);
    }
}
