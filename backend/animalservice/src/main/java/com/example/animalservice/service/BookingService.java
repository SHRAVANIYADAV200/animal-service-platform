package com.example.animalservice.service;

import com.example.animalservice.model.Booking;
import com.example.animalservice.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class BookingService {

    @Autowired
    private BookingRepository repository;

    // Create booking
    public Booking createBooking(Booking booking) {
        booking.setStatus("PENDING"); // default status
        return repository.save(booking);
    }

    // Get all bookings (for service provider overview)
    public List<Booking> getAllBookings() {
        return repository.findAll();
    }

    // Get bookings by farmer email
    public List<Booking> getFarmerBookings(String email) {
        return repository.findByFarmerEmail(email);
    }

    // Get bookings by provider email
    public List<Booking> getProviderBookings(String email) {
        return repository.findByProviderEmail(email);
    }

    // Get combined bookings for provider (Pending + Their Accepted)
    public List<Booking> getProviderDashboardBookings(String email) {
        List<Booking> all = repository.findAll();
        return all.stream()
            .filter(b -> b.getStatus().equals("PENDING") || email.equals(b.getProviderEmail()))
            .collect(Collectors.toList());
    }

    // Update booking status (ACCEPT / REJECT)
    public Booking updateStatus(int id, String status, String providerEmail) {
        Booking b = repository.findById(id).orElseThrow();
        b.setStatus(status);
        
        if (status.equals("ACCEPTED")) {
            b.setAppointmentTime("10:30 AM");
            b.setProviderEmail(providerEmail);
        }
        
        return repository.save(b);
    }

    // Get booking stats for a specific provider
    public Map<String, Long> getProviderStats(String email) {
        List<Booking> providerBookings = repository.findByProviderEmail(email);
        long accepted = providerBookings.stream().filter(b -> b.getStatus().equals("ACCEPTED")).count();
        long rejected = providerBookings.stream().filter(b -> b.getStatus().equals("REJECTED")).count();
        long pending = repository.countByStatus("PENDING");
        
        return Map.of(
            "total", accepted + rejected + pending,
            "pending", pending,
            "accepted", accepted,
            "rejected", rejected
        );
    }

    // Legacy global stats
    public Map<String, Long> getStats() {
        return Map.of(
            "total", repository.count(),
            "pending", repository.countByStatus("PENDING"),
            "accepted", repository.countByStatus("ACCEPTED"),
            "rejected", repository.countByStatus("REJECTED")
        );
    }
}