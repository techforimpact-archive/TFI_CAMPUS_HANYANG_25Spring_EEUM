package com.dingdong.eeum.service;

import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import com.dingdong.eeum.constant.UserRole;
import com.dingdong.eeum.constant.UserStatus;
import com.dingdong.eeum.dto.request.QrAuthRequestDto;
import com.dingdong.eeum.dto.response.*;
import com.dingdong.eeum.model.Favorite;
import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.model.Review;
import com.dingdong.eeum.model.User;
import com.dingdong.eeum.repository.FavoriteRepository;
import com.dingdong.eeum.repository.PlaceRepository;
import com.dingdong.eeum.repository.ReviewRepository;
import com.dingdong.eeum.repository.UserRepository;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.security.SignatureException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static com.dingdong.eeum.apiPayload.code.status.ErrorStatus.*;
import static com.dingdong.eeum.constant.UserRole.GUEST;
import static com.dingdong.eeum.constant.UserStatus.INACTIVE;

@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UserService{

    private final JwtService jwtService;
    private final UserRepository userRepository;
    private final PlaceRepository placeRepository;
    private final ReviewRepository reviewRepository;
    private final FavoriteRepository favoriteRepository;

    @Override
    public QrAuthResponseDto authenticateWithQr(QrAuthRequestDto qrAuthRequestDto, String id) {
        String qrToken = qrAuthRequestDto.getQrCode();

        if (qrToken == null || qrToken.trim().isEmpty()) {
            throw new ExceptionHandler(AUTH_TOKEN_EMPTY);
        }

        try {
            if (!jwtService.validateToken(qrToken)) {
                throw new ExceptionHandler(AUTH_TOKEN_INVALID);
            }

            User user = userRepository.findById(id)
                    .orElseThrow(() -> new ExceptionHandler(AUTH_USER_NOT_FOUND));

            if (user.getRole() != GUEST) {
                throw new ExceptionHandler(QR_AUTH_ALREADY_AUTHORIZED);
            } else {
                userRepository.updateRoleById(id, UserRole.USER, LocalDateTime.now());
            }

            return QrAuthResponseDto.builder()
                    .accessToken(jwtService.createAccessToken(id,UserRole.USER))
                    .build();

        } catch (ExpiredJwtException e) {
            throw new ExceptionHandler(AUTH_TOKEN_EXPIRED);
        } catch (MalformedJwtException e) {
            throw new ExceptionHandler(AUTH_TOKEN_MALFORMED);
        } catch (UnsupportedJwtException e) {
            throw new ExceptionHandler(AUTH_TOKEN_UNSUPPORTED);
        } catch (SignatureException e) {
            throw new ExceptionHandler(AUTH_TOKEN_SIGNATURE_INVALID);
        }
    }

    @Override
    public ScrollResponseDto<UserFavoriteResponseDto> getFavoritesByUserId(
            String userId, String cursor, int size, String sortBy, Sort.Direction sortDirection) {

        userRepository.findById(userId)
                .orElseThrow(() -> new ExceptionHandler(AUTH_USER_NOT_FOUND));

        if (size <= 0) size = 10;
        if (sortBy == null) sortBy = "createdAt";
        if (sortDirection == null) sortDirection = Sort.Direction.DESC;

        Sort sort = Sort.by(sortDirection, sortBy);

        List<Favorite> favorites = favoriteRepository.findAllByUserId(
                userId, cursor, size + 1, sort);

        boolean hasNext = favorites.size() > size;

        if (hasNext) {
            favorites = favorites.subList(0, size);
        }

        if (favorites.isEmpty()) {
            return new ScrollResponseDto<>(Collections.emptyList(), false, null);
        }

        Set<String> placeIds = favorites.stream()
                .map(Favorite::getPlaceId)
                .collect(Collectors.toSet());

        Map<String, Place> placeMap = getPlaceMap(placeIds);

        List<UserFavoriteResponseDto> favoriteDtos = favorites.stream()
                .map(favorite -> {
                    Place place = placeMap.get(favorite.getPlaceId());

                    if (place == null) {
                        return null;
                    }

                    return UserFavoriteResponseDto.toFavoriteResponseDto(favorite, place);
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        String nextCursor = hasNext && !favorites.isEmpty() ?
                favorites.get(favorites.size() - 1).getId() : null;

        return new ScrollResponseDto<>(favoriteDtos, hasNext, nextCursor);
    }

    private Map<String, Place> getPlaceMap(Set<String> placeIds) {
        List<Place> places = placeRepository.findAllById(placeIds);
        return places.stream()
                .collect(Collectors.toMap(Place::getId, place -> place));
    }

    @Override
    public ScrollResponseDto<UserReviewResponseDto> getReviewsByUserId(
            String userId, String cursor, int size, String sortBy, Sort.Direction sortDirection) {

        userRepository.findById(userId)
                .orElseThrow(() -> new ExceptionHandler(AUTH_USER_NOT_FOUND));

        if (size <= 0) size = 10;
        if (sortBy == null) sortBy = "createdAt";
        if (sortDirection == null) sortDirection = Sort.Direction.DESC;

        Sort sort = Sort.by(sortDirection, sortBy);

        List<Review> reviews = reviewRepository.findAllByUserId(
                userId, cursor, size + 1, sort);

        boolean hasNext = reviews.size() > size;

        if (hasNext) {
            reviews = reviews.subList(0, size);
        }

        if (reviews.isEmpty()) {
            return new ScrollResponseDto<>(Collections.emptyList(), false, null);
        }

        Set<String> placeIds = reviews.stream()
                .map(Review::getPlaceId)
                .collect(Collectors.toSet());

        Map<String, Place> placeMap = getPlaceMap(placeIds);

        List<UserReviewResponseDto> reviewDtos = reviews.stream()
                .map(review -> {
                    Place place = placeMap.get(review.getPlaceId());

                    if (place == null) {
                        return null;
                    }

                    return UserReviewResponseDto.toUserReviewResponseDto(review, place);
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        String nextCursor = hasNext && !reviews.isEmpty() ?
                reviews.get(reviews.size() - 1).getId() : null;

        return new ScrollResponseDto<>(reviewDtos, hasNext, nextCursor);
    }

    @Override
    public MutualResponseDto deactivateUser(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ExceptionHandler(AUTH_USER_NOT_FOUND));

        if (user.getStatus() == INACTIVE) {
            throw new ExceptionHandler(AUTH_USER_ALREADY_DEACTIVATED);
        }

        user.deactivate();
        userRepository.save(user);

        return MutualResponseDto.builder().status(true).build();
    }
}
