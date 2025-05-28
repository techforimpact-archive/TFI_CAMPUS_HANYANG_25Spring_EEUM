package com.dingdong.eeum.apiPayload.code.status;

import com.dingdong.eeum.apiPayload.code.dto.ErrorReasonDTO;
import com.dingdong.eeum.apiPayload.code.base.BaseErrorCode;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum ErrorStatus implements BaseErrorCode {

    // 가장 일반적인 응답
    _INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "COMMON500", "서버 에러, 관리자에게 문의 바랍니다."),
    _BAD_REQUEST(HttpStatus.BAD_REQUEST,"COMMON400","잘못된 요청입니다."),
    _UNAUTHORIZED(HttpStatus.UNAUTHORIZED,"COMMON401","인증이 필요합니다."),
    _FORBIDDEN(HttpStatus.FORBIDDEN, "COMMON403", "금지된 요청입니다."),

    // Auth Error
    AUTH_EMAIL_ALREADY_EXISTS(HttpStatus.CONFLICT, "AUTH409_1", "이미 존재하는 이메일입니다."),
    AUTH_INVALID_CREDENTIALS(HttpStatus.UNAUTHORIZED, "AUTH401_1", "이메일 또는 비밀번호가 일치하지 않습니다."),
    AUTH_USER_NOT_FOUND(HttpStatus.NOT_FOUND, "AUTH404_1", "존재하지 않는 사용자입니다."),
    AUTH_PASSWORD_INVALID(HttpStatus.BAD_REQUEST, "AUTH400_1", "비밀번호는 최소 8자 이상이어야 합니다."),
    AUTH_EMAIL_INVALID(HttpStatus.BAD_REQUEST, "AUTH400_2", "올바른 이메일 형식이 아닙니다."),
    AUTH_NICKNAME_REQUIRED(HttpStatus.BAD_REQUEST, "AUTH400_3", "닉네임은 필수입니다."),
    AUTH_NICKNAME_TOO_LONG(HttpStatus.BAD_REQUEST, "AUTH400_4", "닉네임은 20자 이내로 입력해주세요."),
    AUTH_TOKEN_INVALID(HttpStatus.UNAUTHORIZED, "AUTH401_2", "유효하지 않은 토큰입니다."),
    AUTH_TOKEN_EXPIRED(HttpStatus.GONE, "AUTH401_3", "토큰이 만료되었습니다."),
    AUTH_TOKEN_MISSING(HttpStatus.UNAUTHORIZED, "AUTH401_4", "토큰이 필요합니다."),
    AUTH_TOKEN_MALFORMED(HttpStatus.UNAUTHORIZED, "AUTH401_5", "토큰 형식이 올바르지 않습니다."),
    AUTH_TOKEN_UNSUPPORTED(HttpStatus.UNAUTHORIZED, "AUTH401_6", "지원되지 않는 토큰입니다."),
    AUTH_TOKEN_SIGNATURE_INVALID(HttpStatus.UNAUTHORIZED, "AUTH401_7", "토큰 서명이 유효하지 않습니다."),
    AUTH_TOKEN_EMPTY(HttpStatus.UNAUTHORIZED, "AUTH401_8", "토큰이 비어있습니다."),
    AUTH_BEARER_PREFIX_MISSING(HttpStatus.UNAUTHORIZED, "AUTH401_9", "Authorization 헤더에 Bearer 접두사가 필요합니다."),
    AUTH_REFRESH_TOKEN_INVALID(HttpStatus.UNAUTHORIZED, "AUTH401_10", "유효하지 않은 리프레시 토큰입니다."),
    AUTH_ACCESS_DENIED(HttpStatus.FORBIDDEN, "AUTH403_1", "접근 권한이 없습니다."),

    AUTH_NICKNAME_ALREADY_EXISTS(HttpStatus.CONFLICT, "AUTH409_2", "이미 사용 중인 닉네임입니다."),
    AUTH_NICKNAME_TOO_SHORT(HttpStatus.BAD_REQUEST, "AUTH400_5", "닉네임은 최소 2자 이상이어야 합니다."),
    AUTH_VERIFICATION_CODE_EXPIRED(HttpStatus.GONE, "AUTH410_1", "인증번호가 만료되었습니다."),
    AUTH_VERIFICATION_CODE_INVALID(HttpStatus.BAD_REQUEST, "AUTH400_6", "인증번호가 일치하지 않습니다."),
    AUTH_VERIFICATION_CODE_NOT_FOUND(HttpStatus.NOT_FOUND, "AUTH404_2", "인증번호를 찾을 수 없습니다."),
    AUTH_EMAIL_NOT_VERIFIED(HttpStatus.BAD_REQUEST, "AUTH400_7", "이메일 인증이 필요합니다."),
    AUTH_VERIFICATION_CODE_REQUIRED(HttpStatus.BAD_REQUEST, "AUTH400_8", "인증번호는 필수입니다."),
    AUTH_PASSWORD_RESET_NOT_VERIFIED(HttpStatus.UNAUTHORIZED, "AUTH401_11", "비밀번호 재설정 인증이 필요합니다."),

    AUTH_INVALID_REFRESH_TOKEN(HttpStatus.UNAUTHORIZED, "AUTH4001", "유효하지 않은 Refresh Token입니다."),
    AUTH_EXPIRED_REFRESH_TOKEN(HttpStatus.GONE, "AUTH4002", "만료된 Refresh Token입니다."),
    AUTH_TOKEN_NOT_FOUND(HttpStatus.UNAUTHORIZED, "AUTH4003", "토큰이 없습니다."),
    AUTH_TOKEN_ERROR(HttpStatus.UNAUTHORIZED, "AUTH4005", "토큰 처리 중 오류가 발생했습니다"),
    AUTH_FILTER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "AUTH5001", "인증 필터에서 오류가 발생했습니다"),

    // QR Authentication Error
    QR_AUTH_ALREADY_AUTHORIZED(HttpStatus.CONFLICT, "QR409_1", "이미 인가된 사용자입니다. QR 인증이 필요하지 않습니다."),

    // Email Error
    EMAIL_SEND_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "EMAIL500_1", "이메일 발송에 실패했습니다."),
    EMAIL_TEMPLATE_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "EMAIL500_2", "이메일 템플릿 처리 중 오류가 발생했습니다."),
    EMAIL_SMTP_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "EMAIL500_3", "SMTP 서버 연결에 실패했습니다."),
    EMAIL_RATE_LIMIT_EXCEEDED(HttpStatus.TOO_MANY_REQUESTS, "EMAIL429_1", "이메일 발송 요청이 너무 많습니다. 잠시 후 다시 시도해주세요."),
    EMAIL_INVALID_FORMAT(HttpStatus.BAD_REQUEST, "EMAIL400_1", "올바른 이메일 형식이 아닙니다."),
    EMAIL_DOMAIN_NOT_ALLOWED(HttpStatus.BAD_REQUEST, "EMAIL400_2", "허용되지 않는 이메일 도메인입니다."),

    // Verification Error
    VERIFICATION_CODE_TOO_MANY_ATTEMPTS(HttpStatus.TOO_MANY_REQUESTS, "VERIFY429_1", "인증번호 확인 시도 횟수를 초과했습니다."),
    VERIFICATION_CODE_GENERATION_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "VERIFY500_1", "인증번호 생성에 실패했습니다."),
    VERIFICATION_ALREADY_COMPLETED(HttpStatus.CONFLICT, "VERIFY409_1", "이미 인증이 완료된 이메일입니다."),

    // Map Error
    MAP_COORDINATES_INVALID(HttpStatus.BAD_REQUEST, "MAP400_1", "유효하지 않은 좌표 범위입니다."),
    MAP_RADIUS_INVALID(HttpStatus.BAD_REQUEST, "MAP400_2", "유효하지 않은 반경 범위입니다."),

    // Place Error
    PLACE_NOT_FOUND(HttpStatus.NOT_FOUND, "PLACE404_1", "존재하지 않는 장소입니다."),
    PLACE_INVALID_CATEGORY(HttpStatus.BAD_REQUEST, "PLACE400_1", "유효하지 않은 카테고리입니다."),
    PLACE_INVALID_STATUS(HttpStatus.BAD_REQUEST, "PLACE400_2", "유효하지 않은 상태값입니다."),
    PLACE_SEARCH_KEYWORD_EMPTY(HttpStatus.BAD_REQUEST, "PLACE400_3", "검색어를 입력해주세요."),
    PLACE_COORDINATES_REQUIRED(HttpStatus.BAD_REQUEST, "PLACE400_4", "위치 정보(경도, 위도)가 필요합니다."),
    PLACE_ACCESS_DENIED(HttpStatus.FORBIDDEN, "PLACE403_1", "해당 장소에 접근 권한이 없습니다."),
    PLACE_ALREADY_EXISTS(HttpStatus.CONFLICT, "PLACE409_1", "이미 존재하는 장소입니다."),
    PLACE_REVIEW_NOT_ALLOWED(HttpStatus.BAD_REQUEST, "PLACE400_5", "해당 장소에 리뷰를 작성할 권한이 없습니다."),
    PLACE_SEARCH_NAME_EMPTY(HttpStatus.BAD_REQUEST, "PLACE400_6", "해당 장소 이름이 없습니다."),
    INVALID_SEARCH_MODE(HttpStatus.BAD_REQUEST, "PLACE400_6", "유효하지 않은 검색 모드입니다."),
    INVALID_PARAMETERS(HttpStatus.BAD_REQUEST, "PLACE400_7", "검색에 필요한 필수 파라미터가 누락되었습니다."),

    // Review Error
    REVIEW_NOT_FOUND(HttpStatus.NOT_FOUND, "REVIEW404_1", "존재하지 않는 리뷰입니다."),
    REVIEW_CONTENT_REQUIRED(HttpStatus.BAD_REQUEST, "REVIEW400_1", "리뷰 내용은 필수입니다."),
    REVIEW_CONTENT_TOO_LONG(HttpStatus.BAD_REQUEST, "REVIEW400_2", "리뷰 내용은 500자 이내로 작성해주세요."),
    REVIEW_RATING_INVALID(HttpStatus.BAD_REQUEST, "REVIEW400_3", "평점은 1-5 사이의 값이어야 합니다."),
    REVIEW_QUESTION_ID_INVALID(HttpStatus.BAD_REQUEST, "REVIEW400_4", "유효하지 않은 질문 ID입니다."),
    REVIEW_RATINGS_REQUIRED(HttpStatus.BAD_REQUEST, "REVIEW400_5", "최소 하나 이상의 평점이 필요합니다."),
    REVIEW_ACCESS_DENIED(HttpStatus.FORBIDDEN, "REVIEW403_1", "해당 리뷰에 접근 권한이 없습니다."),
    REVIEW_ALREADY_EXISTS(HttpStatus.CONFLICT, "REVIEW409_1", "이미 리뷰를 작성한 장소입니다."),
    REVIEW_MODIFY_NOT_ALLOWED(HttpStatus.FORBIDDEN, "REVIEW403_2", "리뷰를 수정할 권한이 없습니다."),
    REVIEW_DELETE_NOT_ALLOWED(HttpStatus.FORBIDDEN, "REVIEW403_3", "리뷰를 삭제할 권한이 없습니다."),

    // QUESTION Error
    QUESTION_NOT_FOUND(HttpStatus.NOT_FOUND, "QUESTION404_1", "존재하지 않는 질문입니다."),

    // IMAGE Error
    IMAGE_COUNT_EXCEEDED(HttpStatus.BAD_REQUEST, "IMAGE_001", "이미지는 최대 5개까지 업로드할 수 있습니다."),
    IMAGE_FORMAT_NOT_SUPPORTED(HttpStatus.BAD_REQUEST, "IMAGE_002", "지원되지 않는 이미지 형식입니다."),
    IMAGE_SIZE_EXCEEDED(HttpStatus.BAD_REQUEST, "IMAGE_003", "이미지 크기가 너무 큽니다.");

    private final HttpStatus httpStatus;
    private final String code;
    private final String message;

    @Override
    public ErrorReasonDTO getReason() {
        return ErrorReasonDTO.builder()
                .message(message)
                .code(code)
                .isSuccess(false)
                .build();
    }

    @Override
    public ErrorReasonDTO getReasonHttpStatus() {
        return ErrorReasonDTO.builder()
                .message(message)
                .code(code)
                .isSuccess(false)
                .httpStatus(httpStatus)
                .build()
                ;
    }
}
