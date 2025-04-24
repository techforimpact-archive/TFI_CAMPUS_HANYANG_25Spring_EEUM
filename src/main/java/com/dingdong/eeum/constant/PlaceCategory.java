package com.dingdong.eeum.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum PlaceCategory {
    COUNSELING("상담소"),
    HOSPITAL("병원"),
    SHELTER("쉼터"),
    LEGAL("법률"),
    CAFE("카페"),
    BOOKSTORE("서점"),
    EXHIBITION("전시회"),
    ETC("기타");

    private final String displayName;

    public static PlaceCategory fromDisplayName(String displayName) {
        for (PlaceCategory category : PlaceCategory.values()) {
            if (category.getDisplayName().equals(displayName)) {
                return category;
            }
        }
        return null;
    }
}
