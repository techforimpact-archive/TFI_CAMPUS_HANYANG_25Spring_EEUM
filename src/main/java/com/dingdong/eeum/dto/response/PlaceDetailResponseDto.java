package com.dingdong.eeum.dto.response;

import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.constant.PlaceCategory;
import com.dingdong.eeum.constant.PlaceStatus;
import lombok.Builder;
import lombok.Getter;

import java.util.Collections;
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
    private String fullAddress;
    private List<PlaceCategory> categories;
    private List<String> imageUrls;
    private String description;
    private String phone;
    private String email;
    private String website;
    private double temperature;
    private long reviewCount;
    private PlaceStatus status;
    private boolean isFavorite;
    private boolean isVerified;

    public static PlaceDetailResponseDto toPlaceDetailResponseDto(Place place, List<String> imageUrls, boolean isFavorite) {
        return PlaceDetailResponseDto.builder()
                .id(place.getId())
                .name(place.getName())
                .longitude(place.getLocation() != null ? place.getLocation().getX() : null)
                .latitude(place.getLocation() != null ? place.getLocation().getY() : null)
                .province(place.getAddress() != null ? place.getAddress().getProvince() : null)
                .city(place.getAddress() != null ? place.getAddress().getCity() : null)
                .district(place.getAddress() != null ? place.getAddress().getDistrict() : null)
                .fullAddress(place.getAddress() != null ? place.getAddress().getFullAddress() : null)
                .categories(place.getCategories())
                .description(place.getDescription())
                .phone(place.getContact() != null ? place.getContact().getPhone() : null)
                .email(place.getContact() != null ? place.getContact().getEmail() : null)
                .website(place.getContact() != null ? place.getContact().getWebsite() : null)
                .imageUrls(imageUrls)
                .temperature(place.getReviewStats() != null ? place.getReviewStats().getTemperature() : null)
                .reviewCount(place.getReviewStats() != null ? place.getReviewStats().getCount() : 0)
                .status(place.getStatus())
                .isVerified(place.isVerified())
                .isFavorite(isFavorite)
                .build();
    }
}
