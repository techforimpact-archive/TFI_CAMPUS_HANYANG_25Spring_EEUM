package com.dingdong.eeum.model;

import lombok.Builder;
import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.LocalDateTime;

@Getter
@Builder
@Document(collection = "email_verifications")
public class EmailVerification {
    @Id
    private String id;

    @Indexed(unique = true)
    private String email;

    private String code;

    @Indexed(expireAfter = "PT5M")
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    private boolean verified;

    @Builder.Default
    private int attemptCount = 0;
}
