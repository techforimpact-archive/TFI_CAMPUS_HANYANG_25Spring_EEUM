package com.dingdong.eeum.dto.response;

import com.dingdong.eeum.constant.PlaceCategory;
import com.dingdong.eeum.model.Favorite;
import com.dingdong.eeum.model.Place;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.util.List;
import java.util.stream.Collectors;

@Getter
@Builder
@AllArgsConstructor
public class UserFavoriteResponseDto {
    @Schema(description = "찜 ID", example = "fav123")
    private String favoriteId;

    @Schema(description = "장소 ID", example = "place123")
    private String placeId;

    @Schema(description = "장소명", example = "맛있는 식당")
    private String placeName;

    @Schema(description = "장소 카테고리")
    private List<PlaceCategory> categories;

    @Schema(description = "주소", example = "서울시 강남구...")
    private String address;

    public static UserFavoriteResponseDto toFavoriteResponseDto(Favorite favorite, Place place) {
        return UserFavoriteResponseDto.builder()
                .favoriteId(favorite.getId())
                .placeId(place.getId())
                .placeName(place.getName())
                .categories(place.getCategories())
                .address(place.getAddress().getFullAddress())
                .build();
    }
}
