package com.dingdong.eeum.strategy.search;

import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import com.dingdong.eeum.constant.PlaceSearch;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import static com.dingdong.eeum.apiPayload.code.status.ErrorStatus.INVALID_SEARCH_MODE;

@Component
@RequiredArgsConstructor
public class PlaceSearchStrategyFactory {
    private final MapModeSearchStrategy mapModeStrategy;
    private final ListModeSearchStrategy listModeStrategy;

    public PlaceSearchStrategy getStrategy(PlaceSearch mode) {
        if (mode == PlaceSearch.MAP) {
            return mapModeStrategy;
        } else if (mode == PlaceSearch.LIST) {
            return listModeStrategy;
        } else {
            throw new ExceptionHandler(INVALID_SEARCH_MODE);
        }
    }
}
