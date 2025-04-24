package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.dto.response.PlaceResponseDto;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "지도 모드 검색 결과")
public class MapSearchResultDto {
    @Schema(description = "장소 목록")
    private List<PlaceResponseDto> places;
}

