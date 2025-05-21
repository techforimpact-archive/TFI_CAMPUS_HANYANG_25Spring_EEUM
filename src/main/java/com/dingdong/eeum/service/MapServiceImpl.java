
package com.dingdong.eeum.service;

import com.dingdong.eeum.apiPayload.code.status.ErrorStatus;
import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.dto.response.PlaceDetailResponseDto;
import com.dingdong.eeum.dto.response.SearchResult;
import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.repository.PlaceRepository;
import com.dingdong.eeum.repository.ReviewRepository;
import com.dingdong.eeum.strategy.search.PlaceSearchStrategy;
import com.dingdong.eeum.strategy.search.PlaceSearchStrategyFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MapServiceImpl implements MapService {
    private final PlaceRepository placeRepository;
    private final ReviewRepository reviewRepository;
    private final PlaceSearchStrategyFactory searchStrategyFactory;

    @Override
    public SearchResult findPlaces(PlaceSearchDto criteria) {
        PlaceSearchStrategy strategy = searchStrategyFactory.getStrategy(criteria.getMode());
        return strategy.execute(criteria);
    }

    @Override
    public PlaceDetailResponseDto findPlaceById(String placeId) {
        Optional<Place> optionalPlace = placeRepository.findById(placeId);

        Place place = optionalPlace.orElseThrow(() ->
                new ExceptionHandler(ErrorStatus.PLACE_NOT_FOUND));

        List<String> imageUrls = reviewRepository.findImageUrlsByPlaceId(placeId);

        return PlaceDetailResponseDto.toPlaceDetailResponseDto(place,imageUrls);
    }
}
