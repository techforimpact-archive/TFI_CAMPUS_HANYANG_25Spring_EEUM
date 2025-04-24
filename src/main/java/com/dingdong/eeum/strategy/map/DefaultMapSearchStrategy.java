package com.dingdong.eeum.strategy.map;

import com.dingdong.eeum.constant.PlaceStatus;
import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.repository.PlaceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class DefaultMapSearchStrategy implements MapSearchSubStrategy {
    private final PlaceRepository placeRepository;

    @Override
    public boolean isApplicable(PlaceSearchDto criteria) {
        return true;
    }

    @Override
    public List<Place> search(PlaceSearchDto criteria) {
        PlaceStatus status = criteria.getStatus() != null ? criteria.getStatus() : PlaceStatus.ACTIVE;
        Pageable pageable = PageRequest.of(0, 20, Sort.by(Sort.Direction.DESC, "reviewStats.temperature"));

        return placeRepository.findByCategoriesAndStatus(criteria.getCategories(), status, pageable).getContent();
    }
}
