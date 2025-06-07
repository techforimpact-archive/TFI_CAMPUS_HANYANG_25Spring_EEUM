package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.response.ReportResponseDto;
import com.dingdong.eeum.dto.response.ScrollResponseDto;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.ArrayList;

@Schema(name = "신고 결과")
public class ReportResponse extends Response<ScrollResponseDto<ReportResponseDto>> {
    public ReportResponse() {
        super(true,
                SuccessStatus._OK.getCode(),
                SuccessStatus._OK.getMessage(),
                new ScrollResponseDto<>(new ArrayList<>(), false, null));
    }
}
