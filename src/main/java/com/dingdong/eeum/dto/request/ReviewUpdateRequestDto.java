package com.dingdong.eeum.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Size;
import lombok.Getter;

import java.util.Map;

@Getter
public class ReviewUpdateRequestDto {
    @Schema(description = "리뷰 내용", example = "이 장소는 매우 친절하고 좋았습니다.")
    @Size(max = 500, message = "리뷰 내용은 500자 이내로 작성해주세요.")
    private String content;

    @Schema(description = "평점 목록 (질문ID:평점)", example = "{\"service\":5, \"kindness\":4, \"facility\":4}")
    private Map<String, Integer> ratings;

    @Schema(description = "추천 여부", example = "true")
    private Boolean isRecommended;
}
