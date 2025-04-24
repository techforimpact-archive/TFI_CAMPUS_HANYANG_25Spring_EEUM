package com.dingdong.eeum.strategy.map;

import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.model.Place;

import java.util.List;

public interface MapSearchSubStrategy {
    boolean isApplicable(PlaceSearchDto criteria);
    List<Place> search(PlaceSearchDto criteria);
}
