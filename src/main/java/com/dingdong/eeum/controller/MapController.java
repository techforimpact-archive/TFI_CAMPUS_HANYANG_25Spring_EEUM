package com.dingdong.eeum.controller;

import com.dingdong.eeum.annotation.User;
import com.dingdong.eeum.apiPayload.code.dto.ErrorReasonDTO;
import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.constant.PlaceCategory;
import com.dingdong.eeum.constant.PlaceSearch;
import com.dingdong.eeum.constant.PlaceStatus;
import com.dingdong.eeum.dto.UserInfoDto;
import com.dingdong.eeum.dto.request.FavoriteRequestDto;
import com.dingdong.eeum.dto.request.PlaceSearchDto;
import com.dingdong.eeum.dto.request.ReviewCreateRequestDto;
import com.dingdong.eeum.dto.response.*;
import com.dingdong.eeum.dto.response.swagger.ListSearchResponse;
import com.dingdong.eeum.dto.response.swagger.MapSearchResponse;
import com.dingdong.eeum.dto.response.swagger.MutualResponse;
import com.dingdong.eeum.dto.response.swagger.ReviewGetResponse;
import com.dingdong.eeum.service.MapService;
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
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Sort;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/v1/places")
@Tag(name = "장소 API", description = "장소 조회 관련 API")
public class MapController {
    private final MapService mapService;
    private final ReviewService reviewService;

