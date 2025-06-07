package com.dingdong.eeum.dto.response;

import com.dingdong.eeum.constant.ReportType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "리뷰 신고 응답 DTO")
public class ReportResponseDto {

    @Schema(description = "신고 ID")
    private String reportId;

    @Schema(description = "신고된 컨텐츠 ID (장소 혹은 리뷰)")
    private String contentId;

    @Schema(description = "신고 유형", example = "SPAM")
    private ReportType reportType;

    @Schema(description = "신고자 ID", example = "user_123456789")
    private String reporterId;

    @Schema(description = "신고 생성 시간")
    private LocalDateTime createdAt;
}