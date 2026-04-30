package com.example.animalservice.repository;

import com.example.animalservice.model.ServiceProvider;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ServiceProviderRepository extends JpaRepository<ServiceProvider, Integer> {

    ServiceProvider findByEmail(String email);
}