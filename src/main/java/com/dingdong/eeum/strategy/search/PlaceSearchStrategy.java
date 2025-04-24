package com.dingdong.eeum.strategy.search;

import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.dto.response.SearchResult;

public interface PlaceSearchStrategy<T> {
    SearchResult execute(PlaceSearchDto criteria);
}
