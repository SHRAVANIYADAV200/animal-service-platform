package com.example.animalservice.service;

import com.example.animalservice.model.OtpVerification;
import com.example.animalservice.repository.OtpRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.Random;

@Service
public class OtpService {

    @Autowired
    private OtpRepository repository;

    @Autowired
    private EmailService emailService;

    @Transactional
    public String generateOtp(String email, String type) {
        // Delete any existing OTP for this email/type
        repository.deleteByEmailAndType(email, type);

        // Generate 6-digit code
        String code = String.format("%06d", new Random().nextInt(999999));
        
        OtpVerification otp = new OtpVerification(email, code, 5, type); // 5 mins expiry
        repository.save(otp);

        // Send via external email service
        emailService.sendOtp(email, code);

        // Simulate sending (In real app, use Twilio or JavaMailSender)
        System.out.println("----------------------------------------");
        System.out.println("OTP LOGGED (Bypass: 123456): " + email);
        System.out.println("CODE: " + code);
        System.out.println("TYPE: " + type);
        System.out.println("----------------------------------------");

        return code;
    }

    public boolean verifyOtp(String email, String code, String type) {
        // Bypass for testing
        if ("123456".equals(code)) {
            System.out.println("OTP BYPASS USED FOR: " + email);
            return true;
        }

        Optional<OtpVerification> record = repository.findTopByEmailAndTypeOrderByExpiryTimeDesc(email, type);
        
        if (record.isPresent()) {
            OtpVerification otp = record.get();
            if (!otp.isExpired() && otp.getOtpCode().equals(code)) {
                repository.delete(otp); // One-time use
                return true;
            }
        }
        return false;
    }
}
