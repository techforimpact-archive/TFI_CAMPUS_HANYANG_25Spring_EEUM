package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.response.PlaceResponseDto;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.ArrayList;
import java.util.List;

@Schema(description = "지도 모드 검색 결과")
public class MapSearchResponseDto extends Response<List<PlaceResponseDto>> {
    public MapSearchResponseDto() {
        super(true,
                SuccessStatus._OK.getCode(),
                SuccessStatus._OK.getMessage(),
                new ArrayList<>());
    }
}
