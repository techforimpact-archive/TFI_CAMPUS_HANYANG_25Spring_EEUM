package com.dingdong.eeum.apiPayload.code.base;

import com.dingdong.eeum.apiPayload.code.dto.ReasonDTO;

public interface BaseCode {

    public ReasonDTO getReason();

    public ReasonDTO getReasonHttpStatus();
}
