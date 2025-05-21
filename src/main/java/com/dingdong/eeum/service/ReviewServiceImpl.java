package com.dingdong.eeum.service;

import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import com.dingdong.eeum.aws.S3Service;
import com.dingdong.eeum.dto.request.ReviewCreateRequestDto;
import com.dingdong.eeum.dto.request.ReviewUpdateRequestDto;
import com.dingdong.eeum.dto.response.QuestionResponseDto;
import com.dingdong.eeum.dto.response.ReviewResponseDto;
import com.dingdong.eeum.dto.response.ScrollResponseDto;
import com.dingdong.eeum.model.Place;
import com.dingdong.eeum.model.Question;
import com.dingdong.eeum.model.Review;
import com.dingdong.eeum.repository.PlaceRepository;
import com.dingdong.eeum.repository.QuestionRepository;
import com.dingdong.eeum.repository.ReviewRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static com.dingdong.eeum.apiPayload.code.status.ErrorStatus.*;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {
    private final ReviewRepository reviewRepository;
    private final QuestionRepository questionRepository;
    private final PlaceRepository placeRepository;
    private final S3Service s3Service;
    private final MongoTemplate mongoTemplate;
    /* TODO 유저 로직 생성 후에 반영하기
        private final UserService userService;
    */

    public ReviewResponseDto createReview(String placeId, ReviewCreateRequestDto requestDto) {
        Place place = placeRepository.findById(placeId)
                .orElseThrow(() -> new ExceptionHandler(PLACE_NOT_FOUND));

        // TODO 추후 유저 로직 개발시 수정
        String userId = "680debb4dad30a632439e914";
        String userNickname = "에온";

        int averageRating = calculateWeightedAverageRating(requestDto.getRatings());

        List<String> imageUrls = new ArrayList<>();
        if (requestDto.getImages() != null && !requestDto.getImages().isEmpty()) {
            List<MultipartFile> filesToUpload = requestDto.getImages();
            imageUrls = s3Service.uploadFiles(filesToUpload);
        }

        Review review = Review.builder()
                .placeId(placeId)
                .userId(userId)
                .content(requestDto.getContent())
                .rating(averageRating)
                .imageUrls(imageUrls)
                .isRecommended(requestDto.isRecommended())
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        Review savedReview = reviewRepository.save(review);

        updatePlaceTemperature(placeId);

        return ReviewResponseDto.toReviewResponseDto(savedReview, userNickname);
    }

    public ReviewResponseDto getReviewById(String reviewId) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new ExceptionHandler(REVIEW_NOT_FOUND));

        // TODO 추후 유저 로직 개발시 수정
        String userNickname = "에온";

        return ReviewResponseDto.toReviewResponseDto(review, userNickname);
    }

    public ScrollResponseDto<ReviewResponseDto> getReviewsByPlaceId(
            String placeId, String cursor, int size, String sortBy, Sort.Direction sortDirection) {

        placeRepository.findById(placeId)
                .orElseThrow(() -> new ExceptionHandler(PLACE_NOT_FOUND));

        if (size <= 0) size = 10;
        if (sortBy == null) sortBy = "createdAt";
        if (sortDirection == null) sortDirection = Sort.Direction.DESC;

        List<Review> reviews = reviewRepository.findAllByPlaceId(
                placeId, cursor, size + 1, sortBy, sortDirection);

        boolean hasNext = reviews.size() > size;

        if (hasNext) {
            reviews = reviews.subList(0, size);
        }

        // TODO 추후 유저 로직 개발시 수정
        String userNickname = "에온";

        List<ReviewResponseDto> reviewDtos = reviews.stream()
                .map(review -> ReviewResponseDto.toReviewResponseDto(review, userNickname))
                .collect(Collectors.toList());

        String nextCursor = hasNext && !reviews.isEmpty() ? reviews.get(reviews.size() - 1).getId() : null;

        return new ScrollResponseDto<>(reviewDtos, hasNext, nextCursor);
    }

    public ReviewResponseDto updateReview(String reviewId, ReviewUpdateRequestDto requestDto) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new ExceptionHandler(REVIEW_NOT_FOUND));

        boolean previousRecommended = review.isRecommended();

        Map<String, Integer> newRatings = requestDto.getRatings();
        int averageRating = 0;
        if (newRatings != null && !newRatings.isEmpty()) {
            averageRating = (int) newRatings.values().stream()
                    .mapToInt(Integer::intValue)
                    .average()
                    .orElse(0.0);
        }

        Review updatedReview = Review.builder()
                .id(review.getId())
                .placeId(review.getPlaceId())
                .userId(review.getUserId())
                .content(requestDto.getContent())
                .rating(averageRating)
                .isRecommended(requestDto.getIsRecommended())
                .createdAt(review.getCreatedAt())
                .updatedAt(LocalDateTime.now())
                .build();

        Review savedReview = reviewRepository.save(updatedReview);

        if (previousRecommended != requestDto.getIsRecommended()) {
            updatePlaceTemperature(review.getPlaceId());
        }

        // TODO 추후 유저 로직 개발시 수정
        String userNickname = "에온";

        return ReviewResponseDto.toReviewResponseDto(savedReview, userNickname);
    }

    public void deleteReview(String reviewId) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new ExceptionHandler(REVIEW_NOT_FOUND));

        /* TODO 유저 로직 생성 후에 반영하기
            String currentUserId = userService.getCurrentUserId();
            if (!review.getUserId().equals(currentUserId)) {
                throw new IllegalStateException("리뷰를 삭제할 권한이 없습니다.");
            }
        */

        reviewRepository.delete(review);

        updatePlaceTemperature(review.getPlaceId());
    }

    /**
     * 장소의 온도 및 리뷰 통계 업데이트
     * 온도 변화 기준:
     * - 추천 2개 > 온도 1 상승
     * - 비추천 2개 > 온도 1 하락
     * - 1개의 리뷰에서 추천 + 20점 이상 > 온도 1 상승
     * - 1개의 리뷰에서 추천 + 15~19점 > 온도 0.5 상승
     * - 나머지는 온도에 영향 X
     * - 비추천 리뷰 2개 > 온도 1 하락
     */
    public void updatePlaceTemperature(String placeId) {
        long reviewCount = reviewRepository.countByPlaceId(placeId);
        long recommendCount = reviewRepository.countByPlaceIdAndIsRecommended(placeId, true);
        long notRecommendCount = reviewCount - recommendCount;

        double temperature = 36.5;

        temperature += ((double) recommendCount / 2);

        temperature -= ((double) notRecommendCount / 2);

        List<Review> reviews = reviewRepository.findByPlaceId(placeId);
        for (Review review : reviews) {
            if (review.isRecommended() && review.getRating() >= 4) {
                if (review.getRating() == 5) {
                    temperature += 1;
                } else {
                    temperature += 0.5;
                }
            }
        }

        temperature = Math.max(36.5, Math.min(40.0, temperature));

        Place.ReviewStats reviewStats = new Place.ReviewStats(reviewCount, temperature);

        Query query = new Query(Criteria.where("_id").is(placeId));
        Update update = new Update();
        update.set("reviewStats", reviewStats);

        mongoTemplate.updateFirst(query, update, Place.class);
    }

    private int calculateWeightedAverageRating(Map<String, Integer> ratings) {
        if (ratings == null || ratings.isEmpty()) {
            return 0;
        }

        double weightedSum = 0.0;
        double totalWeight = 0.0;

        for (Map.Entry<String, Integer> entry : ratings.entrySet()) {
            String questionId = entry.getKey();
            int rating = entry.getValue();

            Question question = questionRepository.findById(questionId)
                    .orElseThrow(() -> new ExceptionHandler(QUESTION_NOT_FOUND));
            double weight = question.getWeight();

            weightedSum += rating * weight;
            totalWeight += weight;
        }

        if (totalWeight == 0) {
            return 0;
        }

        return (int) Math.round(weightedSum / totalWeight);
    }

    public List<QuestionResponseDto> findDefaultQuestions() {
        List<Question> questions = questionRepository.findByIsDefaultTrue();
        return questions.stream()
                .map(question -> new QuestionResponseDto(question.getId(), question.getQuestion(), question.getDetail()))
                .collect(Collectors.toList());
    }

}
