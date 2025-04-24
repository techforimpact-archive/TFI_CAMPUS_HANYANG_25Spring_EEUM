package com.dingdong.eeum.dto.response;

import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.constant.PlaceCategory;
import com.dingdong.eeum.constant.PlaceStatus;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Builder
@Getter
public class PlaceDetailResponseDto {
    private String id;
    private String name;
    private double longitude;
    private double latitude;
    private String province;
    private String city;
    private String district;
    private List<PlaceCategory> categories;
    private String description;
    private String phone;
    private String email;
    private String website;
    private double temperature;
    private int reviewCount;
    private PlaceStatus status;
    private boolean isVerified;

    public static PlaceDetailResponseDto toPlaceDetailResponseDto(Place place) {
        return PlaceDetailResponseDto.builder()
                .id(place.getId())
                .name(place.getName())
                .longitude(place.getLocation().getX())
                .latitude(place.getLocation().getY())
                .province(place.getAddress().getProvince())
                .city(place.getAddress().getCity())
                .district(place.getAddress().getDistrict())
                .categories(place.getCategories())
                .description(place.getDescription())
                .phone(place.getContact().getPhone())
                .email(place.getContact().getEmail())
                .website(place.getContact().getWebsite())
                .temperature(place.getReviewStats().getTemperature())
                .reviewCount(place.getReviewStats().getCount())
                .status(place.getStatus())
                .isVerified(place.isVerified())
                .build();
    }
}
