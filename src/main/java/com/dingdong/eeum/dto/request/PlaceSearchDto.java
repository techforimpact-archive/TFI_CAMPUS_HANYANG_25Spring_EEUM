package com.dingdong.eeum.dto.request;

import com.dingdong.eeum.constant.PlaceCategory;
import com.dingdong.eeum.constant.PlaceSearch;
import com.dingdong.eeum.constant.PlaceStatus;
import lombok.*;
import org.springframework.data.domain.Sort;

import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PlaceSearchDto {

    private PlaceSearch mode;

    private Double longitude;
    private Double latitude;
    private Double radius;
    private Double minLongitude;
    private Double minLatitude;
    private Double maxLongitude;
    private Double maxLatitude;

    private String name;
    private String province;
    private String city;
    private String district;
    private List<PlaceCategory> categories;
    private Double minTemperature;
    private PlaceStatus status;
    private String keyword;

    private String lastId;
    private int size;
    private String sortBy;
    private Sort.Direction sortDirection;
}
