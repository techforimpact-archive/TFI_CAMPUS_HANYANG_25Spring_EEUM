package com.dingdong.eeum.model;


import lombok.Builder;
import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Document(collection = "reviews")
@Builder
public class Review {
    @Id
    private String id;
    private String placeId;
    private String userId;
    private String content;
    private List<String> imageUrls;
    private int rating;
    private boolean isRecommended;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
