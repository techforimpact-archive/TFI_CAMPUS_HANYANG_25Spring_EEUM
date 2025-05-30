package com.dingdong.eeum.service;

import com.dingdong.eeum.apiPayload.code.status.ErrorStatus;
import com.dingdong.eeum.apiPayload.exception.GeneralException;
import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import com.dingdong.eeum.constant.UserStatus;
import com.dingdong.eeum.dto.request.EmailSendRequestDto;
import com.dingdong.eeum.dto.request.EmailVerifyRequestDto;
import com.dingdong.eeum.dto.response.EmailSendResponseDto;
import com.dingdong.eeum.dto.response.EmailVerifyResponseDto;
import com.dingdong.eeum.dto.response.PasswordResetVerifyResponseDto;
import com.dingdong.eeum.model.EmailVerification;
import com.dingdong.eeum.model.PasswordResetVerification;
import com.dingdong.eeum.repository.EmailVerificationRepository;
import com.dingdong.eeum.repository.PasswordResetVerificationRepository;
import com.dingdong.eeum.repository.UserRepository;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class EmailServiceImpl implements EmailService {

    private final EmailVerificationRepository verificationRepository;
    private final UserRepository userRepository;
    private final PasswordResetVerificationRepository passwordResetRepository;
    private final JavaMailSender mailSender;

    private static final int VERIFICATION_CODE_LENGTH = 6;
    private static final int MAX_ATTEMPTS = 5;

    @Override
    @Transactional
    public EmailSendResponseDto sendVerificationCode(EmailSendRequestDto request) {
        String email = request.getEmail();

        if (userRepository.existsByEmailAndStatus(email, UserStatus.ACTIVE)) {
            throw new GeneralException(ErrorStatus.AUTH_EMAIL_ALREADY_EXISTS);
        }

        verificationRepository.deleteByEmail(email);

        String verificationCode = generateVerificationCode();

        EmailVerification verification = EmailVerification.builder()
                .email(email)
                .code(verificationCode)
                .verified(false)
                .attemptCount(0)
                .build();

        verificationRepository.save(verification);
        sendVerificationEmail(email, verificationCode);

        log.info("인증번호 발송 완료: {}", email);
        return EmailSendResponseDto.toEmailSendResponseDto(email);
    }

    @Override
    @Transactional
    public EmailVerifyResponseDto verifyEmail(EmailVerifyRequestDto request) {
        String email = request.getEmail();
        String inputCode = request.getVerificationCode();

        Optional<EmailVerification> optionalVerification = verificationRepository.findByEmail(email);


        if (optionalVerification.isEmpty()) {
            throw new ExceptionHandler(ErrorStatus.AUTH_VERIFICATION_CODE_EXPIRED);
        }

        EmailVerification verification = optionalVerification.get();

        if (verification.isVerified()) throw new ExceptionHandler(ErrorStatus.VERIFICATION_ALREADY_COMPLETED);

        if (verification.getAttemptCount() >= MAX_ATTEMPTS) {
            verificationRepository.deleteByEmail(email);
            throw new ExceptionHandler(ErrorStatus.VERIFICATION_CODE_TOO_MANY_ATTEMPTS);
        }

        if (!verification.getCode().equals(inputCode)) {
            EmailVerification updatedVerification = EmailVerification.builder()
                    .id(verification.getId())
                    .email(verification.getEmail())
                    .code(verification.getCode())
                    .createdAt(verification.getCreatedAt())
                    .verified(false)
                    .attemptCount(verification.getAttemptCount() + 1)
                    .build();

            verificationRepository.save(updatedVerification);
            throw new ExceptionHandler(ErrorStatus.AUTH_VERIFICATION_CODE_INVALID);
        }

        EmailVerification verifiedVerification = EmailVerification.builder()
                .id(verification.getId())
                .email(verification.getEmail())
                .code(verification.getCode())
                .createdAt(verification.getCreatedAt())
                .verified(true)
                .attemptCount(verification.getAttemptCount())
                .build();

        verificationRepository.save(verifiedVerification);

        return EmailVerifyResponseDto.builder().email(email).verified(true).build();
    }

    public boolean isEmailVerified(String email) {
        return verificationRepository.existsByEmailAndVerified(email, true);
    }

    @Transactional
    public void deleteVerificationData(String email) {
        verificationRepository.deleteByEmail(email);
    }

    @Override
    @Transactional
    public void deletePasswordResetVerificationData(String email) {
        passwordResetRepository.deleteByEmail(email);
    }

    private String generateVerificationCode() {
        SecureRandom random = new SecureRandom();
        StringBuilder code = new StringBuilder();

        for (int i = 0; i < VERIFICATION_CODE_LENGTH; i++) {
            code.append(random.nextInt(10));
        }

        return code.toString();
    }

    private void sendVerificationEmail(String email, String code) {
        sendHtmlEmail(email, code);
    }

    private void sendHtmlEmail(String email, String code) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            String htmlContent = createVerificationEmailTemplate(code);

            helper.setTo(email);
            helper.setSubject("[이음] 이메일 인증번호");
            helper.setText(htmlContent, true);
            helper.setFrom("noreply@eeum.com");

            mailSender.send(message);

        } catch (Exception e) {
            throw new ExceptionHandler(ErrorStatus.EMAIL_SEND_FAILED);
        }
    }

    @Override
    @Transactional
    public EmailSendResponseDto sendPasswordResetCode(EmailSendRequestDto request) {
        String email = request.getEmail();

        if (!userRepository.existsByEmailAndStatus(email,UserStatus.ACTIVE)) {
            throw new ExceptionHandler(ErrorStatus.AUTH_USER_NOT_FOUND);
        }

        passwordResetRepository.deleteByEmail(email);

        String verificationCode = generateVerificationCode();

        PasswordResetVerification verification = PasswordResetVerification.builder()
                .email(email)
                .code(verificationCode)
                .verified(false)
                .attemptCount(0)
                .build();

        passwordResetRepository.save(verification);
        sendPasswordResetEmail(email, verificationCode);

        log.info("비밀번호 재설정 인증번호 발송 완료: {}", email);
        return EmailSendResponseDto.toEmailSendResponseDto(email);
    }

    @Override
    @Transactional
    public PasswordResetVerifyResponseDto verifyPasswordResetCode(EmailVerifyRequestDto request) {
        String email = request.getEmail();
        String inputCode = request.getVerificationCode();

        PasswordResetVerification verification =
                passwordResetRepository.findByEmailAndCode(email, inputCode).orElseThrow( () -> new ExceptionHandler(ErrorStatus.AUTH_VERIFICATION_CODE_EXPIRED));

        if (verification.isVerified()) throw new ExceptionHandler(ErrorStatus.VERIFICATION_ALREADY_COMPLETED);


        if (verification.getAttemptCount() >= MAX_ATTEMPTS) {
            passwordResetRepository.deleteByEmail(email);
            throw new ExceptionHandler(ErrorStatus.VERIFICATION_CODE_TOO_MANY_ATTEMPTS);
        }

        if (!verification.getCode().equals(inputCode)) throw new ExceptionHandler(ErrorStatus.AUTH_VERIFICATION_CODE_INVALID);

        String resetToken = generateResetToken();

        PasswordResetVerification verifiedVerification = PasswordResetVerification.builder()
                .id(verification.getId())
                .email(verification.getEmail())
                .code(verification.getCode())
                .createdAt(verification.getCreatedAt())
                .verified(true)
                .attemptCount(verification.getAttemptCount())
                .resetToken(resetToken)
                .build();

        passwordResetRepository.save(verifiedVerification);

        return PasswordResetVerifyResponseDto.toPasswordResetVerifyResponseDto(email, resetToken);
    }

    @Override
    public boolean isPasswordResetVerified(String email, String resetToken) {
        Optional<PasswordResetVerification> verification =
                passwordResetRepository.findByEmailAndResetToken(email, resetToken);

        if (verification.isEmpty()) {
            return false;
        }

        PasswordResetVerification v = verification.get();
        return v.isVerified();
    }

    private String generateResetToken() {
        return UUID.randomUUID().toString().replace("-", "").substring(0, 16);
    }

    private void sendPasswordResetEmail(String email, String code) {
        String htmlContent = createPasswordResetEmailTemplate(code);

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(email);
            helper.setSubject("[이음] 비밀번호 재설정 인증번호");
            helper.setText(htmlContent, true);
            helper.setFrom("noreply@eeum.com");

            mailSender.send(message);
        } catch (Exception e) {
            throw new GeneralException(ErrorStatus.EMAIL_SEND_FAILED);
        }
    }

    private String createPasswordResetEmailTemplate(String code) {
        return String.format("""
            <!DOCTYPE html>
            <html lang="ko">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>이음 비밀번호 재설정</title>
            </head>
            <body style="margin: 0; padding: 0; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; background-color: #f4f4f4;">
                <table cellpadding="0" cellspacing="0" border="0" width="100%%" style="background-color: #f4f4f4; padding: 40px 0;">
                    <tr>
                        <td align="center">
                            <table cellpadding="0" cellspacing="0" border="0" width="600" style="background-color: #ffffff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); overflow: hidden;">
                                
                                <!-- Header -->
                                <tr>
                                    <td style="background: linear-gradient(135deg, #ff6b6b 0%%, #ee5a24 100%%); padding: 40px 30px; text-align: center;">
                                        <h1 style="margin: 0; color: #ffffff; font-size: 28px; font-weight: 600; letter-spacing: -0.5px;">
                                            이음
                                        </h1>
                                        <p style="margin: 8px 0 0 0; color: #ffffff; font-size: 16px; opacity: 0.9;">
                                            🔒 비밀번호 재설정
                                        </p>
                                    </td>
                                </tr>
                                
                                <!-- Content -->
                                <tr>
                                    <td style="padding: 50px 40px; text-align: center;">
                                        <h2 style="margin: 0 0 20px 0; color: #333333; font-size: 24px; font-weight: 600;">
                                            비밀번호를 재설정하세요
                                        </h2>
                                        <p style="margin: 0 0 30px 0; color: #666666; font-size: 16px; line-height: 1.6;">
                                            비밀번호 재설정을 위한 인증번호입니다.<br>
                                            아래 인증번호를 입력하여 본인 확인을 완료해주세요.
                                        </p>
                                        
                                        <!-- Verification Code Box -->
                                        <div style="background: linear-gradient(135deg, #ff6b6b 0%%, #ee5a24 100%%); border-radius: 12px; padding: 30px; margin: 30px 0; box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);">
                                            <p style="margin: 0 0 10px 0; color: #ffffff; font-size: 14px; font-weight: 500; opacity: 0.9;">
                                                인증번호
                                            </p>
                                            <div style="font-size: 36px; font-weight: 700; color: #ffffff; letter-spacing: 8px; font-family: 'Courier New', monospace;">
                                                %s
                                            </div>
                                        </div>
                                        
                                        <!-- Warning Box -->
                                        <div style="background-color: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; padding: 20px; margin: 30px 0; text-align: center;">
                                            <table cellpadding="0" cellspacing="0" border="0" width="100%%">
                                                <tr>
                                                    <td style="text-align: center;">
                                                        <span style="font-size: 20px; display: inline-block; margin-bottom: 5px;">⚠️</span>
                                                        <p style="margin: 0; color: #856404; font-size: 14px; font-weight: 600; text-align: center;">
                                                            보안 주의사항
                                                        </p>
                                                        <p style="margin: 5px 0 0 0; color: #856404; font-size: 13px; line-height: 1.4; text-align: center;">
                                                            이 인증번호는 <strong>5분간</strong> 유효합니다.<br>
                                                            본인이 요청하지 않았다면 즉시 계정을 확인하세요.
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                
                                <!-- Footer -->
                                <tr>
                                    <td style="background-color: #f8f9fa; padding: 30px 40px; text-align: center; border-top: 1px solid #e9ecef;">
                                        <p style="margin: 0 0 10px 0; color: #6c757d; font-size: 14px; font-weight: 600;">
                                            E-eum Team
                                        </p>
                                        <p style="margin: 0; color: #adb5bd; font-size: 12px;">
                                            이 이메일은 자동으로 발송된 메일입니다. 회신하지 마세요.
                                        </p>
                                    </td>
                                </tr>
                                
                            </table>
                        </td>
                    </tr>
                </table>
            </body>
            </html>
            """, code);
    }

    private String createVerificationEmailTemplate(String code) {
        return String.format("""
        <!DOCTYPE html>
        <html lang="ko">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>이음 이메일 인증</title>
        </head>
        <body style="margin: 0; padding: 0; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; background-color: #f4f4f4;">
            <table cellpadding="0" cellspacing="0" border="0" width="100%%" style="background-color: #f4f4f4; padding: 40px 0;">
                <tr>
                    <td align="center">
                        <table cellpadding="0" cellspacing="0" border="0" width="600" style="background-color: #ffffff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); overflow: hidden;">
                            
                            <!-- Header -->
                            <tr>
                                <td style="background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%); padding: 40px 30px; text-align: center;">
                                    <h1 style="margin: 0; color: #ffffff; font-size: 28px; font-weight: 600; letter-spacing: -0.5px;">
                                        이음
                                    </h1>
                                    <p style="margin: 8px 0 0 0; color: #ffffff; font-size: 16px; opacity: 0.9;">
                                        이메일 인증
                                    </p>
                                </td>
                            </tr>
                            
                            <!-- Content -->
                            <tr>
                                <td style="padding: 50px 40px;">
                                    <div style="text-align: center;">
                                        <h2 style="margin: 0 0 20px 0; color: #333333; font-size: 24px; font-weight: 600;">
                                            안녕하세요! 👋
                                        </h2>
                                        <p style="margin: 0 0 30px 0; color: #666666; font-size: 16px; line-height: 1.6;">
                                            이음 회원가입을 위한 이메일 인증번호입니다.<br>
                                            아래 인증번호를 입력하여 인증을 완료해주세요.
                                        </p>
                                        
                                        <!-- Verification Code Box -->
                                        <div style="background: linear-gradient(135deg, #f093fb 0%%, #f5576c 100%%); border-radius: 12px; padding: 30px; margin: 30px 0; box-shadow: 0 4px 15px rgba(240, 147, 251, 0.3);">
                                            <p style="margin: 0 0 10px 0; color: #ffffff; font-size: 14px; font-weight: 500; opacity: 0.9;">
                                                인증번호
                                            </p>
                                            <div style="font-size: 36px; font-weight: 700; color: #ffffff; letter-spacing: 8px; font-family: 'Courier New', monospace;">
                                                %s
                                            </div>
                                        </div>
                                        
                                        <!-- Warning Box -->
                                        <div style="background-color: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; padding: 20px; margin: 30px 0; text-align: center;">
                                            <table cellpadding="0" cellspacing="0" border="0" width="100%%">
                                                <tr>
                                                    <td style="text-align: center;">
                                                        <span style="font-size: 20px; display: inline-block; margin-bottom: 5px;">⚠️</span>
                                                        <p style="margin: 0; color: #856404; font-size: 14px; font-weight: 600; text-align: center;">
                                                            중요 안내사항
                                                        </p>
                                                        <p style="margin: 5px 0 0 0; color: #856404; font-size: 13px; line-height: 1.4; text-align: center;">
                                                            이 인증번호는 <strong>5분간</strong> 유효합니다.<br>
                                                            타인에게 인증번호를 알려주지 마세요.
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        
                                        <p style="margin: 30px 0 0 0; color: #999999; font-size: 14px; line-height: 1.5;">
                                            만약 본인이 요청하지 않은 인증번호라면,<br>
                                            이 이메일을 무시하셔도 됩니다.
                                        </p>
                                    </div>
                                </td>
                            </tr>
                            
                            <!-- Footer -->
                            <tr>
                                <td style="background-color: #f8f9fa; padding: 30px 40px; text-align: center; border-top: 1px solid #e9ecef;">
                                    <p style="margin: 0 0 10px 0; color: #6c757d; font-size: 14px; font-weight: 600;">
                                        E-eum Team
                                    </p>
                                    <p style="margin: 0; color: #adb5bd; font-size: 12px;">
                                        이 이메일은 자동으로 발송된 메일입니다. 회신하지 마세요.
                                    </p>
                                </td>
                            </tr>
                            
                        </table>
                    </td>
                </tr>
            </table>
        </body>
        </html>
        """, code);
    }
}
