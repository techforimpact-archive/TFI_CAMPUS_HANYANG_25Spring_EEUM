package com.dingdong.eeum.dto;

import com.dingdong.eeum.constant.UserRole;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserInfoDto {

    private String userId;
    private UserRole userRole;

    public static UserInfoDto of(String userId, UserRole userRole) {
        return UserInfoDto.builder()
                .userId(userId)
                .userRole(userRole)
                .build();
    }
}
