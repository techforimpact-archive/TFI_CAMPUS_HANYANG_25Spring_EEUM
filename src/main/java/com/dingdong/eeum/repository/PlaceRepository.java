package com.dingdong.eeum.repository;

import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.constant.PlaceCategory;
import com.dingdong.eeum.constant.PlaceStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Point;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import java.util.List;

public interface PlaceRepository extends MongoRepository<Place, String>, PlaceRepositoryCustom {

    List<Place> findByLocationNear(Point location, Distance distance);
    Page<Place> findByCategoriesAndStatus(List<PlaceCategory> category, PlaceStatus status, Pageable pageable);
    Page<Place> findByAddress_ProvinceAndAddress_CityAndAddress_DistrictAndStatus(
            String province, String city, String district, PlaceStatus status, Pageable pageable);
    Page<Place> findByReviewStats_TemperatureGreaterThanEqualAndStatus(
            double minTemperature, PlaceStatus status, Pageable pageable);
    @Query("{ $text: { $search: ?0 }, 'status': ?1 }")
    Page<Place> findByTextSearch(String keyword, PlaceStatus status, Pageable pageable);
}

interface PlaceRepositoryCustom {

    List<Place> findPlacesWithinBoundary(
            double minLongitude, double minLatitude,
            double maxLongitude, double maxLatitude,
            List<PlaceCategory> categories, PlaceStatus status);

    List<Place> findNearbyPlaces(
            double longitude, double latitude, double radius,
            List<PlaceCategory> categories, PlaceStatus status);
}
