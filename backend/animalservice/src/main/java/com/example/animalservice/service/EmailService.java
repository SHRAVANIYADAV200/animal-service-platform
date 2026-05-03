package com.example.animalservice.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @org.springframework.beans.factory.annotation.Value("${spring.mail.username}")
    private String fromEmail;

    public void sendOtp(String to, String otp) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(fromEmail);
        message.setTo(to);
        message.setSubject("Your OTP for Animal Service Platform");
        message.setText("Your verification code is: " + otp + "\n\nValid for 5 minutes.");
        
        try {
            mailSender.send(message);
            System.out.println("External Email Sent to " + to);
        } catch (Exception e) {
            System.err.println("Failed to send external email: " + e.getMessage());
        }
    }
}
