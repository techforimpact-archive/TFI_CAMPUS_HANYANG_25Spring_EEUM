package com.dingdong.eeum.model;

import lombok.Builder;
import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

//TODO 임시 유저 모델

@Getter
@Document(collection = "users")
@Builder
public class User {
    @Id
    private String id;
    private String nickname;
}
