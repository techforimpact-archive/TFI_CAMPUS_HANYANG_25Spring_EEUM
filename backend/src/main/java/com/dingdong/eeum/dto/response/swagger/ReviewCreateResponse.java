package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.response.ReviewResponseDto;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "리뷰 생성 결과")
public class ReviewCreateResponse extends Response<ReviewResponseDto> {
    public ReviewCreateResponse(ReviewResponseDto result) {
        super(true,
                SuccessStatus._OK.getCode(),
                SuccessStatus._OK.getMessage(), result);
    }
}