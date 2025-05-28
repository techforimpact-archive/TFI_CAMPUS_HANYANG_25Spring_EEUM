package com.dingdong.eeum.model;

import com.dingdong.eeum.constant.UserRole;
import lombok.Builder;
import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.Indexed;
import java.time.LocalDateTime;

@Getter
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

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
