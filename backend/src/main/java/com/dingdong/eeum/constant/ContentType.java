package com.dingdong.eeum.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum ContentType {
    PLACE("장소"),
    REVIEW("리뷰");

    private final String displayName;

    public static ContentType fromDisplayName(String displayName) {
        for (ContentType category : ContentType.values()) {
            if (category.getDisplayName().equals(displayName)) {
                return category;
            }
        }
        return null;
    }
}
