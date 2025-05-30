package com.dingdong.eeum.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.CompoundIndex;

import java.time.LocalDateTime;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "favorites")
@CompoundIndex(def = "{'userId': 1, 'placeId': 1}", unique = true)
public class Favorite {
    @Id
    private String id;
    private String userId;
    private String placeId;
    private LocalDateTime createdAt;
}
