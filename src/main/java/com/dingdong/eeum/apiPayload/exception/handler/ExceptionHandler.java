package com.dingdong.eeum.apiPayload.exception.handler;

import com.dingdong.eeum.apiPayload.code.base.BaseErrorCode;
import com.dingdong.eeum.apiPayload.exception.GeneralException;

public class ExceptionHandler extends GeneralException {

    public ExceptionHandler(BaseErrorCode errorCode) {
        super(errorCode);
    }
}
