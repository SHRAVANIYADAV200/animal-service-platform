package com.example.animalservice.repository;

import com.example.animalservice.model.OtpVerification;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface OtpRepository extends JpaRepository<OtpVerification, Long> {
    Optional<OtpVerification> findTopByEmailAndTypeOrderByExpiryTimeDesc(String email, String type);
    void deleteByEmailAndType(String email, String type);
}
