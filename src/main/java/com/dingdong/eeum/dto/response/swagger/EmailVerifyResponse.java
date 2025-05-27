package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.response.EmailSendResponseDto;
import com.dingdong.eeum.dto.response.EmailVerifyResponseDto;

public class EmailVerifyResponse extends Response<EmailVerifyResponseDto> {
    public EmailVerifyResponse(EmailVerifyResponseDto result) {
        super(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), result);
    }
}
