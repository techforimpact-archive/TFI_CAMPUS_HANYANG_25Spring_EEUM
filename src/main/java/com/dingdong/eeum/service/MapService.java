package com.dingdong.eeum.service;

import com.dingdong.eeum.dto.response.PlaceDetailResponseDto;
import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.dto.response.SearchResult;

public interface MapService {

    SearchResult findPlaces(PlaceSearchDto criteria);
    PlaceDetailResponseDto findPlaceById(String placeId);

}
