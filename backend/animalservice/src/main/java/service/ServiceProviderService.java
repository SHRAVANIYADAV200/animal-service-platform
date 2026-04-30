package com.example.animalservice.service;

import com.example.animalservice.model.ServiceProvider;
import com.example.animalservice.repository.ServiceProviderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ServiceProviderService {

    @Autowired
    private ServiceProviderRepository repository;

    public ServiceProvider register(ServiceProvider provider) {
        return repository.save(provider);
    }

    public ServiceProvider login(String email, String password) {
        ServiceProvider user = repository.findByEmail(email);

        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }
}