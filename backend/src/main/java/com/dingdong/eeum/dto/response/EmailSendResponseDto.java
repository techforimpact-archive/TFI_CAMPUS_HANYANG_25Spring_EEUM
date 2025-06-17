package com.dingdong.eeum.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class EmailSendResponseDto {
    private String email;
    private int expirationMinutes;

    public static EmailSendResponseDto toEmailSendResponseDto(String email) {
        return EmailSendResponseDto.builder()
                .email(email)
                .expirationMinutes(5)
                .build();
    }
}
