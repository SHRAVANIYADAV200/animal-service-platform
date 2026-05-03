package com.example.animalservice.controller;

import com.example.animalservice.model.*;
import com.example.animalservice.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/lookup")
@CrossOrigin(origins = "*")
public class LookupController {

    @Autowired private AnimalSpeciesRepository speciesRepo;
    @Autowired private VaccineTypeRepository vaccineRepo;
    @Autowired private ServiceTypeRepository serviceRepo;
    @Autowired private DistrictRepository districtRepo;

    @GetMapping("/species")
    public List<AnimalSpecies> getSpecies() { return speciesRepo.findAll(); }

    @GetMapping("/vaccines")
    public List<VaccineType> getVaccines() { return vaccineRepo.findAll(); }

    @GetMapping("/services")
    public List<ServiceType> getServices() { return serviceRepo.findAll(); }

    @GetMapping("/districts")
    public List<District> getDistricts() { return districtRepo.findAll(); }

    @PostMapping("/species")
    public AnimalSpecies addSpecies(@RequestBody AnimalSpecies species) {
        return speciesRepo.save(species);
    }

    @GetMapping("/seed")
    public String seedLookups() {
        if (speciesRepo.count() == 0) {
            speciesRepo.saveAll(List.of(
                new AnimalSpecies("Cow"), new AnimalSpecies("Buffalo"), 
                new AnimalSpecies("Goat"), new AnimalSpecies("Sheep"), 
                new AnimalSpecies("Chicken"), new AnimalSpecies("Dog")
            ));
        }
        if (vaccineRepo.count() == 0) {
            vaccineRepo.saveAll(List.of(
                new VaccineType("Foot & Mouth Disease (FMD)"), 
                new VaccineType("Black Quarter (BQ)"), 
                new VaccineType("Hemorrhagic Septicemia (HS)"),
                new VaccineType("Brucellosis"),
                new VaccineType("Rabies"),
                new VaccineType("PPR (Peste des Petits Ruminants)")
            ));
        }
        if (serviceRepo.count() == 0) {
            serviceRepo.saveAll(List.of(
                new ServiceType("General Consultation"), 
                new ServiceType("Vaccination"), 
                new ServiceType("Artificial Insemination"),
                new ServiceType("Emergency Surgery"),
                new ServiceType("De-worming")
            ));
        }
        if (districtRepo.count() == 0) {
            districtRepo.saveAll(List.of(
                new District("Pune"), new District("Mumbai"), 
                new District("Satara"), new District("Nagpur"), 
                new District("Nashik"), new District("Aurangabad"),
                new District("Solapur"), new District("Kolhapur"),
                new District("Sangli"), new District("Ahmednagar")
            ));
        }
        return "Maharashtra-relevant lookups seeded successfully!";
    }
}
