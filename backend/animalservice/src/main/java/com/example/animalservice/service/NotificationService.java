package com.example.animalservice.service;

import com.example.animalservice.model.DeviceToken;
import com.example.animalservice.repository.DeviceTokenRepository;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotificationService {

    @Autowired
    private DeviceTokenRepository tokenRepository;

    public void sendToUser(String email, String title, String body) {
        List<DeviceToken> tokens = tokenRepository.findByUserEmail(email);
        
        for (DeviceToken deviceToken : tokens) {
            try {
                Message message = Message.builder()
                    .setToken(deviceToken.getToken())
                    .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody(body)
                        .build())
                    .build();

                FirebaseMessaging.getInstance().send(message);
                System.out.println(">>> PUSH NOTIFICATION SENT TO " + email + ": " + title + " - " + body);
            } catch (Exception e) {
                System.err.println("Failed to send notification to " + email + ": " + e.getMessage());
            }
        }
    }

    public void saveToken(String email, String token) {
        tokenRepository.findByToken(token).ifPresentOrElse(
            existing -> {
                existing.setUserEmail(email);
                tokenRepository.save(existing);
            },
            () -> tokenRepository.save(new DeviceToken(email, token))
        );
    }
}
