package com.dingdong.eeum.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum ReportType {
    INCORRECT_INFO("잘못된 정보"),
    COMMERCIAL_AD("상업적 광고"),
    SPAM("음란물"),
    PROFANITY("폭력성"),
    OTHER("기타");

    private final String displayName;

    public static ReportType fromDisplayName(String displayName) {
        for (ReportType category : ReportType.values()) {
            if (category.getDisplayName().equals(displayName)) {
                return category;
            }
        }
        return null;
    }
}