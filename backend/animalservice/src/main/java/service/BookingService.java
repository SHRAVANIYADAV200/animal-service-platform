package com.example.animalservice.service;

import com.example.animalservice.model.Booking;
import com.example.animalservice.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookingService {

    @Autowired
    private BookingRepository repository;

    // Create booking
    public Booking createBooking(Booking booking) {
        booking.setStatus("PENDING"); // default status
        return repository.save(booking);
    }

    // Get all bookings (for service provider)
    public List<Booking> getAllBookings() {
        return repository.findAll();
    }

    // Get bookings by farmer email
    public List<Booking> getFarmerBookings(String email) {
        return repository.findByFarmerEmail(email);
    }

    // Update booking status (ACCEPT / REJECT)
    public Booking updateStatus(int id, String status) {
        Booking b = repository.findById(id).orElseThrow();

        b.setStatus(status);

        // 👇 ADD TIME WHEN ACCEPTED
        if (status.equals("ACCEPTED")) {
            b.setAppointmentTime("10:30 AM");
        }

        return repository.save(b);
    }
}