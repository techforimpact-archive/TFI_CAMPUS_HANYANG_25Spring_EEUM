package com.dingdong.eeum.service;

import com.dingdong.eeum.dto.request.QrAuthRequestDto;
import com.dingdong.eeum.dto.response.*;
import org.springframework.data.domain.Sort;

public interface UserService {
    QrAuthResponseDto authenticateWithQr(QrAuthRequestDto qrAuthRequestDto, String id);
    MutualResponseDto deactivateUser(String userId);
    ScrollResponseDto<UserFavoriteResponseDto> getFavoritesByUserId(
            String userId, String cursor, int size, String sortBy, Sort.Direction sortDirection);
    ScrollResponseDto<UserReviewResponseDto> getReviewsByUserId(
            String userId, String cursor, int size, String sortBy, Sort.Direction sortDirection);
}
