package com.dingdong.eeum.repository;

import com.dingdong.eeum.constant.UserRole;
import com.dingdong.eeum.constant.UserStatus;
import com.dingdong.eeum.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.data.mongodb.repository.Update;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<User, String> {
    Optional<User> findByEmailAndStatus(String email,UserStatus status);
    boolean existsByEmail(String email);
    boolean existsByNickname(String nickname);

    @Query("{ '_id': ?0 }")
    @Update("{ '$set': { 'role': ?1, 'updatedAt': ?2 } }")
    void updateRoleById(String id, UserRole role, LocalDateTime updatedAt);
}
