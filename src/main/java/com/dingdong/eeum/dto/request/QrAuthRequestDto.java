package com.dingdong.eeum.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "QR 인증 요청")
public class QrAuthRequestDto {

    @NotBlank(message = "QR 코드는 필수입니다")
    @Schema(description = "QR 코드 (JWT 토큰)", example = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...")
    private String qrCode;
}
