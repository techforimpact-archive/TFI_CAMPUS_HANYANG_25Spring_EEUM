package com.dingdong.eeum.repository;

import com.dingdong.eeum.model.Review;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReviewRepository extends MongoRepository<Review, String>, ReviewRepositoryCustom {
    List<Review> findByPlaceId(String placeId);
    long countByPlaceId(String placeId);
    long countByPlaceIdAndIsRecommended(String placeId, boolean isRecommended);
}

interface ReviewRepositoryCustom {
    List<Review> findAllByPlaceId(
            String placeId,
            String cursor,
            int size,
            String sortBy,
            Sort.Direction sortDirection
    );
}


