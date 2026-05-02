package com.example.animalservice.controller;

import com.example.animalservice.model.ConsultationNote;
import com.example.animalservice.repository.ConsultationNoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/consultations")
@CrossOrigin(origins = "*")
public class ConsultationNoteController {

    @Autowired
    private ConsultationNoteRepository repository;

    @PostMapping("/note")
    public ConsultationNote addNote(@RequestBody ConsultationNote note) {
        return repository.save(note);
    }

    @GetMapping("/notes/{bookingId}")
    public List<ConsultationNote> getNotes(@PathVariable int bookingId) {
        return repository.findByBookingIdOrderByCreatedAtAsc(bookingId);
    }
}
