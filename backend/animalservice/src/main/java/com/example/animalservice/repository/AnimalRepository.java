package com.example.animalservice.repository;

import com.example.animalservice.model.Animal;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AnimalRepository extends JpaRepository<Animal, Integer> {
    List<Animal> findByOwnerEmail(String email);
}
