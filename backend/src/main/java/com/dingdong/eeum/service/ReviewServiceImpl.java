package com.dingdong.eeum.service;

import com.dingdong.eeum.apiPayload.code.status.ErrorStatus;
import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import com.dingdong.eeum.aws.S3Service;
import com.dingdong.eeum.constant.ReportStatus;
import com.dingdong.eeum.dto.UserInfoDto;
import com.dingdong.eeum.dto.request.ReportRequestDto;
import com.dingdong.eeum.dto.request.ReviewCreateRequestDto;
import com.dingdong.eeum.dto.request.ReviewUpdateRequestDto;
import com.dingdong.eeum.dto.response.QuestionResponseDto;
import com.dingdong.eeum.dto.response.ReportResponseDto;
import com.dingdong.eeum.dto.response.ReviewResponseDto;
import com.dingdong.eeum.dto.response.ScrollResponseDto;
import com.dingdong.eeum.model.*;
import com.dingdong.eeum.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.*;
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
    private final UserRepository userRepository;
    private final ReportRepository reportRepository;

    private static final int MAX_REPORT_COUNT = 3;

    public ReviewResponseDto createReview(String placeId, ReviewCreateRequestDto requestDto, UserInfoDto userInfoDto) {

        checkUserReportCount(userInfoDto.getUserId());

        placeRepository.findById(placeId)
                .orElseThrow(() -> new ExceptionHandler(PLACE_NOT_FOUND));

        User user = userRepository.findById(userInfoDto.getUserId())
                .orElseThrow(() -> new ExceptionHandler(AUTH_USER_NOT_FOUND));

        int averageRating = calculateWeightedAverageRating(requestDto.getRatings());

        List<String> imageUrls = new ArrayList<>();
        if (requestDto.getImages() != null && !requestDto.getImages().isEmpty()) {
            List<MultipartFile> filesToUpload = requestDto.getImages();
            imageUrls = s3Service.uploadFiles(filesToUpload);
        }

        Review review = Review.builder()
                .placeId(placeId)
                .userId(userInfoDto.getUserId())
                .content(requestDto.getContent())
                .rating(averageRating)
                .imageUrls(imageUrls)
                .isRecommended(requestDto.isRecommended())
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        Review savedReview = reviewRepository.save(review);

        updatePlaceTemperature(placeId);

        return ReviewResponseDto.toReviewResponseDto(savedReview, user.getNickname());
    }

    private void checkUserReportCount(String userId) {
        List<Review> userReviews = reviewRepository.findByUserId(userId);

        if (userReviews.isEmpty()) {
            return;
        }

        List<String> reviewIds = userReviews.stream()
                .map(Review::getId)
                .collect(Collectors.toList());

        long reportCount = reportRepository.countByReviewIdIn(reviewIds);

        if (reportCount >= MAX_REPORT_COUNT) {
            throw new ExceptionHandler(ErrorStatus.REVIEW_CREATION_BLOCKED_DUE_TO_REPORTS);
        }
    }

    public ReviewResponseDto getReviewById(String reviewId) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new ExceptionHandler(REVIEW_NOT_FOUND));

        User user = userRepository.findById(review.getUserId())
                .orElseThrow(() -> new ExceptionHandler(AUTH_USER_NOT_FOUND));

        return ReviewResponseDto.toReviewResponseDto(review,user.getNickname());
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

        if (reviews.isEmpty()) {
            return new ScrollResponseDto<>(Collections.emptyList(), false, null);
        }

        Set<String> userIds = reviews.stream()
                .map(Review::getUserId)
                .collect(Collectors.toSet());

        Map<String, String> userNicknameMap = getUserNicknameMap(userIds);

        List<ReviewResponseDto> reviewDtos = reviews.stream()
                .map(review -> {
                    String userNickname = userNicknameMap.get(review.getUserId());

                    if (userNickname == null) {
                        userNickname = "Unknown";
                    }

                    return ReviewResponseDto.toReviewResponseDto(review, userNickname);
                })
                .collect(Collectors.toList());

        String nextCursor = hasNext && !reviews.isEmpty() ?
                reviews.get(reviews.size() - 1).getId() : null;

        return new ScrollResponseDto<>(reviewDtos, hasNext, nextCursor);
    }

    private Map<String, String> getUserNicknameMap(Set<String> userIds) {
        try {
            List<User> users = userRepository.findAllById(userIds);

            return users.stream()
                    .collect(Collectors.toMap(User::getId, User::getNickname));

        } catch (Exception e) {
            return Collections.emptyMap();
        }
    }

    public void deleteReview(String reviewId, UserInfoDto userInfoDto) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new ExceptionHandler(REVIEW_NOT_FOUND));

        if(!review.getUserId().equals(userInfoDto.getUserId())) throw new ExceptionHandler(REVIEW_DELETE_NOT_ALLOWED);

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

    @Override
    @Transactional
    public ReportResponseDto reportReview(String reviewId, ReportRequestDto request, UserInfoDto userInfo) {

        if (!reviewRepository.existsById(reviewId)) {
            throw new ExceptionHandler(ErrorStatus.REVIEW_NOT_FOUND);
        }

        if (reportRepository.existsByContentIdAndReporterId(reviewId, userInfo.getUserId())) {
            throw new ExceptionHandler(ErrorStatus.REPORT_ALREADY_EXISTS);
        }

        Report report = Report.builder()
                .contentId(reviewId)
                .contentType(request.getContentType())
                .reporterId(userInfo.getUserId())
                .reportType(request.getReportType())
                .status(ReportStatus.PENDING)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        Report savedReport = reportRepository.save(report);

        return ReportResponseDto.builder()
                .reportId(savedReport.getId())
                .contentId(savedReport.getContentId())
                .reportType(savedReport.getReportType())
                .reporterId(savedReport.getReporterId())
                .createdAt(savedReport.getCreatedAt())
                .build();
    }

}
