package com.dingdong.eeum.service;

import com.dingdong.eeum.dto.request.QrAuthRequestDto;
import com.dingdong.eeum.dto.response.QrAuthResponseDto;

public interface UserService {
    QrAuthResponseDto authenticateWithQr(QrAuthRequestDto qrAuthRequestDto);
}
