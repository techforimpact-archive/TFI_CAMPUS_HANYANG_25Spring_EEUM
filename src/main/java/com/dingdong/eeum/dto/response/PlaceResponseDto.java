package com.dingdong.eeum.dto.response;

import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.constant.PlaceCategory;
import com.dingdong.eeum.constant.PlaceStatus;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Builder
@Getter
public class PlaceResponseDto {
    private String id;
    private String name;
    private double longitude;
    private double latitude;
    private String province;
    private String city;
    private String district;
    private List<PlaceCategory> categories;
    private double temperature;
    private PlaceStatus status;
    private boolean isVerified;

    public static PlaceResponseDto toPlaceResponseDto(Place place) {
        return PlaceResponseDto.builder()
                .id(place.getId())
                .name(place.getName())
                .longitude(place.getLocation().getX())
                .latitude(place.getLocation().getY())
                .province(place.getAddress().getProvince())
                .city(place.getAddress().getCity())
                .district(place.getAddress().getDistrict())
                .categories(place.getCategories())
                .temperature(place.getReviewStats().getTemperature())
                .status(place.getStatus())
                .isVerified(place.isVerified())
                .build();
    }
}
