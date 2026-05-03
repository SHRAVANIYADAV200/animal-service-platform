package com.example.animalservice.controller;

import com.example.animalservice.service.OtpService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/otp")
@CrossOrigin(origins = "*")
public class OtpController {

    @Autowired
    private OtpService otpService;

    @PostMapping("/send")
    public Map<String, String> sendOtp(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String type = request.get("type");
        otpService.generateOtp(email, type);
        return Map.of("status", "SENT", "message", "OTP sent successfully to " + email);
    }

    @PostMapping("/verify")
    public Map<String, Object> verifyOtp(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String code = request.get("code");
        String type = request.get("type");
        
        System.out.println("----------------------------------------");
        System.out.println("VERIFYING OTP FOR: " + email);
        System.out.println("CODE: " + code);
        System.out.println("TYPE: " + type);
        System.out.println("----------------------------------------");
        
        try {
            boolean isValid = otpService.verifyOtp(email, code, type);
            
            if (isValid) {
                System.out.println("OTP VERIFICATION SUCCESS");
                return Map.of("status", "SUCCESS", "message", "OTP verified");
            } else {
                System.out.println("OTP VERIFICATION FAILED: Invalid or expired");
                return Map.of("status", "FAILED", "message", "Invalid or expired OTP");
            }
        } catch (Exception e) {
            System.err.println("OTP VERIFICATION ERROR: " + e.getMessage());
            e.printStackTrace();
            return Map.of("status", "ERROR", "message", "Internal server error: " + e.getMessage());
        }
    }
}
