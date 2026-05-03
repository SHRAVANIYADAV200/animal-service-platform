package com.example.animalservice.repository;

import com.example.animalservice.model.AnimalSpecies;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AnimalSpeciesRepository extends JpaRepository<AnimalSpecies, Long> {}
