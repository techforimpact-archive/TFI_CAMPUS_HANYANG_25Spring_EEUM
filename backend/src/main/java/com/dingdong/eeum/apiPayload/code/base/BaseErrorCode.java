package com.dingdong.eeum.apiPayload.code.base;

import com.dingdong.eeum.apiPayload.code.dto.ErrorReasonDTO;

public interface BaseErrorCode {

    public ErrorReasonDTO getReason();

    public ErrorReasonDTO getReasonHttpStatus();
}
