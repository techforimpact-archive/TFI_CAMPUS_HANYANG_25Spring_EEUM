package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.response.ReviewResponseDto;
import com.dingdong.eeum.dto.response.ScrollResponseDto;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.ArrayList;


@Schema(name = "장소 리뷰 조회 결과")
public class ReviewGetResponse extends Response<ScrollResponseDto<ReviewResponseDto>> {
    public ReviewGetResponse() {
        super(true,
                SuccessStatus._OK.getCode(),
                SuccessStatus._OK.getMessage(),
                new ScrollResponseDto<>(new ArrayList<>(), false, null));
    }
}
