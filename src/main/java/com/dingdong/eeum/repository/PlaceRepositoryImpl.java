package com.dingdong.eeum.repository;

import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.constant.PlaceStatus;
import com.dingdong.eeum.constant.PlaceCategory;
import org.springframework.data.geo.Box;
import org.springframework.data.geo.Point;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.AggregationOperation;
import org.springframework.data.mongodb.core.aggregation.AggregationResults;
import org.springframework.data.mongodb.core.aggregation.TypedAggregation;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.NearQuery;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class PlaceRepositoryImpl implements PlaceRepositoryCustom {

    private final MongoTemplate mongoTemplate;

    public PlaceRepositoryImpl(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    @Override
    public List<Place> findPlacesWithinBoundary(
            double minLongitude, double minLatitude,
            double maxLongitude, double maxLatitude,
            List<PlaceCategory> categories, PlaceStatus status) {

        Query query = new Query();

        query.addCriteria(Criteria.where("location")
                .within(
                        new Box(
                                new Point(minLongitude, minLatitude),
                                new Point(maxLongitude, maxLatitude)
                        )
                ));

        if (categories != null && !categories.isEmpty()) {
            query.addCriteria(Criteria.where("categories").in(categories));
        }

        query.addCriteria(Criteria.where("status").is(status != null ? status : PlaceStatus.ACTIVE));

        return mongoTemplate.find(query, Place.class);
    }

    @Override
    public List<Place> findNearbyPlaces(
            double longitude, double latitude, double radius,
            List<PlaceCategory> categories, PlaceStatus status) {

        NearQuery nearQuery = NearQuery.near(new Point(longitude, latitude))
                .maxDistance(radius / 1000.0)
                .spherical(true);

        Criteria criteria = new Criteria().and("status").is(status != null ? status : PlaceStatus.ACTIVE);

        if (categories != null && !categories.isEmpty()) {
            criteria = criteria.and("categories").in(categories);
        }

        List<AggregationOperation> operations = new ArrayList<>();
        operations.add(Aggregation.geoNear(nearQuery, "distance"));
        operations.add(Aggregation.match(criteria));

        TypedAggregation<Place> aggregation = Aggregation.newAggregation(Place.class, operations);
        AggregationResults<Place> results = mongoTemplate.aggregate(aggregation, Place.class);

        return results.getMappedResults();
    }


}
