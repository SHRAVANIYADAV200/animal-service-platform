package com.example.animalservice.repository;

import com.example.animalservice.model.DeviceToken;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface DeviceTokenRepository extends JpaRepository<DeviceToken, Long> {
    List<DeviceToken> findByUserEmail(String email);
    Optional<DeviceToken> findByToken(String token);
    void deleteByUserEmail(String email);
}
