package com.dingdong.eeum.controller;

import com.dingdong.eeum.apiPayload.code.dto.ErrorReasonDTO;
import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.request.ReviewUpdateRequestDto;
import com.dingdong.eeum.dto.response.QuestionResponseDto;
import com.dingdong.eeum.dto.response.ReviewResponseDto;
import com.dingdong.eeum.dto.response.swagger.QuestionResultDto;
import com.dingdong.eeum.service.ReviewService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/v1/reviews")
@Tag(name = "리뷰 API", description = "리뷰 관련 API")
public class ReviewController {
    private final ReviewService reviewService;

    @Operation(
            summary = "리뷰 조회",
            description = "특정 리뷰를 조회합니다."
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "리뷰 조회 성공",
                    content = @Content(
                            schema = @Schema(implementation = ReviewResponseDto.class)
                    )
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "리뷰를 찾을 수 없음",
                    content = @Content(
                            schema = @Schema(implementation = ErrorReasonDTO.class)
                    )
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(
                            schema = @Schema(implementation = ErrorReasonDTO.class)
                    )
            )
    })
    @GetMapping("/{reviewId}")
    public Response<ReviewResponseDto> getReview(@PathVariable String reviewId) {
        ReviewResponseDto review = reviewService.getReviewById(reviewId);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), review);
    }


    @Operation(
            summary = "리뷰 수정",
            description = "리뷰를 수정합니다."
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "리뷰 수정 성공",
                    content = @Content(
                            schema = @Schema(implementation = ReviewResponseDto.class)
                    )
            ),
            @ApiResponse(
                    responseCode = "400",
                    description = "잘못된 요청",
                    content = @Content(
                            schema = @Schema(implementation = ErrorReasonDTO.class)
                    )
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "리뷰를 찾을 수 없음",
                    content = @Content(
                            schema = @Schema(implementation = ErrorReasonDTO.class)
                    )
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(
                            schema = @Schema(implementation = ErrorReasonDTO.class)
                    )
            )
    })
    @PutMapping("/{reviewId}")
    public Response<ReviewResponseDto> updateReview(
            @PathVariable String reviewId,
            @RequestBody ReviewUpdateRequestDto requestDto) {
        ReviewResponseDto review = reviewService.updateReview(reviewId, requestDto);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), review);
    }

    @Operation(
            summary = "리뷰 삭제",
            description = "리뷰를 삭제합니다."
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "리뷰 삭제 성공"
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "리뷰를 찾을 수 없음",
                    content = @Content(
                            schema = @Schema(implementation = ErrorReasonDTO.class)
                    )
            ),
            @ApiResponse(
                    responseCode = "403",
                    description = "권한 없음",
                    content = @Content(
                            schema = @Schema(implementation = ErrorReasonDTO.class)
                    )
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(
                            schema = @Schema(implementation = ErrorReasonDTO.class)
                    )
            )
    })
    @DeleteMapping("/{reviewId}")
    public Response<Void> deleteReview(@PathVariable String reviewId) {
        reviewService.deleteReview(reviewId);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), null);
    }

    @Operation(
            summary = "모든 질문 조회",
            description = "리뷰 작성시 표시할 모든 기본 질문을 조회합니다."
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "질문 조회 성공",
                    content = @Content(
                            schema = @Schema(implementation = QuestionResultDto.class)
                    )
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(
                            schema = @Schema(implementation = ErrorReasonDTO.class)
                    )
            )
    })
    @GetMapping("/questions")
    public Response<List<QuestionResponseDto>> getDefaultQuestions() {
        List<QuestionResponseDto> review = reviewService.findDefaultQuestions();
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), review);
    }
}
