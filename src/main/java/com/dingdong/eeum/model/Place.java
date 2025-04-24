package com.dingdong.eeum.model;

import com.dingdong.eeum.constant.PlaceCategory;
import com.dingdong.eeum.constant.PlaceStatus;
import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Document(collection = "places")
public class Place {
    @Id
    private String id;
    private String name;
    private GeoJsonPoint location;
    private Address address;
    private List<PlaceCategory> categories;
    private String description;
    private Contact contact;
    private List<BusinessHour> businessHours;
    private List<Image> images;
    private ReviewStats reviewStats;
    private List<String> tags;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isVerified;
    private PlaceStatus status;

    @Getter
    public static class Address {
        private String province;
        private String city;
        private String district;
        private String town;
        private String detail;
        private String zipCode;
    }

    @Getter
    public static class Contact {
        private String phone;
        private String email;
        private String website;
    }

    @Getter
    public static class BusinessHour {
        private String day;
        private String open;
        private String close;
    }

    @Getter
    public static class Image {
        private String url;
        private String caption;
        private boolean isPrimary;
    }

    @Getter
    public static class ReviewStats {
        private int count;
        private double temperature;
    }
}
