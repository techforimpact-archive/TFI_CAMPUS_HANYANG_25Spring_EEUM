package com.dingdong.eeum.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum PlaceStatus {
    ACTIVE("운영중"),
    CLOSED("폐업"),
    PENDING("검증대기"),
    SUSPENDED("일시중단"),
    DELETED("삭제됨");

    private final String displayName;

    public static PlaceStatus fromDisplayName(String displayName) {
        for (PlaceStatus status : PlaceStatus.values()) {
            if (status.getDisplayName().equals(displayName)) {
                return status;
            }
        }
        return null;
    }
}
