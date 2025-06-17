package com.dingdong.eeum.dto.request;

import com.dingdong.eeum.constant.ContentType;
import com.dingdong.eeum.constant.ReportType;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "리뷰 신고 요청 DTO")
public class ReportRequestDto {

    @NotNull(message = "신고 컨텐츠 유형은 필수입니다.")
    @Schema(description = "신고 컨텐츠 유형", example = "REVIEW", required = true)
    private ContentType contentType;

    @NotNull(message = "신고 유형은 필수입니다.")
    @Schema(description = "신고 유형", example = "SPAM", required = true)
    private ReportType reportType;

}