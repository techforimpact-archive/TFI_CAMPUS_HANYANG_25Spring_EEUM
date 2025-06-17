package com.dingdong.eeum.service;

import com.dingdong.eeum.constant.UserRole;
import com.dingdong.eeum.dto.request.PasswordResetRequestDto;
import com.dingdong.eeum.dto.request.SignupRequestDto;
import com.dingdong.eeum.dto.request.SigninRequestDto;
import com.dingdong.eeum.dto.request.TokenRefreshRequestDto;
import com.dingdong.eeum.dto.response.MutualResponseDto;
import com.dingdong.eeum.dto.response.SigninResponseDto;
import com.dingdong.eeum.dto.response.TokenRefreshResponseDto;

public interface AuthService {
    MutualResponseDto signupUser(SignupRequestDto request);
    MutualResponseDto signoutUser(String id);
    SigninResponseDto signinUser(SigninRequestDto request);
    MutualResponseDto checkNickname(String nickname);
    MutualResponseDto checkEmail(String email);
    MutualResponseDto resetPassword(PasswordResetRequestDto request);
    TokenRefreshResponseDto refreshAccessToken(TokenRefreshRequestDto request, UserRole role);
}
