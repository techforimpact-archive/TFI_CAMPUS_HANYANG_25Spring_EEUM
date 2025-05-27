package com.dingdong.eeum.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class PasswordResetVerifyResponseDto {
    private String email;
    private boolean verified;
    private String resetToken;

    public static PasswordResetVerifyResponseDto toPasswordResetVerifyResponseDto(String email, String resetToken) {
        return PasswordResetVerifyResponseDto.builder()
                .email(email)
                .verified(true)
                .resetToken(resetToken)
                .build();
    }
}
