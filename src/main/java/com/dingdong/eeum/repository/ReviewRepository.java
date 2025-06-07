package com.dingdong.eeum.repository;

import com.dingdong.eeum.model.Review;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReviewRepository extends MongoRepository<Review, String>, ReviewRepositoryCustom {
    List<Review> findByPlaceId(String placeId);
    long countByPlaceId(String placeId);
    long countByPlaceIdAndIsRecommended(String placeId, boolean isRecommended);

    @Query("{'userId': ?0, $expr: {$cond: [{$ne: [?1, null]}, {$lt: ['$_id', {$toObjectId: ?1}]}, true]}}")
    List<Review> findAllByUserId(String userId, String cursor, int limit, Sort sort);

    List<Review> findByUserId(String userId);

}

interface ReviewRepositoryCustom {
    List<Review> findAllByPlaceId(
            String placeId,
            String cursor,
            int size,
            String sortBy,
            Sort.Direction sortDirection
    );

    List<String> findImageUrlsByPlaceId(String placeId);
}


