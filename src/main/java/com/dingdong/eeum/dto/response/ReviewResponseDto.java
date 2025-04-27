package com.dingdong.eeum.dto.response;

import com.dingdong.eeum.model.Review;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Builder
@Getter
public class ReviewResponseDto {
    private String id;
    private String placeId;
    private String userId;
    private String userNickname;
    private String content;
    private int rating;
    private boolean isRecommended;
    private LocalDateTime createdAt;

    public static ReviewResponseDto toReviewResponseDto(Review review, String userNickname) {
        return ReviewResponseDto.builder()
                .id(review.getId())
                .placeId(review.getPlaceId())
                .userId(review.getUserId())
                .userNickname(userNickname)
                .content(review.getContent())
                .rating(review.getRating())
                .isRecommended(review.isRecommended())
                .createdAt(review.getCreatedAt())
                .build();
    }
}
