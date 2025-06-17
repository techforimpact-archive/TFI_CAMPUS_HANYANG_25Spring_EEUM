package com.dingdong.eeum.service;

import com.dingdong.eeum.apiPayload.code.status.ErrorStatus;
import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import com.dingdong.eeum.constant.UserRole;
import com.dingdong.eeum.constant.UserStatus;
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
import java.util.Optional;

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
        Optional<User> existingUser = userRepository.findByEmail(request.getEmail());
        String encodedPassword = passwordEncoder.encode(request.getPassword());

        if (existingUser.isPresent()) {
            User user = existingUser.get();
            if (user.getStatus().equals(UserStatus.ACTIVE)) {
                throw new ExceptionHandler(ErrorStatus.AUTH_EMAIL_ALREADY_EXISTS);
            }

            user.setNickname(request.getNickname());
            user.setPassword(encodedPassword);
            user.setStatus(UserStatus.ACTIVE);
            user.setRole(UserRole.GUEST);
            userRepository.save(user);
        } else {
            User newUser = User.builder()
                    .nickname(request.getNickname())
                    .email(request.getEmail())
                    .password(encodedPassword)
                    .role(UserRole.GUEST)
                    .status(UserStatus.ACTIVE)
                    .build();
            userRepository.save(newUser);
        }

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

        User user = userRepository.findByEmailAndStatus(request.getEmail(), UserStatus.ACTIVE)
                .orElseThrow(() -> new ExceptionHandler(ErrorStatus.AUTH_USER_NOT_FOUND));


        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new ExceptionHandler(ErrorStatus.AUTH_INVALID_CREDENTIALS);
        }

        String accessToken = jwtTokenProvider.createAccessToken(user.getId(),user.getRole());
        String refreshToken = jwtTokenProvider.createRefreshToken(user.getId());

        refreshTokenRepository.deleteByUserId(user.getId());

        RefreshToken refreshTokenEntity = RefreshToken.builder()
                .token(refreshToken)
                .userId(user.getId())
                .createdAt(LocalDateTime.now())
                .build();

        refreshTokenRepository.save(refreshTokenEntity);

        return SigninResponseDto.builder()
                .userId(user.getId())
                .nickname(user.getNickname())
                .email(user.getEmail())
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .isQrVerified(user.getRole().equals(UserRole.USER))
                .build();
    }

    @Override
    public MutualResponseDto checkNickname(String nickname) {

        if (nickname.length() < 2 || nickname.length() > 20) throw new ExceptionHandler(ErrorStatus.AUTH_NICKNAME_TOO_LONG);

        boolean exists = userRepository.existsByNicknameAndStatus(nickname,UserStatus.ACTIVE);

        if (exists) throw new ExceptionHandler(ErrorStatus.AUTH_NICKNAME_ALREADY_EXISTS);

        return MutualResponseDto.builder().status(true).build();
    }

    @Override
    public MutualResponseDto checkEmail(String email) {
        boolean exists = userRepository.existsByEmailAndStatus(email,UserStatus.ACTIVE);

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

        User user = userRepository.findByEmailAndStatus(email,UserStatus.ACTIVE)
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

    public TokenRefreshResponseDto refreshAccessToken(TokenRefreshRequestDto request, UserRole role) {
        String refreshTokenValue = request.getRefreshToken();

        if (!jwtTokenProvider.validateToken(refreshTokenValue)) {
            throw new ExceptionHandler(ErrorStatus.AUTH_INVALID_REFRESH_TOKEN);
        }

        RefreshToken refreshToken = refreshTokenRepository.findByToken(refreshTokenValue)
                .orElseThrow(() -> new ExceptionHandler(ErrorStatus.AUTH_EXPIRED_REFRESH_TOKEN));

        String newAccessToken = jwtTokenProvider.createAccessToken(refreshToken.getUserId(),role);
        String newRefreshToken = jwtTokenProvider.createRefreshToken(refreshToken.getUserId());

        refreshTokenRepository.delete(refreshToken);

        RefreshToken newRefreshTokenEntity = RefreshToken.builder()
                .token(newRefreshToken)
                .userId(refreshToken.getUserId())
                .createdAt(LocalDateTime.now())
                .build();

        refreshTokenRepository.save(newRefreshTokenEntity);

        return TokenRefreshResponseDto.builder()
                .accessToken(newAccessToken)
                .refreshToken(newRefreshToken)
                .build();
    }
}