    @Operation(
            summary = "장소 검색",
            description = "MAP 모드 또는 LIST 모드로 장소를 검색합니다. 지도 경계 또는 반경 내 장소를 검색하고, LIST 모드는 무한 스크롤을 지원합니다."
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "장소 검색 성공",
                    content = {
                            @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(
                                            oneOf = {
                                                    MapSearchResponse.class,
                                                    ListSearchResponse.class
                                            }
                                    )
                            )
                    }
            ),
            @ApiResponse(
                    responseCode = "400",
                    description = "잘못된 요청",
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
    @GetMapping("/")
    public Response<?> getPlaces(
            @Parameter(description = "검색 모드 (MAP: 지도 모드, LIST: 목록 모드)", example = "MAP", required = true)
            @RequestParam PlaceSearch mode,

            @Parameter(description = "장소 이름 검색어", example = "마음")
            @RequestParam(required = false) String name,

            @Parameter(description = "지도 경계 최소 경도값 (경계 검색 전용)", example = "126.9850")
            @RequestParam(required = false) Double minLongitude,
            @Parameter(description = "지도 경계 최소 위도값 (경계 검색 전용)", example = "37.4500")
            @RequestParam(required = false) Double minLatitude,
            @Parameter(description = "지도 경계 최대 경도값 (경계 검색 전용)", example = "127.1150")
            @RequestParam(required = false) Double maxLongitude,
            @Parameter(description = "지도 경계 최대 위도값 (경계 검색 전용)", example = "37.5500")

            @RequestParam(required = false) Double maxLatitude,
            @Parameter(description = "현재 위치 경도 (주변 검색 전용)", example = "127.0291")
            @RequestParam(required = false) Double longitude,
            @Parameter(description = "현재 위치 위도 (주변 검색 전용)", example = "37.4980")
            @RequestParam(required = false) Double latitude,
            @Parameter(description = "검색 반경 (미터 단위) (주변 검색 전용)", example = "1000")
            @RequestParam(required = false) Double radius,

            @Parameter(description = "카테고리 필터", example = "[\"COUNSELING\", \"HOSPITAL\"]")
            @RequestParam(required = false) List<PlaceCategory> categories,
            @Parameter(description = "장소 상태 필터", example = "ACTIVE")
            @RequestParam(required = false) PlaceStatus status,
            @Parameter(description = "행정구역(도/시)", example = "서울특별시")
            @RequestParam(required = false) String province,
            @Parameter(description = "행정구역(시/군/구)", example = "강남구")
            @RequestParam(required = false) String city,
            @Parameter(description = "행정구역(동/읍/면)", example = "삼성동")
            @RequestParam(required = false) String district,
            @Parameter(description = "최소 온도", example = "36.5")
            @RequestParam(required = false) Double minTemperature,
            @Parameter(description = "검색 키워드", example = "상담소")
            @RequestParam(required = false) String keyword,

            @Parameter(description = "마지막 아이템 ID (LIST 모드 전용)", example = "60a7b1e7c0b6a82e9c1f2a3b")
            @RequestParam(required = false) String lastId,
            @Parameter(description = "페이지 크기 (LIST 모드 전용)", example = "10")
            @RequestParam(required = false, defaultValue = "0") int size,
            @Parameter(description = "정렬 기준 (LIST 모드 전용)", example = "reviewStats.temperature")
            @RequestParam(required = false) String sortBy,
            @Parameter(description = "정렬 방향 (LIST 모드 전용)", example = "DESC")
            @RequestParam(required = false) Sort.Direction sortDirection,
    @User @Parameter(hidden=true) UserInfoDto userInfoDto) {

        PlaceSearchDto criteria = PlaceSearchDto.builder()
                .mode(mode)
                .name(name)
                .minLongitude(minLongitude)
                .minLatitude(minLatitude)
                .maxLongitude(maxLongitude)
                .maxLatitude(maxLatitude)
                .longitude(longitude)
                .latitude(latitude)
                .radius(radius)
                .categories(categories)
                .status(status)
                .province(province)
                .city(city)
                .district(district)
                .minTemperature(minTemperature)
                .keyword(keyword)
                .lastId(lastId)
                .size(size)
                .sortBy(sortBy)
                .sortDirection(sortDirection)
                .build();

        SearchResult result = mapService.findPlaces(criteria, userInfoDto.getUserId());

        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), result);
    }

    @Operation(
            summary = "장소 상세 조회",
            description = "특정 장소의 상세 정보를 조회합니다."
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "장소 상세 조회 성공",
                    content = @Content(
                            schema = @Schema(implementation = PlaceDetailResponseDto.class)
                    )
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "장소를 찾을 수 없음",
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
    @GetMapping("/{placeId}")
    public Response<PlaceDetailResponseDto> getPlaceById(@PathVariable String placeId, @User @Parameter(hidden = true) UserInfoDto userInfoDto) {
        PlaceDetailResponseDto place = mapService.findPlaceById(placeId, userInfoDto.getUserId());
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), place);
    }

    @Operation(
            summary = "모든 리뷰 조회",
            description = "장소 리뷰를 무한 스크롤로 조회합니다."
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "리뷰 목록 조회 성공",
                    content = @Content(
                            schema = @Schema(implementation = ReviewGetResponse.class)
                    )
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "장소를 찾을 수 없음",
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
    @GetMapping("/{placeId}/reviews")
    public Response<ScrollResponseDto<ReviewResponseDto>> getReviews(
            @Parameter(description = "장소 id", example = "60a7b1e7c0b6a82e9c1f2a3b")
            @PathVariable String placeId,
            @Parameter(description = "마지막 아이템 ID", example = "60a7b1e7c0b6a82e9c1f2a3b")
            @RequestParam(required = false) String lastId,
            @Parameter(description = "페이지 크기", example = "10")
            @RequestParam(required = false, defaultValue = "10") int size,
            @Parameter(description = "정렬 기준", example = "temperature")
            @RequestParam(required = false) String sortBy,
            @Parameter(description = "정렬 방향", example = "DESC")
            @RequestParam(required = false) Sort.Direction sortDirection
    ) {
        ScrollResponseDto<ReviewResponseDto> reviews = reviewService.getReviewsByPlaceId(placeId, lastId, size, sortBy, sortDirection);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), reviews);
    }

    @Operation(
            summary = "리뷰 생성",
            description = "장소에 대한 리뷰를 생성합니다."
    )
    @PostMapping(value = "/{placeId}/reviews", consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public Response<ReviewResponseDto> createReview(
            @PathVariable String placeId,
            @Valid @ModelAttribute ReviewCreateRequestDto requestDto, @User @Parameter(hidden = true) UserInfoDto userInfoDto) {
        ReviewResponseDto review = reviewService.createReview(placeId, requestDto, userInfoDto);
        return new Response<>(true, SuccessStatus._CREATED.getCode(), SuccessStatus._CREATED.getMessage(), review);
    }

    @PostMapping("/favorites")
    @Operation(summary = "장소 찜하기", description = "특정 장소를 찜 목록에 추가합니다")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "찜하기 성공",
                    content = @Content(schema = @Schema(implementation = MutualResponse.class))
            ),
            @ApiResponse(
                    responseCode = "400",
                    description = "잘못된 요청",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "존재하지 않는 사용자 또는 장소",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "409",
                    description = "이미 찜한 장소",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    public Response<MutualResponseDto> addToFavorites(
            @Valid @RequestBody FavoriteRequestDto request, @User @Parameter(hidden = true) UserInfoDto userInfoDto) {

        MutualResponseDto response = mapService.addToFavorites(userInfoDto.getUserId(), request);

        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }

    @DeleteMapping("/favorites/{placeId}")
    @Operation(summary = "장소 찜하기 취소", description = "특정 장소를 찜 목록에서 제거합니다")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "찜하기 취소 성공",
                    content = @Content(schema = @Schema(implementation = MutualResponse.class))
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "존재하지 않는 사용자 또는 찜하지 않은 장소",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    public Response<MutualResponseDto> removeFromFavorites(
            @PathVariable String placeId,
            @User @Parameter(hidden = true) UserInfoDto userInfoDto) {

        MutualResponseDto response = mapService.removeFromFavorites(userInfoDto.getUserId(), placeId);

        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }
}
