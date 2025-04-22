package com.dingdong.apiPayload.code.base;

import com.dingdong.apiPayload.code.dto.ErrorReasonDTO;

public interface BaseErrorCode {

    public ErrorReasonDTO getReason();

    public ErrorReasonDTO getReasonHttpStatus();
}
