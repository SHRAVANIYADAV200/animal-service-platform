package com.example.animalservice.repository;

import com.example.animalservice.model.ConsultationNote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConsultationNoteRepository extends JpaRepository<ConsultationNote, Integer> {
    List<ConsultationNote> findByBookingIdOrderByCreatedAtAsc(int bookingId);
    
    @org.springframework.transaction.annotation.Transactional
    void deleteByBookingId(int bookingId);
}
