package com.dingdong.eeum.controller;

import com.dingdong.eeum.annotation.User;
import com.dingdong.eeum.apiPayload.code.dto.ErrorReasonDTO;
import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.UserInfoDto;
import com.dingdong.eeum.dto.request.ReportRequestDto;
import com.dingdong.eeum.dto.request.ReviewUpdateRequestDto;
import com.dingdong.eeum.dto.response.QuestionResponseDto;
import com.dingdong.eeum.dto.response.ReportResponseDto;
import com.dingdong.eeum.dto.response.ReviewResponseDto;
import com.dingdong.eeum.dto.response.swagger.QuestionListResponse;
import com.dingdong.eeum.dto.response.swagger.ReportResponse;
import com.dingdong.eeum.service.ReviewService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
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
    public Response<Void> deleteReview(@PathVariable String reviewId, @User @Parameter(hidden = true) UserInfoDto userInfoDto) {
        reviewService.deleteReview(reviewId,userInfoDto);
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
                            schema = @Schema(implementation = QuestionListResponse.class)
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
        List<QuestionResponseDto> questions = reviewService.findDefaultQuestions();
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), questions);
    }

    @Operation(
            summary = "리뷰 신고",
            description = "부적절한 리뷰를 신고합니다."
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "리뷰 신고 성공",
                    content = @Content(
                            schema = @Schema(implementation = ReportResponse.class)
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
                    responseCode = "409",
                    description = "이미 신고한 리뷰",
                    content = @Content(
                            schema = @Schema(implementation = ErrorReasonDTO.class)
                    )
            ),
            @ApiResponse(
                    responseCode = "401",
                    description = "인증되지 않은 사용자",
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
    @PostMapping("/{reviewId}/report")
    public Response<ReportResponseDto> reportReview(
            @PathVariable String reviewId,
            @Valid @RequestBody ReportRequestDto request,
            @User @Parameter(hidden = true) UserInfoDto userInfoDto) {

        ReportResponseDto response = reviewService.reportReview(reviewId, request, userInfoDto);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }
}
