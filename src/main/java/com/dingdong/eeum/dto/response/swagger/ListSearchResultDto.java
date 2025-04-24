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
@Schema(description = "목록 모드 검색 결과 (무한 스크롤)")
public class ListSearchResultDto {
    @Schema(description = "장소 목록")
    private List<PlaceResponseDto> places;

    @Schema(description = "추가 데이터 존재 여부")
    private boolean hasNext;

    @Schema(description = "다음 페이지 커서")
    private String nextCursor;
}
