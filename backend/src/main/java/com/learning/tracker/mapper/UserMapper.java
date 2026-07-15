package com.learning.tracker.mapper;

import com.learning.tracker.dto.UserDto;
import com.learning.tracker.model.User;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UserMapper {
    UserDto toDto(User user);
    List<UserDto> toDtoList(List<User> users);
}
