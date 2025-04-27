package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.dto.response.ReviewResponseDto;
import com.dingdong.eeum.dto.response.ScrollResponseDto;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReviewGetResultDto {
    @Schema(description = "장소 리뷰 목록")
    private ScrollResponseDto<ReviewResponseDto> reviews;
}
