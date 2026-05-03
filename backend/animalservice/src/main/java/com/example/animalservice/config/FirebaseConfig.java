package com.example.animalservice.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.Configuration;

import jakarta.annotation.PostConstruct;
import java.io.FileInputStream;
import java.io.IOException;

@Configuration
public class FirebaseConfig {

    @org.springframework.beans.factory.annotation.Value("${FIREBASE_SERVICE_ACCOUNT_PATH:src/main/resources/serviceAccountKey.json}")
    private String serviceAccountPath;

    @PostConstruct
    public void initialize() {
        try {
            FileInputStream serviceAccount =
                new FileInputStream(serviceAccountPath);

            FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                System.out.println("Firebase has been initialized");
            }
        } catch (IOException e) {
            System.err.println("Firebase initialization error: " + e.getMessage());
            System.err.println("Please ensure src/main/resources/serviceAccountKey.json exists.");
        }
    }
}
