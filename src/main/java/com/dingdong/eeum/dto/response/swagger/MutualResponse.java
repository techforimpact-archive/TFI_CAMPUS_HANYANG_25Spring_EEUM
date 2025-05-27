package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;

public class MutualResponse extends Response<Boolean> {
    public MutualResponse(Boolean result) {
        super(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), result);
    }
}
