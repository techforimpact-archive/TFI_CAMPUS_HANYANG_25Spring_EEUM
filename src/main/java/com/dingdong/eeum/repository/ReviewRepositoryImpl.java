package com.dingdong.eeum.repository;

import com.dingdong.eeum.model.Review;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.AggregationResults;
import org.springframework.data.mongodb.core.aggregation.ProjectionOperation;
import org.springframework.data.mongodb.core.aggregation.UnwindOperation;
import org.bson.Document;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Repository
@RequiredArgsConstructor
public class ReviewRepositoryImpl implements ReviewRepositoryCustom {
    private final MongoTemplate mongoTemplate;

    @Override
    public List<Review> findAllByPlaceId(
            String placeId,
            String cursor,
            int size,
            String sortBy,
            Sort.Direction sortDirection) {

        Query query = new Query(Criteria.where("placeId").is(placeId));

        if (cursor != null) {
            Review lastReview = mongoTemplate.findById(cursor, Review.class);
            if (lastReview != null) {
                Object cursorValue;

                switch (sortBy) {
                    case "createdAt":
                        cursorValue = lastReview.getCreatedAt();
                        break;
                    case "rating":
                        cursorValue = lastReview.getRating();
                        break;
                    default:
                        cursorValue = lastReview.getId();
                        sortBy = "_id";
                        break;
                }

                if (sortDirection == Sort.Direction.DESC) {
                    query.addCriteria(Criteria.where(sortBy).lt(cursorValue));
                } else {
                    query.addCriteria(Criteria.where(sortBy).gt(cursorValue));
                }
            }
        }

        query.with(Sort.by(sortDirection, sortBy));
        query.limit(size);

        return mongoTemplate.find(query, Review.class);
    }

    @Override
    public List<String> findImageUrlsByPlaceId(String placeId) {
        Criteria criteria = Criteria.where("placeId").is(placeId);

        ProjectionOperation projection = Aggregation.project().andExclude("_id")
                .and("imageUrls").as("imageUrls");
        UnwindOperation unwind = Aggregation.unwind("imageUrls");

        Aggregation aggregation = Aggregation.newAggregation(
                Aggregation.match(criteria),
                projection,
                unwind
        );

        AggregationResults<Document> results = mongoTemplate.aggregate(
                aggregation, "reviews", Document.class);

        return results.getMappedResults().stream()
                .map(doc -> doc.getString("imageUrls"))
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }
}
