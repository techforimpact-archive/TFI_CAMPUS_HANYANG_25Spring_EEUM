package com.dingdong.eeum.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum UserStatus {
    ACTIVE("활성 회원"),
    INACTIVE("탈퇴 회원");

    private final String displayName;
}
