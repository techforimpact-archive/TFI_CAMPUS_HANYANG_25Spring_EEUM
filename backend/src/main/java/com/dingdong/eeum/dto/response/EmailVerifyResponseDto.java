package com.dingdong.eeum.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class EmailVerifyResponseDto {
    private String email;
    private boolean verified;

    public static EmailVerifyResponseDto toEmailVerifyResponseDto(String email, boolean verified) {
        return EmailVerifyResponseDto.builder()
                .email(email)
                .verified(verified)
                .build();
    }
}
