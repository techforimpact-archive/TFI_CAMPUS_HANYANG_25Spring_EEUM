package com.dingdong.apiPayload.code.base;

import com.dingdong.apiPayload.code.dto.ReasonDTO;

public interface BaseCode {

    public ReasonDTO getReason();

    public ReasonDTO getReasonHttpStatus();
}
