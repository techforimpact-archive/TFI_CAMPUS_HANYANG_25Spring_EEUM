package com.dingdong.eeum.service;

import com.dingdong.eeum.dto.request.QrAuthRequestDto;
import com.dingdong.eeum.dto.response.FavoriteResponseDto;
import com.dingdong.eeum.dto.response.QrAuthResponseDto;
import com.dingdong.eeum.dto.response.ScrollResponseDto;
import com.dingdong.eeum.dto.response.UserReviewResponseDto;
import org.springframework.data.domain.Sort;

public interface UserService {
    QrAuthResponseDto authenticateWithQr(QrAuthRequestDto qrAuthRequestDto, String id);
    ScrollResponseDto<FavoriteResponseDto> getFavoritesByUserId(
            String userId, String cursor, int size, String sortBy, Sort.Direction sortDirection);
    ScrollResponseDto<UserReviewResponseDto> getReviewsByUserId(
            String userId, String cursor, int size, String sortBy, Sort.Direction sortDirection);
}
