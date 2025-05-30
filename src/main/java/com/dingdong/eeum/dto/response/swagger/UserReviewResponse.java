package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.response.UserReviewResponseDto;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.ArrayList;
import java.util.List;

@Schema(description = "리뷰 리스트 조회 결과")
public class UserReviewResponse extends Response<List<UserReviewResponseDto>> {
    public UserReviewResponse() {
        super(true,
                SuccessStatus._OK.getCode(),
                SuccessStatus._OK.getMessage(),
                new ArrayList<>());
    }
}
