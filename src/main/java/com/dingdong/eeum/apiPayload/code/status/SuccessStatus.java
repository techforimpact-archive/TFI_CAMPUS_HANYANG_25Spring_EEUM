package com.dingdong.eeum.apiPayload.code.status;

import com.dingdong.eeum.apiPayload.code.base.BaseCode;
import com.dingdong.eeum.apiPayload.code.dto.ReasonDTO;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum SuccessStatus implements BaseCode {
    _OK(HttpStatus.OK, "COMMON200", "성공입니다"),
    _CREATED(HttpStatus.OK, "COMMON201", "생성하였습니다");

    private final HttpStatus httpStatus;
    private final String code;
    private final String message;

    @Override
    public ReasonDTO getReason() {
        return ReasonDTO.builder()
                .code(code)
                .message(message)
                .isSuccess(true)
                .build();
    }

    @Override
    public ReasonDTO getReasonHttpStatus() {
        return ReasonDTO.builder()
                .code(code)
                .message(message)
                .isSuccess(true)
                .httpStatus(httpStatus)
                .build();
    }
}
