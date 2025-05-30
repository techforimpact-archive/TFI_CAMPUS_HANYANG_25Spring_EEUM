package com.dingdong.eeum.service;

import com.dingdong.eeum.dto.request.FavoriteRequestDto;
import com.dingdong.eeum.dto.response.MutualResponseDto;
import com.dingdong.eeum.dto.response.PlaceDetailResponseDto;
import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.dto.response.SearchResult;

public interface MapService {

    SearchResult findPlaces(PlaceSearchDto criteria, String userId);
    PlaceDetailResponseDto findPlaceById(String placeId, String userId);
    MutualResponseDto addToFavorites(String userId, FavoriteRequestDto request);
    MutualResponseDto removeFromFavorites(String userId, String placeId);

}
