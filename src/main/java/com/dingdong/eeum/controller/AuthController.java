package com.dingdong.eeum.controller;

import com.dingdong.eeum.annotation.CurrentUser;
import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.request.*;
import com.dingdong.eeum.dto.response.*;
import com.dingdong.eeum.dto.response.swagger.*;
import com.dingdong.eeum.service.AuthService;
import com.dingdong.eeum.service.EmailService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/v1/auth")
@Tag(name = "인증 API", description = "회원 인증 관련 API")
public class AuthController {
    private final AuthService authService;
    private final EmailService emailService;

    @Operation(summary = "닉네임 중복 확인")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "사용 가능한 닉네임",
                    content = @Content(schema = @Schema(implementation = MutualResponse.class))
            ),
            @ApiResponse(
                    responseCode = "409",
                    description = "이미 사용 중인 닉네임",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    @GetMapping("/check-nickname")
    public Response<MutualResponseDto> checkNickname(@RequestParam String nickname) {
        MutualResponseDto responseDto = authService.checkNickname(nickname);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), responseDto);
    }

    @Operation(summary = "이메일 중복 확인")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "사용 가능한 이메일",
                    content = @Content(schema = @Schema(implementation = MutualResponse.class))
            ),
            @ApiResponse(
                    responseCode = "409",
                    description = "이미 사용 중인 이메일",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    @GetMapping("/check-email")
    public Response<MutualResponseDto> checkEmail(@RequestParam String email) {
        MutualResponseDto responseDto = authService.checkEmail(email);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), responseDto);
    }

    @Operation(summary = "이메일 인증번호 발송")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "인증번호 발송 성공",
                    content = @Content(schema = @Schema(implementation = EmailSendResponse.class))
            ),
            @ApiResponse(
                    responseCode = "400",
                    description = "잘못된 이메일 형식",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "409",
                    description = "이미 가입된 이메일",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    @PostMapping("/send-verification")
    public Response<EmailSendResponseDto> sendVerificationCode(@Valid @RequestBody EmailSendRequestDto request) {
        EmailSendResponseDto response = emailService.sendVerificationCode(request);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }

    @Operation(summary = "이메일 인증번호 확인")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "인증번호 확인 성공",
                    content = @Content(schema = @Schema(implementation = EmailVerifyResponseDto.class))
            ),
            @ApiResponse(
                    responseCode = "400",
                    description = "잘못된 인증번호",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "410",
                    description = "만료된 인증번호",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    @PostMapping("/verify-email")
    public Response<EmailVerifyResponseDto> verifyEmail(@Valid @RequestBody EmailVerifyRequestDto request) {
        EmailVerifyResponseDto response = emailService.verifyEmail(request);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }


    @Operation(summary = "회원가입")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "201",
                    description = "회원가입 성공",
                    content = @Content(schema = @Schema(implementation = MutualResponse.class))
            ),
            @ApiResponse(
                    responseCode = "400",
                    description = "잘못된 요청",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "409",
                    description = "이미 존재하는 이메일",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    @PostMapping("/signup")
    public Response<MutualResponseDto> signupUser(@Valid @RequestBody SignupRequestDto request) {
        MutualResponseDto response = authService.signupUser(request);
        return new Response<>(true, SuccessStatus._CREATED.getCode(), SuccessStatus._CREATED.getMessage(), response);
    }

    @Operation(summary = "로그인")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "로그인 성공",
                    content = @Content(schema = @Schema(implementation = SigninResponse.class))
            ),
            @ApiResponse(
                    responseCode = "401",
                    description = "인증 실패 - 이메일 또는 비밀번호 불일치",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    @PostMapping("/signin")
    public Response<SigninResponseDto> signinUser(@Valid @RequestBody SigninRequestDto request) {
        SigninResponseDto response = authService.signinUser(request);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }
    @Operation(summary = "비밀번호 재설정 - 이메일 인증번호 발송")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "인증번호 발송 성공",
                    content = @Content(schema = @Schema(implementation = EmailSendResponse.class))
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "존재하지 않는 이메일",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "400",
                    description = "잘못된 이메일 형식",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    @PostMapping("/password-reset/send-verification")
    public Response<EmailSendResponseDto> sendPasswordResetCode(@Valid @RequestBody EmailSendRequestDto request) {
        EmailSendResponseDto response = emailService.sendPasswordResetCode(request);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }

    @Operation(summary = "비밀번호 재설정 - 인증번호 확인")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "인증번호 확인 성공",
                    content = @Content(schema = @Schema(implementation = PasswordResetVerifyResponse.class))
            ),
            @ApiResponse(
                    responseCode = "400",
                    description = "잘못된 인증번호",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "410",
                    description = "만료된 인증번호",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    @PostMapping("/password-reset/verify")
    public Response<PasswordResetVerifyResponseDto> verifyPasswordResetCode(@Valid @RequestBody EmailVerifyRequestDto request) {
        PasswordResetVerifyResponseDto response = emailService.verifyPasswordResetCode(request);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }

    @Operation(summary = "비밀번호 재설정 - 새 비밀번호 설정")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "비밀번호 재설정 성공",
                    content = @Content(schema = @Schema(implementation = MutualResponse.class))
            ),
            @ApiResponse(
                    responseCode = "400",
                    description = "잘못된 요청 또는 비밀번호 형식 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "401",
                    description = "인증되지 않은 요청",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    @PostMapping("/password-reset/confirm")
    public Response<MutualResponseDto> resetPassword(@Valid @RequestBody PasswordResetRequestDto request) {
        MutualResponseDto response = authService.resetPassword(request);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }

    @Operation(summary = "Access Token 재발급")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "토큰 재발급 성공",
                    content = @Content(schema = @Schema(implementation = TokenRefreshResponse.class))
            ),
            @ApiResponse(
                    responseCode = "401",
                    description = "유효하지 않은 Refresh Token",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "410",
                    description = "만료된 Refresh Token",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    @PostMapping("/refresh")
    public Response<TokenRefreshResponseDto> refreshToken(@Valid @RequestBody TokenRefreshRequestDto request) {
        TokenRefreshResponseDto response = authService.refreshAccessToken(request);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }

    @Operation(summary = "로그아웃")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "로그아웃 성공",
                    content = @Content(schema = @Schema(implementation = MutualResponse.class))
            ),
            @ApiResponse(
                    responseCode = "401",
                    description = "인증되지 않은 사용자",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    @PostMapping("/signout")
    public Response<MutualResponseDto> signoutUser(HttpServletRequest request, @CurrentUser String id) {
        MutualResponseDto response = authService.signoutUser(id);
        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }
}
