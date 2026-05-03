package com.example.animalservice.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "otp_verification")
public class OtpVerification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String email;
    private String otpCode;
    private LocalDateTime expiryTime;
    private String type; // REGISTRATION, PROFILE_UPDATE, LOGIN

    public OtpVerification() {}

    public OtpVerification(String email, String otpCode, int expiryMinutes, String type) {
        this.email = email;
        this.otpCode = otpCode;
        this.expiryTime = LocalDateTime.now().plusMinutes(expiryMinutes);
        this.type = type;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getOtpCode() { return otpCode; }
    public void setOtpCode(String otpCode) { this.otpCode = otpCode; }

    public LocalDateTime getExpiryTime() { return expiryTime; }
    public void setExpiryTime(LocalDateTime expiryTime) { this.expiryTime = expiryTime; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expiryTime);
    }
}
