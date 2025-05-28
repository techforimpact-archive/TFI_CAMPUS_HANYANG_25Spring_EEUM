package com.dingdong.eeum.service;

import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import com.dingdong.eeum.constant.UserRole;
import com.dingdong.eeum.dto.request.QrAuthRequestDto;
import com.dingdong.eeum.dto.response.QrAuthResponseDto;
import com.dingdong.eeum.model.User;
import com.dingdong.eeum.repository.UserRepository;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.security.SignatureException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

import static com.dingdong.eeum.apiPayload.code.status.ErrorStatus.*;
import static com.dingdong.eeum.constant.UserRole.GUEST;

@RequiredArgsConstructor
@Service
public class UserServiceImpl implements UserService{

    private final JwtService jwtService;
    private final UserRepository userRepository;

    @Override
    public QrAuthResponseDto authenticateWithQr(QrAuthRequestDto qrAuthRequestDto) {
        String qrToken = qrAuthRequestDto.getQrCode();

        if (qrToken == null || qrToken.trim().isEmpty()) {
            throw new ExceptionHandler(AUTH_TOKEN_EMPTY);
        }

        try {
            if (!jwtService.validateToken(qrToken)) {
                throw new ExceptionHandler(AUTH_TOKEN_INVALID);
            }

            String userId = jwtService.getUserIdFromToken(qrToken);

            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new ExceptionHandler(AUTH_USER_NOT_FOUND));

            if (user.getRole() != GUEST) {
                throw new ExceptionHandler(QR_AUTH_ALREADY_AUTHORIZED);
            } else {
                userRepository.updateRoleById(userId, UserRole.USER, LocalDateTime.now());
            }

            return QrAuthResponseDto.builder()
                    .accessToken(jwtService.createAccessToken(userId,UserRole.USER))
                    .build();

        } catch (ExpiredJwtException e) {
            throw new ExceptionHandler(AUTH_TOKEN_EXPIRED);
        } catch (MalformedJwtException e) {
            throw new ExceptionHandler(AUTH_TOKEN_MALFORMED);
        } catch (UnsupportedJwtException e) {
            throw new ExceptionHandler(AUTH_TOKEN_UNSUPPORTED);
        } catch (SignatureException e) {
            throw new ExceptionHandler(AUTH_TOKEN_SIGNATURE_INVALID);
        }
    }
}
