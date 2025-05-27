package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.response.PlaceResponseDto;
import com.dingdong.eeum.dto.response.ScrollResponseDto;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.ArrayList;

@Schema(description = "목록 모드 검색 결과 (무한 스크롤)")
public class ListSearchResponse extends Response<ScrollResponseDto<PlaceResponseDto>> {
    public ListSearchResponse() {
        super(true,
                SuccessStatus._OK.getCode(),
                SuccessStatus._OK.getMessage(),
                new ScrollResponseDto<>(new ArrayList<>(), false, null));
    }
}
