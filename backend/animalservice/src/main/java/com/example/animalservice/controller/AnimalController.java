package com.example.animalservice.controller;

import com.example.animalservice.model.Animal;
import com.example.animalservice.model.VaccinationRecord;
import com.example.animalservice.repository.AnimalRepository;
import com.example.animalservice.repository.VaccinationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/animals")
@CrossOrigin(origins = "*")
public class AnimalController {

    @Autowired
    private AnimalRepository animalRepository;

    @Autowired
    private VaccinationRepository vaccinationRepository;

    @GetMapping
    public List<Animal> getAllAnimals(@RequestParam(required = false) String ownerEmail) {
        if (ownerEmail != null) {
            return animalRepository.findByOwnerEmail(ownerEmail);
        }
        return animalRepository.findAll();
    }

    @PostMapping
    public Animal addAnimal(@RequestBody Animal animal) {
        return animalRepository.save(animal);
    }

    @GetMapping("/{id}")
    public Animal getAnimal(@PathVariable int id) {
        return animalRepository.findById(id).orElse(null);
    }

    @PostMapping("/{id}/vaccinations")
    public VaccinationRecord addVaccination(@PathVariable int id, @RequestBody VaccinationRecord record) {
        record.setAnimalId(id);
        // Find animal name if not provided
        if (record.getAnimalName() == null || record.getAnimalName().isEmpty()) {
            animalRepository.findById(id).ifPresent(a -> record.setAnimalName(a.getName()));
        }
        return vaccinationRepository.save(record);
    }

    @GetMapping("/{id}/vaccinations")
    public List<VaccinationRecord> getVaccinations(@PathVariable int id) {
        return vaccinationRepository.findByAnimalId(id);
    }
}
