package com.dingdong.eeum.model;

import com.dingdong.eeum.constant.ContentType;
import com.dingdong.eeum.constant.ReportStatus;
import com.dingdong.eeum.constant.ReportType;
import lombok.Builder;
import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "reports")
@Getter
@Builder
public class Report {

    @Id
    private String id;
    private String contentId;
    private String reporterId;
    private ContentType contentType;
    private ReportType reportType;
    private ReportStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String adminId;
    private String adminNote;
}