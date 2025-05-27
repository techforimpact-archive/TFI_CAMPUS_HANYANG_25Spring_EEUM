package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.response.PasswordResetVerifyResponseDto;

public class PasswordResetVerifyResponse extends Response<PasswordResetVerifyResponseDto> {
    public PasswordResetVerifyResponse(PasswordResetVerifyResponseDto result) {
        super(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), result);
    }
}
