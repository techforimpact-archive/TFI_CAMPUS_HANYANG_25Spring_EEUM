package com.dingdong.eeum.service;

import com.dingdong.eeum.dto.request.ReviewCreateRequestDto;
import com.dingdong.eeum.dto.request.ReviewUpdateRequestDto;
import com.dingdong.eeum.dto.response.QuestionResponseDto;
import com.dingdong.eeum.dto.response.ReviewResponseDto;
import com.dingdong.eeum.dto.response.ScrollResponseDto;
import org.springframework.data.domain.Sort;

import java.util.List;

public interface ReviewService {

    ReviewResponseDto createReview(String placeId, ReviewCreateRequestDto requestDto);

    ReviewResponseDto getReviewById(String reviewId);

    ScrollResponseDto<ReviewResponseDto> getReviewsByPlaceId(
            String placeId, String cursor, int size, String sortBy, Sort.Direction sortDirection);

    ReviewResponseDto updateReview(String reviewId, ReviewUpdateRequestDto requestDto);

    List<QuestionResponseDto> findDefaultQuestions();

    void deleteReview(String reviewId);

    void updatePlaceTemperature(String placeId);


}
