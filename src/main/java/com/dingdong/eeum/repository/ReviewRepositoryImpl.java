package com.dingdong.eeum.repository;

import com.dingdong.eeum.model.Review;
import lombok.RequiredArgsConstructor;
import org.bson.types.ObjectId;
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

        if (cursor != null && !cursor.isEmpty()) {
            Review lastReview = mongoTemplate.findById(cursor, Review.class);
            if (lastReview != null) {
                Object cursorValue = getSortValue(lastReview, sortBy);

                if (sortDirection == Sort.Direction.DESC) {
                    query.addCriteria(new Criteria().orOperator(
                            Criteria.where(sortBy).lt(cursorValue),
                            Criteria.where(sortBy).is(cursorValue).and("_id").lt(new ObjectId(cursor))
                    ));
                } else {
                    query.addCriteria(new Criteria().orOperator(
                            Criteria.where(sortBy).gt(cursorValue),
                            Criteria.where(sortBy).is(cursorValue).and("_id").gt(new ObjectId(cursor))
                    ));
                }
            }
        }

        Sort sort = Sort.by(sortDirection, sortBy);
        if (!sortBy.equals("_id")) {
            sort = sort.and(Sort.by(sortDirection, "_id"));
        }
        query.with(sort);
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

    private Object getSortValue(Review review, String sortBy) {
        return switch (sortBy) {
            case "createdAt" -> review.getCreatedAt();
            case "rating" -> review.getRating();
            case "updatedAt" -> review.getUpdatedAt();
            default -> review.getId();
        };
    }
}
