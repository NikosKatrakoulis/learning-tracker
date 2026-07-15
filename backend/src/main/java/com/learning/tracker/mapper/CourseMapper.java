package com.learning.tracker.mapper;

import com.learning.tracker.dto.CourseDto;
import com.learning.tracker.model.Course;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CourseMapper {
    CourseDto toDto(Course course);
    List<CourseDto> toDtoList(List<Course> courses);
}
