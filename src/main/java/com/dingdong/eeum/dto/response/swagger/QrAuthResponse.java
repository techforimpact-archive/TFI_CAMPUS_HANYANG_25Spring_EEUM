package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.response.QrAuthResponseDto;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "리뷰 질분 조회 결과")
public class QrAuthResponse extends Response<QrAuthResponseDto> {
    public QrAuthResponse(QrAuthResponseDto qrAuthResponseDto) {
        super(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), qrAuthResponseDto);
    }
}
