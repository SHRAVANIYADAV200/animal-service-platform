package com.example.animalservice.service;

import com.example.animalservice.model.Review;
import com.example.animalservice.model.ServiceProvider;
import com.example.animalservice.repository.ReviewRepository;
import com.example.animalservice.repository.ServiceProviderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private ServiceProviderRepository providerRepository;

    public Review createReview(Review review) {
        Review saved = reviewRepository.save(review);

        // Recalculate average rating for the provider
        List<Review> allReviews = reviewRepository.findByProviderId(review.getProviderId());
        double avg = allReviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);

        ServiceProvider provider = providerRepository.findById(review.getProviderId()).orElse(null);
        if (provider != null) {
            provider.setAvgRating(Math.round(avg * 10.0) / 10.0);
            providerRepository.save(provider);
        }

        return saved;
    }

    public List<Review> getReviewsByProvider(int providerId) {
        return reviewRepository.findByProviderIdOrderByCreatedAtDesc(providerId);
    }

    public double getAverageRating(int providerId) {
        List<Review> reviews = reviewRepository.findByProviderId(providerId);
        return reviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);
    }
}
