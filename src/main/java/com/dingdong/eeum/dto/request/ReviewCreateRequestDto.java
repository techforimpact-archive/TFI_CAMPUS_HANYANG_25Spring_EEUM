package com.dingdong.eeum.dto.request;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Getter
@Setter
public class ReviewCreateRequestDto {
    private static final ObjectMapper objectMapper = new ObjectMapper();

    @Schema(description = "리뷰 내용", example = "이 장소는 매우 친절하고 좋았습니다.")
    @NotBlank(message = "리뷰 내용은 필수입니다.")
    @Size(max = 500, message = "리뷰 내용은 500자 이내로 작성해주세요.")
    private String content;

    @Schema(description = "평점 목록 (질문ID:평점) - JSON 문자열", example = "{\"680df9895e643770c31e8dfa\":5, \"680df9895e643770c31e8dfb\":4}")
    private String ratingsJson;

    @JsonIgnore
    @Schema(hidden = true)
    private Map<String, Integer> ratings;

    @Schema(description = "리뷰 이미지 (최대 5개)")
    @Size(max = 5, message = "이미지는 최대 5개까지 업로드할 수 있습니다")
    private List<MultipartFile> images;

    @Schema(description = "추천 여부", example = "true")
    private boolean isRecommended;

    public Map<String, Integer> getRatings() {
        if (this.ratings == null && this.ratingsJson != null && !this.ratingsJson.isEmpty()) {
            try {
                this.ratings = objectMapper.readValue(this.ratingsJson, new TypeReference<Map<String, Integer>>() {});
            } catch (JsonProcessingException e) {
                this.ratings = new HashMap<>();
            }
        }
        return this.ratings;
    }
}
