package com.dingdong.eeum.strategy.search;

import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.strategy.map.MapSearchSubStrategy;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

import static com.dingdong.eeum.apiPayload.code.status.ErrorStatus._INTERNAL_SERVER_ERROR;

@Component
@RequiredArgsConstructor
public class MapSearchStrategyComposite {
    private final List<MapSearchSubStrategy> searchStrategies;

    public List<Place> executeSearch(PlaceSearchDto criteria) {
        for (MapSearchSubStrategy strategy : searchStrategies) {
            if (strategy.isApplicable(criteria)) {
                return strategy.search(criteria);
            }
        }

        throw new ExceptionHandler(_INTERNAL_SERVER_ERROR);
    }
}
