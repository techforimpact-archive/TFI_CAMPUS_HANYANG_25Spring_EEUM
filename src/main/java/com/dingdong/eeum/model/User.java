package com.dingdong.eeum.model;

import com.dingdong.eeum.constant.UserRole;
import com.dingdong.eeum.constant.UserStatus;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.Indexed;
import java.time.LocalDateTime;

@Getter
@Setter
@Document(collection = "users")
@Builder
public class User {
    @Id
    private String id;

    private String nickname;

    @Indexed(unique = true)
    private String email;

    private String password;

    private UserRole role;

    @Builder.Default
    private UserStatus status = UserStatus.ACTIVE;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    private LocalDateTime deactivatedAt;

    public void deactivate() {
        this.status = UserStatus.INACTIVE;
        this.deactivatedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
}
