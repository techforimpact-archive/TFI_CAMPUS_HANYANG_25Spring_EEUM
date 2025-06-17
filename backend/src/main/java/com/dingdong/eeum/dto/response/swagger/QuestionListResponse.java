package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.response.QuestionResponseDto;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.ArrayList;
import java.util.List;

@Schema(description = "리뷰 질분 조회 결과")
public class QuestionListResponse extends Response<List<QuestionResponseDto>> {
    public QuestionListResponse() {
        super(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), new ArrayList<>());
    }
}
