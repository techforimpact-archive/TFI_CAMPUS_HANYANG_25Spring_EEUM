package com.dingdong.eeum.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum UserRole {
    GUEST("게스트"),
    USER("인가 유저"),
    ADMIN("어드민");

    private final String displayName;

    public static UserRole fromDisplayName(String displayName) {
        for (UserRole role : UserRole.values()) {
            if (role.getDisplayName().equals(displayName)) {
                return role;
            }
        }
        return GUEST;
    }

    public static UserRole fromString(String roleString) {
        try {
            return UserRole.valueOf(roleString.toUpperCase());
        } catch (IllegalArgumentException e) {
            return GUEST;
        }
    }
}
