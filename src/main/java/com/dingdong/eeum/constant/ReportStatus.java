package com.dingdong.eeum.constant;

public enum ReportStatus {
    PENDING("대기중"),
    REVIEWING("검토중"),
    RESOLVED("처리완료"),
    DISMISSED("기각");

    private final String description;

    ReportStatus(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
