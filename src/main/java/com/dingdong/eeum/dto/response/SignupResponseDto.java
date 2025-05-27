package com.dingdong.eeum.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class SignupResponseDto {
    private String userId;
    private String nickname;
    private String email;
}
