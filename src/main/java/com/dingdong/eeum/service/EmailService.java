package com.dingdong.eeum.service;

import com.dingdong.eeum.dto.request.EmailSendRequestDto;
import com.dingdong.eeum.dto.request.EmailVerifyRequestDto;
import com.dingdong.eeum.dto.response.EmailSendResponseDto;
import com.dingdong.eeum.dto.response.EmailVerifyResponseDto;
import com.dingdong.eeum.dto.response.PasswordResetVerifyResponseDto;

public interface EmailService {
    EmailSendResponseDto sendVerificationCode(EmailSendRequestDto request);
    EmailVerifyResponseDto verifyEmail(EmailVerifyRequestDto request);
    EmailSendResponseDto sendPasswordResetCode(EmailSendRequestDto request);
    PasswordResetVerifyResponseDto verifyPasswordResetCode(EmailVerifyRequestDto request);
    boolean isPasswordResetVerified(String email, String resetToken);
    void deletePasswordResetVerificationData(String email);
}

