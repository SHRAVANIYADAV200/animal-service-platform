package com.example.animalservice.controller;

import com.example.animalservice.model.Review;
import com.example.animalservice.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/reviews")
@CrossOrigin(origins = "*")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @PostMapping
    public Review createReview(@RequestBody Review review) {
        return reviewService.createReview(review);
    }

    @GetMapping("/provider/{providerId}")
    public List<Review> getProviderReviews(@PathVariable int providerId) {
        return reviewService.getReviewsByProvider(providerId);
    }

    @GetMapping("/provider/{providerId}/rating")
    public Map<String, Object> getProviderRating(@PathVariable int providerId) {
        double avg = reviewService.getAverageRating(providerId);
        int count = reviewService.getReviewsByProvider(providerId).size();
        return Map.of("averageRating", avg, "totalReviews", count);
    }
}
