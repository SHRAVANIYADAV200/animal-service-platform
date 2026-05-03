package com.example.animalservice.model;

import jakarta.persistence.*;

@Entity
@Table(name = "device_tokens")
public class DeviceToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String userEmail;
    private String token;

    public DeviceToken() {}

    public DeviceToken(String userEmail, String token) {
        this.userEmail = userEmail;
        this.token = token;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
}
