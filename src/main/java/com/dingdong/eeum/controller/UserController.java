package com.dingdong.eeum.controller;

import com.dingdong.eeum.apiPayload.code.status.SuccessStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.dto.request.QrAuthRequestDto;
import com.dingdong.eeum.dto.response.QrAuthResponseDto;
import com.dingdong.eeum.dto.response.swagger.QrAuthResponse;
import com.dingdong.eeum.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/v1/user")
public class UserController {

    private final UserService userService;

    @PostMapping("/qr")
    @Operation(summary = "QR 코드 인증", description = "QR 코드를 통한 사용자 인증")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "QR 인증 성공",
                    content = @Content(schema = @Schema(implementation = QrAuthResponse.class))
            ),
            @ApiResponse(
                    responseCode = "401",
                    description = "유효하지 않은 QR Token",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "존재하지 않는 유저",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "409",
                    description = "이미 qr 인증된 유저",
                    content = @Content(schema = @Schema(implementation = Response.class))
            ),
            @ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = Response.class))
            )
    })
    public Response<QrAuthResponseDto> authenticateWithQr(
            @Valid @RequestBody QrAuthRequestDto request) {

        QrAuthResponseDto response = userService.authenticateWithQr(request);

        return new Response<>(true, SuccessStatus._OK.getCode(), SuccessStatus._OK.getMessage(), response);
    }
}
