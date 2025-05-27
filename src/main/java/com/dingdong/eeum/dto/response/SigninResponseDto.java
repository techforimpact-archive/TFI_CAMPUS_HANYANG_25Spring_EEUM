package com.dingdong.eeum.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class SigninResponseDto {
    private String userId;
    private String nickname;
    private String email;
    private String accessToken;
    private String refreshToken;
}
