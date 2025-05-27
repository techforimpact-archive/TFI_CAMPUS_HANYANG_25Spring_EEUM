package com.dingdong.eeum.model;

import lombok.Builder;
import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.Indexed;
import java.time.LocalDateTime;

@Getter
@Document(collection = "refresh_tokens")
@Builder
public class RefreshToken {
    @Id
    private String id;

    @Indexed(unique = true)
    private String token;

    @Indexed
    private String userId;

    private LocalDateTime createdAt;

    @Builder.Default
    private LocalDateTime expiresAt = LocalDateTime.now().plusWeeks(2);

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expiresAt);
    }
}
