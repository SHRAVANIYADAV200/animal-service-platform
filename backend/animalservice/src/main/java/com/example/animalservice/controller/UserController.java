package com.example.animalservice.controller;

import com.example.animalservice.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {

    @Autowired
    private NotificationService notificationService;

    @PostMapping("/fcm-token")
    public Map<String, String> saveFcmToken(@RequestBody Map<String, String> payload) {
        String email = payload.get("email");
        String token = payload.get("token");
        if (email != null && token != null) {
            notificationService.saveToken(email, token);
            return Map.of("status", "SUCCESS", "message", "FCM token saved");
        }
        return Map.of("status", "ERROR", "message", "Email or Token missing");
    }
}
