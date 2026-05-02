package com.example.animalservice.service;

import com.example.animalservice.model.ServiceProvider;
import com.example.animalservice.repository.ServiceProviderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

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

    public List<ServiceProvider> getAllProviders() {
        return repository.findByRole("Service Provider");
    }

    public Optional<ServiceProvider> getProviderById(int id) {
        return repository.findById(id);
    }

    public List<ServiceProvider> getProvidersByType(String doctorType) {
        return repository.findByDoctorType(doctorType);
    }

    public List<ServiceProvider> getGovernmentProvidersByDistrict(String district) {
        return repository.findByDoctorTypeAndDistrict("GOVERNMENT", district);
    }

    public ServiceProvider updateProvider(ServiceProvider provider) {
        return repository.save(provider);
    }

    public ServiceProvider findByEmail(String email) {
        return repository.findByEmail(email);
    }

    public ServiceProvider save(ServiceProvider provider) {
        return repository.save(provider);
    }
}