package com.dingdong.eeum.repository;

import com.dingdong.eeum.model.EmailVerification;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface EmailVerificationRepository extends MongoRepository<EmailVerification, String> {
    Optional<EmailVerification> findByEmail(String email);
    void deleteByEmail(String email);
    boolean existsByEmailAndVerified(String email, boolean verified);
}
