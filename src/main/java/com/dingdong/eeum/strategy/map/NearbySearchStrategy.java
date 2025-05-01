package com.dingdong.eeum.strategy.map;


import com.dingdong.eeum.apiPayload.code.status.ErrorStatus;
import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import com.dingdong.eeum.constant.PlaceStatus;
import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.repository.PlaceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class NearbySearchStrategy implements MapSearchSubStrategy {
    private final PlaceRepository placeRepository;

    @Override
    public boolean isApplicable(PlaceSearchDto criteria) {
        return criteria.getLongitude() != null && criteria.getLatitude() != null;
    }

    @Override
    public List<Place> search(PlaceSearchDto criteria) {
        if (criteria.getLongitude() == null || criteria.getLatitude() == null) {
            throw new ExceptionHandler(ErrorStatus.PLACE_COORDINATES_REQUIRED);
        }

        double radius = criteria.getRadius() != null ? criteria.getRadius() : 3000;
        PlaceStatus status = criteria.getStatus() != null ? criteria.getStatus() : PlaceStatus.ACTIVE;

        return placeRepository.findNearbyPlaces(
                criteria.getLongitude(), criteria.getLatitude(), radius,
                criteria.getCategories(), status);
    }
}
