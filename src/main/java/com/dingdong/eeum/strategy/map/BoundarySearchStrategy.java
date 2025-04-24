package com.dingdong.eeum.strategy.map;
import com.dingdong.eeum.constant.PlaceStatus;
import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.repository.PlaceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class BoundarySearchStrategy implements MapSearchSubStrategy {
    private final PlaceRepository placeRepository;

    @Override
    public boolean isApplicable(PlaceSearchDto criteria) {
        return (criteria.getLongitude() == null || criteria.getLatitude() == null) &&
                (criteria.getMinLongitude() != null || criteria.getMaxLongitude() != null ||
                        criteria.getMinLatitude() != null || criteria.getMaxLatitude() != null);
    }

    @Override
    public List<Place> search(PlaceSearchDto criteria) {
        double minLongitude = criteria.getMinLongitude() != null ? criteria.getMinLongitude() : 126.9;
        double minLatitude = criteria.getMinLatitude() != null ? criteria.getMinLatitude() : 37.4;
        double maxLongitude = criteria.getMaxLongitude() != null ? criteria.getMaxLongitude() : 127.1;
        double maxLatitude = criteria.getMaxLatitude() != null ? criteria.getMaxLatitude() : 37.6;

        PlaceStatus status = criteria.getStatus() != null ? criteria.getStatus() : PlaceStatus.ACTIVE;

        return placeRepository.findPlacesWithinBoundary(
                minLongitude, minLatitude,
                maxLongitude, maxLatitude,
                criteria.getCategories(), status);
    }
}
