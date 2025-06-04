package com.dingdong.eeum.dto.response;

import com.dingdong.eeum.constant.PlaceCategory;
import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.model.Review;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Builder
@AllArgsConstructor
public class UserReviewResponseDto {
    @Schema(description = "리뷰 ID", example = "review123")
    private String reviewId;

    @Schema(description = "장소 ID", example = "place123")
    private String placeId;

    @Schema(description = "장소명", example = "맛있는 식당")
    private String placeName;

    @Schema(description = "장소 카테고리")
    private List<PlaceCategory> placeCategories;

    @Schema(description = "장소 주소", example = "서울시 강남구...")
    private String placeAddress;

    @Schema(description = "리뷰 내용", example = "정말 맛있었어요!")
    private String content;

    @Schema(description = "리뷰 작성일")
    private LocalDateTime createdAt;

    @Schema(description = "리뷰 수정일")
    private LocalDateTime updatedAt;

    public static UserReviewResponseDto toUserReviewResponseDto(Review review, Place place) {
        return UserReviewResponseDto.builder()
                .reviewId(review.getId())
                .placeId(place.getId())
                .placeName(place.getName())
                .placeAddress(place.getAddress().getFullAddress())
                .content(review.getContent())
                .placeCategories(place.getCategories())
                .createdAt(review.getCreatedAt())
                .updatedAt(review.getUpdatedAt())
                .build();
    }
}
