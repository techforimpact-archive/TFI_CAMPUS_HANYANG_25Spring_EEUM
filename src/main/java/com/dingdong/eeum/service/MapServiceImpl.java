
package com.dingdong.eeum.service;

import com.dingdong.eeum.apiPayload.code.status.ErrorStatus;
import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import com.dingdong.eeum.dto.request.FavoriteRequestDto;
import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.dto.response.*;
import com.dingdong.eeum.model.Favorite;
import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.repository.FavoriteRepository;
import com.dingdong.eeum.repository.PlaceRepository;
import com.dingdong.eeum.repository.ReviewRepository;
import com.dingdong.eeum.repository.UserRepository;
import com.dingdong.eeum.strategy.search.PlaceSearchStrategy;
import com.dingdong.eeum.strategy.search.PlaceSearchStrategyFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import static com.dingdong.eeum.apiPayload.code.status.ErrorStatus.*;

@Service
@RequiredArgsConstructor
public class MapServiceImpl implements MapService {
    private final UserRepository userRepository;
    private final FavoriteRepository favoriteRepository;
    private final PlaceRepository placeRepository;
    private final ReviewRepository reviewRepository;
    private final PlaceSearchStrategyFactory searchStrategyFactory;

    @Override
    public SearchResult findPlaces(PlaceSearchDto criteria, String userId) {
        PlaceSearchStrategy strategy = searchStrategyFactory.getStrategy(criteria.getMode());
        SearchResult searchResult = strategy.execute(criteria);
        return addFavoriteInfoToSearchResult(searchResult, userId);
    }

    @Override
    public PlaceDetailResponseDto findPlaceById(String placeId, String userId) {
        Optional<Place> optionalPlace = placeRepository.findById(placeId);

        Place place = optionalPlace.orElseThrow(() ->
                new ExceptionHandler(PLACE_NOT_FOUND));

        List<String> imageUrls = reviewRepository.findImageUrlsByPlaceId(placeId);

        boolean isFavorite = false;

        if (userId != null) {
            isFavorite = favoriteRepository.existsByUserIdAndPlaceId(userId, placeId);
        }

        return PlaceDetailResponseDto.toPlaceDetailResponseDto(place, imageUrls, isFavorite);
    }

    @Override
    @Transactional
    public MutualResponseDto addToFavorites(String userId, FavoriteRequestDto request) {
        String placeId = request.getPlaceId();

        if (!userRepository.existsById(userId)) {
            throw new ExceptionHandler(AUTH_USER_NOT_FOUND);
        }

        if (!placeRepository.existsById(placeId)) {
            throw new ExceptionHandler(PLACE_NOT_FOUND);
        }

        if (favoriteRepository.existsByUserIdAndPlaceId(userId, placeId)) {
            throw new ExceptionHandler(FAVORITE_ALREADY_EXISTS);
        }

        Favorite favorite = Favorite.builder()
                .userId(userId)
                .placeId(placeId)
                .createdAt(LocalDateTime.now())
                .build();

        favoriteRepository.save(favorite);

        return MutualResponseDto.builder()
                .status(true)
                .build();
    }

    @Override
    @Transactional
    public MutualResponseDto removeFromFavorites(String userId, String placeId) {
        if (!userRepository.existsById(userId)) {
            throw new ExceptionHandler(AUTH_USER_NOT_FOUND);
        }

        if (!favoriteRepository.existsByUserIdAndPlaceId(userId, placeId)) {
            throw new ExceptionHandler(FAVORITE_NOT_FOUND);
        }

        favoriteRepository.deleteByUserIdAndPlaceId(userId, placeId);

        return MutualResponseDto.builder().status(true).build();
    }

    private SearchResult addFavoriteInfoToSearchResult(SearchResult searchResult, String userId) {
        if (userId == null || searchResult == null) {
            return searchResult;
        }

        if (searchResult instanceof ScrollResponseDto<?>) {
            ScrollResponseDto<PlaceResponseDto> scrollResult = (ScrollResponseDto<PlaceResponseDto>) searchResult;
            List<PlaceResponseDto> places = scrollResult.getContents();

            if (places == null || places.isEmpty()) {
                return searchResult;
            }

            Set<String> placeIds = places.stream()
                    .map(PlaceResponseDto::getId)
                    .collect(Collectors.toSet());

            Set<String> favoriteIds = favoriteRepository.findByUserIdAndPlaceIdIn(userId, placeIds)
                    .stream()
                    .map(Favorite::getPlaceId)
                    .collect(Collectors.toSet());

            List<PlaceResponseDto> updatedPlaces = places.stream()
                    .map(place -> {
                        boolean isFavorite = favoriteIds.contains(place.getId());
                        place.setFavorite(isFavorite);
                        return place;
                    })
                    .collect(Collectors.toList());

            return new ScrollResponseDto<>(
                    updatedPlaces,
                    scrollResult.isHasNext(),
                    scrollResult.getNextCursor()
            );
        }

        return searchResult;
    }
}
