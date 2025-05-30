package com.dingdong.eeum.controller;

import com.dingdong.eeum.annotation.User;
import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.UserInfoDto;
import com.dingdong.eeum.dto.request.QrAuthRequestDto;
import com.dingdong.eeum.dto.response.UserFavoriteResponseDto;
import com.dingdong.eeum.dto.response.QrAuthResponseDto;
import com.dingdong.eeum.dto.response.ScrollResponseDto;
import com.dingdong.eeum.dto.response.UserReviewResponseDto;
import com.dingdong.eeum.dto.response.swagger.QrAuthResponse;
import com.dingdong.eeum.dto.response.swagger.UserFavoriteResponse;
import com.dingdong.eeum.dto.response.swagger.UserReviewResponse;
import com.dingdong.eeum.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/v1/user")
public class UserController {

    private final UserService userService;

    @PostMapping("/qr")
    @Operation(summary = "QR 코드 인증", description = "QR 코드를 통한 사용자 인증")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "QR 인증 성공",
                    content = @Content(schema = @Schema(implementation = QrAuthResponse.class))
            ),
            @ApiResponse(
                    responseCode = "401",
                    description = "유효하지 않은 QR Token",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "존재하지 않는 유저",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "409",
                    description = "이미 qr 인증된 유저",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    public Response<QrAuthResponseDto> authenticateWithQr(
            @Valid @RequestBody QrAuthRequestDto request, @User @Parameter(hidden = true) UserInfoDto userInfoDto) {

        QrAuthResponseDto response = userService.authenticateWithQr(request, userInfoDto.getUserId());

        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }

    @GetMapping("/favorites")
    @Operation(summary = "찜 목록 조회", description = "사용자의 찜한 장소 목록을 무한스크롤로 조회합니다")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "내 찜 목록 조회 성공",
                    content = @Content(schema = @Schema(implementation = UserFavoriteResponse.class))
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "존재하지 않는 사용자",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    public Response<ScrollResponseDto<UserFavoriteResponseDto>> getFavorites(
            @User @Parameter(hidden = true) UserInfoDto userInfoDto,
            @RequestParam(required = false) String cursor,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "DESC") Sort.Direction sortDirection) {

        ScrollResponseDto<UserFavoriteResponseDto> response = userService.getFavoritesByUserId(
                userInfoDto.getUserId(), cursor, size, sortBy, sortDirection);

        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }

    @GetMapping("/reviews")
    @Operation(summary = "내 리뷰 목록 조회", description = "사용자가 작성한 모든 리뷰를 무한스크롤로 조회합니다")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "리뷰 목록 조회 성공",
                    content = @Content(schema = @Schema(implementation = UserReviewResponse.class))
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "존재하지 않는 사용자",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    public Response<ScrollResponseDto<UserReviewResponseDto>> getMyReviews(
            @User @Parameter(hidden = true) UserInfoDto userInfoDto,
            @RequestParam(required = false) String cursor,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "DESC") Sort.Direction sortDirection) {

        ScrollResponseDto<UserReviewResponseDto> response = userService.getReviewsByUserId(
                userInfoDto.getUserId(), cursor, size, sortBy, sortDirection);

        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }
}
