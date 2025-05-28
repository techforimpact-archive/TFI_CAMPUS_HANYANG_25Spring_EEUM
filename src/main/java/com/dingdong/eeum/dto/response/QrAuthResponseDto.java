package com.dingdong.eeum.dto.response;

import com.dingdong.eeum.constant.UserRole;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "QR 인증 응답")
public class QrAuthResponseDto {

    @Schema(description = "액세스 토큰", example = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...")
    private String accessToken;

    @Schema(description = "사용자 ID", example = "user123")
    private String userId;

    @Schema(description = "사용자 권한", example = "USER")
    private UserRole userRole;

    @Schema(description = "사용자 닉네임", example = "홍길동")
    private String nickname;
}
