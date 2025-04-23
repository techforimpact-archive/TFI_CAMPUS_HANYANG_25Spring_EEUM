package com.dingdong.eeum.apiPayload.exception.response;

import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
@JsonPropertyOrder({"isSuccess", "code", "message", "result"})
public class Response<T> {

    @JsonProperty("isSuccess")
    private final Boolean isSuccess;
    private final String code;
    private final String message;
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private T result;


    // 성공한 경우 응답 생성
    public static <T> Response<T> onSuccess(T result){
        return new Response<>(true, SuccessStatus._OK.getCode() , SuccessStatus._OK.getMessage(), result);
    }

    // 생성 성공한 경우 응답 생성
    public static <T> Response<T> onCreated(T result){
        return new Response<>(true, SuccessStatus._CREATED.getCode() , SuccessStatus._CREATED.getMessage(), result);
    }


    // 실패한 경우 응답 생성
    public static <T> Response<T> onFailure(String code, String message, T data){
        return new Response<>(false, code, message, data);
    }
}
