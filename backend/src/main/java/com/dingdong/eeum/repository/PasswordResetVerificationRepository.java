package com.dingdong.eeum.repository;

import com.dingdong.eeum.model.PasswordResetVerification;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface PasswordResetVerificationRepository extends MongoRepository<PasswordResetVerification, String> {
    Optional<PasswordResetVerification> findByEmailAndCode(String email, String code);
    Optional<PasswordResetVerification> findByEmailAndResetToken(String email, String resetToken);
    void deleteByEmail(String email);
    boolean existsByEmailAndVerified(String email, boolean verified);
}
