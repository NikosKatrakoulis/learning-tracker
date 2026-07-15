package com.learning.tracker.mapper;

import com.learning.tracker.dto.UserUnitProgressDto;
import com.learning.tracker.model.UserUnitProgress;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ProgressMapper {

    @Mapping(source = "user.id", target = "userId")
    @Mapping(source = "unit.id", target = "unitId")
    UserUnitProgressDto toDto(UserUnitProgress progress);

    List<UserUnitProgressDto> toDtoList(List<UserUnitProgress> progressList);
}
