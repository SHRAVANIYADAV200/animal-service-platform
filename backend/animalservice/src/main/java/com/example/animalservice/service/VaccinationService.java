package com.example.animalservice.service;

import com.example.animalservice.model.VaccinationRecord;
import com.example.animalservice.repository.VaccinationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class VaccinationService {

    @Autowired
    private VaccinationRepository repository;

    public VaccinationRecord addRecord(VaccinationRecord record) {
        record.setStatus("COMPLETED");
        return repository.save(record);
    }

    public List<VaccinationRecord> getByFarmer(String email) {
        return repository.findByFarmerEmail(email);
    }

    public List<VaccinationRecord> getByAnimal(int animalId) {
        return repository.findByAnimalId(animalId);
    }

    public List<VaccinationRecord> getUpcomingReminders() {
        LocalDate nextWeek = LocalDate.now().plusDays(7);
        return repository.findByNextDueDateBefore(nextWeek);
    }
}
