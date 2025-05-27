package com.dingdong.eeum.service;

import com.dingdong.eeum.apiPayload.code.status.ErrorStatus;
import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import com.dingdong.eeum.dto.request.PasswordResetRequestDto;
import com.dingdong.eeum.dto.request.SignupRequestDto;
import com.dingdong.eeum.dto.request.SigninRequestDto;
import com.dingdong.eeum.dto.request.TokenRefreshRequestDto;
import com.dingdong.eeum.dto.response.MutualResponseDto;
import com.dingdong.eeum.dto.response.SigninResponseDto;
import com.dingdong.eeum.dto.response.TokenRefreshResponseDto;
import com.dingdong.eeum.model.RefreshToken;
import com.dingdong.eeum.model.User;
import com.dingdong.eeum.repository.RefreshTokenRepository;
import com.dingdong.eeum.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;
    private final JwtService jwtTokenProvider;

    @Override
    public MutualResponseDto signupUser(SignupRequestDto request) {

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new ExceptionHandler(ErrorStatus.AUTH_EMAIL_ALREADY_EXISTS);
        }

        String encodedPassword = passwordEncoder.encode(request.getPassword());

        User user = User.builder()
                .nickname(request.getNickname())
                .email(request.getEmail())
                .password(encodedPassword)
                .build();

        User savedUser = userRepository.save(user);

        return MutualResponseDto.builder().status(true).build();
    }

    @Override
    public MutualResponseDto signoutUser(String userId) {
        refreshTokenRepository.deleteByUserId(userId);

        return MutualResponseDto.builder()
                .status(true)
                .build();
    }

    @Override
    public SigninResponseDto signinUser(SigninRequestDto request) {

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new ExceptionHandler(ErrorStatus.AUTH_USER_NOT_FOUND));


        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new ExceptionHandler(ErrorStatus.AUTH_INVALID_CREDENTIALS);
        }

        String accessToken = jwtTokenProvider.createAccessToken(user.getId());
        String refreshToken = jwtTokenProvider.createRefreshToken(user.getId());

        refreshTokenRepository.deleteByUserId(user.getId());

        RefreshToken refreshTokenEntity = RefreshToken.builder()
                .token(refreshToken)
                .userId(user.getId())
                .createdAt(LocalDateTime.now())
                .expiresAt(LocalDateTime.now().plusSeconds(jwtTokenProvider.getRefreshTokenValidityInSeconds()))
                .build();

        refreshTokenRepository.save(refreshTokenEntity);

        return SigninResponseDto.builder()
                .userId(user.getId())
                .nickname(user.getNickname())
                .email(user.getEmail())
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    @Override
    public MutualResponseDto checkNickname(String nickname) {

        if (nickname.length() < 2 || nickname.length() > 20) throw new ExceptionHandler(ErrorStatus.AUTH_NICKNAME_TOO_LONG);

        boolean exists = userRepository.existsByNickname(nickname);

        if (exists) throw new ExceptionHandler(ErrorStatus.AUTH_NICKNAME_ALREADY_EXISTS);

        return MutualResponseDto.builder().status(true).build();
    }

    @Override
    public MutualResponseDto checkEmail(String email) {
        boolean exists = userRepository.existsByEmail(email);

        if (exists) throw new ExceptionHandler(ErrorStatus.AUTH_EMAIL_ALREADY_EXISTS);

        return MutualResponseDto.builder().status(true).build();
    }

    @Override
    @Transactional
    public MutualResponseDto resetPassword(PasswordResetRequestDto request) {
        String email = request.getEmail();
        String resetToken = request.getResetToken();
        String newPassword = request.getNewPassword();

        if (!emailService.isPasswordResetVerified(email, resetToken)) {
            throw new ExceptionHandler(ErrorStatus.AUTH_PASSWORD_RESET_NOT_VERIFIED);
        }

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ExceptionHandler(ErrorStatus.AUTH_USER_NOT_FOUND));

        String encodedPassword = passwordEncoder.encode(newPassword);

        User updatedUser = User.builder()
                .id(user.getId())
                .nickname(user.getNickname())
                .email(user.getEmail())
                .password(encodedPassword)
                .createdAt(user.getCreatedAt())
                .updatedAt(LocalDateTime.now())
                .build();

        userRepository.save(updatedUser);

        emailService.deletePasswordResetVerificationData(email);

        return MutualResponseDto.builder().status(true).build();
    }

    public TokenRefreshResponseDto refreshAccessToken(TokenRefreshRequestDto request) {
        String refreshTokenValue = request.getRefreshToken();

        if (!jwtTokenProvider.validateToken(refreshTokenValue)) {
            throw new ExceptionHandler(ErrorStatus.AUTH_INVALID_REFRESH_TOKEN);
        }

        RefreshToken refreshToken = refreshTokenRepository.findByToken(refreshTokenValue)
                .orElseThrow(() -> new ExceptionHandler(ErrorStatus.AUTH_INVALID_REFRESH_TOKEN));

        if (refreshToken.isExpired()) {
            refreshTokenRepository.delete(refreshToken);
            throw new ExceptionHandler(ErrorStatus.AUTH_EXPIRED_REFRESH_TOKEN);
        }

        String newAccessToken = jwtTokenProvider.createAccessToken(refreshToken.getUserId());
        String newRefreshToken = jwtTokenProvider.createRefreshToken(refreshToken.getUserId());

        refreshTokenRepository.delete(refreshToken);

        RefreshToken newRefreshTokenEntity = RefreshToken.builder()
                .token(newRefreshToken)
                .userId(refreshToken.getUserId())
                .createdAt(LocalDateTime.now())
                .expiresAt(LocalDateTime.now().plusSeconds(jwtTokenProvider.getRefreshTokenValidityInSeconds()))
                .build();

        refreshTokenRepository.save(newRefreshTokenEntity);

        return TokenRefreshResponseDto.builder()
                .accessToken(newAccessToken)
                .refreshToken(newRefreshToken)
                .build();
    }
}
