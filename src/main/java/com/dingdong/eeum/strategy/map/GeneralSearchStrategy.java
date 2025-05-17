package com.dingdong.eeum.strategy.map;

import com.dingdong.eeum.constant.PlaceStatus;
import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.model.Place;
import lombok.RequiredArgsConstructor;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.util.List;

@Component
@RequiredArgsConstructor
public class GeneralSearchStrategy implements MapSearchSubStrategy {
    private final MongoTemplate mongoTemplate;

    @Override
    public boolean isApplicable(PlaceSearchDto criteria) {
        boolean hasCoordinateConditions =
                (criteria.getMinLongitude() != null && criteria.getMaxLongitude() != null &&
                        criteria.getMinLatitude() != null && criteria.getMaxLatitude() != null &&
                        criteria.getLongitude() != null && criteria.getLatitude() != null);

        return !hasCoordinateConditions;
    }

    @Override
    public List<Place> search(PlaceSearchDto criteria) {
        Query query = new Query();

        if (StringUtils.hasText(criteria.getName())) {
            query.addCriteria(Criteria.where("name").regex(criteria.getName(), "i"));
        }

        if (StringUtils.hasText(criteria.getKeyword())) {
            query.addCriteria(new Criteria().orOperator(
                    Criteria.where("name").regex(criteria.getKeyword(), "i"),
                    Criteria.where("description").regex(criteria.getKeyword(), "i")
            ));
        }

        if (StringUtils.hasText(criteria.getProvince())) {
            query.addCriteria(Criteria.where("address.province").is(criteria.getProvince()));
        }
        if (StringUtils.hasText(criteria.getCity())) {
            query.addCriteria(Criteria.where("address.city").is(criteria.getCity()));
        }
        if (StringUtils.hasText(criteria.getDistrict())) {
            query.addCriteria(Criteria.where("address.district").is(criteria.getDistrict()));
        }

        if (criteria.getCategories() != null && !criteria.getCategories().isEmpty()) {
            query.addCriteria(Criteria.where("categories").in(criteria.getCategories()));
        }

        if (criteria.getMinTemperature() != null) {
            query.addCriteria(Criteria.where("reviewStats.temperature").gte(criteria.getMinTemperature()));
        }

        PlaceStatus status = criteria.getStatus() != null ? criteria.getStatus() : PlaceStatus.ACTIVE;
        query.addCriteria(Criteria.where("status").is(status));

        if (criteria.getSize()==0) {
            query.limit(1000);
        } else {
            int limit = Math.min(criteria.getSize() > 0 ? criteria.getSize() : 100, 200);
            query.limit(limit);
        }

        return mongoTemplate.find(query, Place.class);
    }
}
