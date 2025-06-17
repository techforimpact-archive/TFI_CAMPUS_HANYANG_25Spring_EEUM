package com.dingdong.eeum.strategy.search;

import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.dto.response.MapResponseDto;
import com.dingdong.eeum.dto.response.PlaceResponseDto;
import com.dingdong.eeum.dto.response.SearchResult;
import com.dingdong.eeum.model.Place;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class MapModeSearchStrategy implements PlaceSearchStrategy {
    private final MapSearchStrategyComposite mapSearchStrategyComposite;

    @Override
    public SearchResult<PlaceResponseDto> execute(PlaceSearchDto criteria) {
        List<Place> places = mapSearchStrategyComposite.executeSearch(criteria);

        List<PlaceResponseDto> results = places.stream()
                .map(PlaceResponseDto::toPlaceResponseDto)
                .collect(Collectors.toList());

        return new MapResponseDto<>(results);
    }
}
