package com.learning.tracker.mapper;

import com.learning.tracker.dto.UnitDto;
import com.learning.tracker.model.Unit;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UnitMapper {

    @Mapping(source = "course.id", target = "courseId")
    @Mapping(source = "pdfName", target = "pdfName")
    UnitDto toDto(Unit unit);

    List<UnitDto> toDtoList(List<Unit> units);
}
