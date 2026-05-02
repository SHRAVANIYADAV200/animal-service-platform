package com.example.animalservice.repository;

import com.example.animalservice.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Integer> {

    List<Review> findByProviderId(int providerId);

    List<Review> findByProviderIdOrderByCreatedAtDesc(int providerId);
}
