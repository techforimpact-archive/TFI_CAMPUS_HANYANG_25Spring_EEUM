package com.dingdong.eeum.repository;

import com.dingdong.eeum.model.RefreshToken;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface RefreshTokenRepository extends MongoRepository<RefreshToken, String> {

    Optional<RefreshToken> findByToken(String token);

    Optional<RefreshToken> findByUserId(String userId);

    void deleteByUserId(String userId);

    void deleteByToken(String token);

    void deleteByExpiresAtBefore(LocalDateTime dateTime);
}
