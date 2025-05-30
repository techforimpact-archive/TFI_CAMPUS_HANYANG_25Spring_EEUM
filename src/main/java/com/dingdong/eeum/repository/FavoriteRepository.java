package com.dingdong.eeum.repository;

import com.dingdong.eeum.model.Favorite;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Repository
public interface FavoriteRepository extends MongoRepository<Favorite, String> {
    Optional<Favorite> findByUserIdAndPlaceId(String userId, String placeId);
    List<Favorite> findByUserId(String userId);
    void deleteByUserIdAndPlaceId(String userId, String placeId);
    boolean existsByUserIdAndPlaceId(String userId, String placeId);
    List<Favorite> findByUserIdAndPlaceIdIn(String userId, Set<String> placeIds);

    @Query("{'userId': ?0, $expr: {$cond: [{$ne: [?1, null]}, {$lt: ['$_id', {$toObjectId: ?1}]}, true]}}")
    List<Favorite> findAllByUserId(String userId, String cursor, int limit, Sort sort);
}
