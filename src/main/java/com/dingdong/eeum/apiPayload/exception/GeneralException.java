package com.dingdong.eeum.apiPayload.exception;

import com.dingdong.eeum.apiPayload.code.base.BaseErrorCode;
import com.dingdong.eeum.apiPayload.code.dto.ErrorReasonDTO;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class GeneralException extends RuntimeException {

    private BaseErrorCode code;

    public ErrorReasonDTO getErrorReason() {
        return this.code.getReason();
    }

    public ErrorReasonDTO getErrorReasonHttpStatus(){
        return this.code.getReasonHttpStatus();
    }
}
