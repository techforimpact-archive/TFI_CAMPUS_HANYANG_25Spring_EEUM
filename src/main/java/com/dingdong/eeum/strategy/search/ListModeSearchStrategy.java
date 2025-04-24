package com.dingdong.eeum.strategy.search;

import com.dingdong.eeum.apiPayload.code.status.ErrorStatus;
import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import com.dingdong.eeum.constant.PlaceStatus;
import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.dto.response.PlaceResponseDto;
import com.dingdong.eeum.dto.response.ScrollResponseDto;
import com.dingdong.eeum.dto.response.SearchResult;
import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.repository.PlaceRepository;
import lombok.RequiredArgsConstructor;
import org.bson.types.ObjectId;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class ListModeSearchStrategy implements PlaceSearchStrategy {
    private final PlaceRepository placeRepository;
    private final MongoTemplate mongoTemplate;
    private final FieldValueExtractor fieldValueExtractor;

    @Override
    public SearchResult execute(PlaceSearchDto criteria) {
        if (criteria.getKeyword() != null && !criteria.getKeyword().trim().isEmpty()) {
            return executeKeywordSearch(criteria);
        } else {
            return executeStandardSearch(criteria);
        }
    }

    private ScrollResponseDto<PlaceResponseDto> executeStandardSearch(PlaceSearchDto criteria) {
        int size = criteria.getSize() > 0 ? criteria.getSize() : 10;
        String sortBy = criteria.getSortBy() != null ? criteria.getSortBy() : "reviewStats.temperature";
        Sort.Direction direction = criteria.getSortDirection() != null ? criteria.getSortDirection() : Sort.Direction.DESC;
        PlaceStatus status = criteria.getStatus() != null ? criteria.getStatus() : PlaceStatus.ACTIVE;

        Query query = new Query();
        buildLocationCriteria(query, criteria);
        buildCategoryCriteria(query, criteria);
        buildTemperatureCriteria(query, criteria);
        buildStatusCriteria(query, status);
        buildCursorPagination(query, criteria, sortBy, direction);

        query.with(Sort.by(direction, sortBy));
        query.limit(size + 1);

        return executeQuery(query, size);
    }

    private ScrollResponseDto<PlaceResponseDto> executeKeywordSearch(PlaceSearchDto criteria) {
        if (criteria.getKeyword() == null || criteria.getKeyword().trim().isEmpty()) {
            throw new ExceptionHandler(ErrorStatus.PLACE_SEARCH_KEYWORD_EMPTY);
        }

        int size = criteria.getSize() > 0 ? criteria.getSize() : 10;
        String sortBy = criteria.getSortBy() != null ? criteria.getSortBy() : "reviewStats.temperature";
        Sort.Direction direction = criteria.getSortDirection() != null ? criteria.getSortDirection() : Sort.Direction.DESC;
        PlaceStatus status = criteria.getStatus() != null ? criteria.getStatus() : PlaceStatus.ACTIVE;

        Query query = new Query();
        buildKeywordCriteria(query, criteria.getKeyword());
        buildCategoryCriteria(query, criteria);
        buildStatusCriteria(query, status);
        buildCursorPagination(query, criteria, sortBy, direction);

        query.with(Sort.by(direction, sortBy));
        query.limit(size + 1);

        return executeQuery(query, size);
    }

    private ScrollResponseDto<PlaceResponseDto> executeQuery(Query query, int size) {
        List<Place> places = mongoTemplate.find(query, Place.class);

        boolean hasNext = places.size() > size;
        if (hasNext) {
            places = places.subList(0, size);
        }

        List<PlaceResponseDto> responseList = places.stream()
                .map(PlaceResponseDto::toPlaceResponseDto)
                .collect(Collectors.toList());

        String nextCursor = places.isEmpty() ? null : places.get(places.size() - 1).getId();

        return new ScrollResponseDto<>(responseList, hasNext, nextCursor);
    }

    private void buildLocationCriteria(Query query, PlaceSearchDto criteria) {
        if (criteria.getProvince() != null && !criteria.getProvince().isEmpty()) {
            query.addCriteria(Criteria.where("address.province").is(criteria.getProvince()));
        }

        if (criteria.getCity() != null && !criteria.getCity().isEmpty()) {
            query.addCriteria(Criteria.where("address.city").is(criteria.getCity()));
        }

        if (criteria.getDistrict() != null && !criteria.getDistrict().isEmpty()) {
            query.addCriteria(Criteria.where("address.district").is(criteria.getDistrict()));
        }
    }

    private void buildCategoryCriteria(Query query, PlaceSearchDto criteria) {
        if (criteria.getCategories() != null && !criteria.getCategories().isEmpty()) {
            query.addCriteria(Criteria.where("categories").in(criteria.getCategories()));
        }
    }

    private void buildTemperatureCriteria(Query query, PlaceSearchDto criteria) {
        if (criteria.getMinTemperature() != null) {
            query.addCriteria(Criteria.where("reviewStats.temperature").gte(criteria.getMinTemperature()));
        }
    }

    private void buildStatusCriteria(Query query, PlaceStatus status) {
        query.addCriteria(Criteria.where("status").is(status));
    }

    private void buildKeywordCriteria(Query query, String keyword) {
        query.addCriteria(new Criteria().orOperator(
                Criteria.where("name").regex(keyword, "i"),
                Criteria.where("description").regex(keyword, "i")
        ));
    }

    private void buildCursorPagination(Query query, PlaceSearchDto criteria, String sortBy, Sort.Direction direction) {
        if (criteria.getLastId() != null && !criteria.getLastId().isEmpty()) {
            Place lastPlace = placeRepository.findById(criteria.getLastId()).orElse(null);

            if (lastPlace != null) {
                Object lastValue = fieldValueExtractor.getFieldValue(lastPlace, sortBy);

                if (lastValue != null) {
                    if (direction == Sort.Direction.DESC) {
                        query.addCriteria(Criteria.where(sortBy).lt(lastValue));
                    } else {
                        query.addCriteria(Criteria.where(sortBy).gt(lastValue));
                    }
                } else {
                    if (sortBy.equals("id") || sortBy.equals("_id")) {
                        if (direction == Sort.Direction.DESC) {
                            query.addCriteria(Criteria.where("_id").lt(new ObjectId(criteria.getLastId())));
                        } else {
                            query.addCriteria(Criteria.where("_id").gt(new ObjectId(criteria.getLastId())));
                        }
                    }
                }
            }
        }
    }
}
