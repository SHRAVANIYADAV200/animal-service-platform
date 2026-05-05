package com.example.animalservice.repository;

import com.example.animalservice.model.Withdrawal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WithdrawalRepository extends JpaRepository<Withdrawal, Long> {

    List<Withdrawal> findByProviderEmailOrderByCreatedAtDesc(String providerEmail);

    @Query("SELECT COALESCE(SUM(w.amount), 0) FROM Withdrawal w WHERE w.providerEmail = :email AND w.status = 'PROCESSED'")
    Double sumWithdrawnByProvider(@Param("email") String providerEmail);
}
