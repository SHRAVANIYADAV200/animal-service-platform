package com.example.animalservice.controller;

import com.example.animalservice.model.Booking;
import com.example.animalservice.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bookings")
@CrossOrigin(origins = "*")
public class BookingController {

    @Autowired
    private BookingService bookingService;

    @PostMapping("/create")
    public Booking createBooking(@RequestBody Booking booking) {
        return bookingService.createBooking(booking);
    }

    @GetMapping("/all")
    public List<Booking> getAllBookings() {
        return bookingService.getAllBookings();
    }

    @GetMapping("/farmer/{email}")
    public List<Booking> getFarmerBookings(@PathVariable String email) {
        return bookingService.getFarmerBookings(email);
    }

    // ✅ VERY IMPORTANT
    @PutMapping("/update/{id}/{status}")
    public Booking updateStatus(@PathVariable int id, @PathVariable String status) {
        return bookingService.updateStatus(id, status);
    }

    // ✅ TEST API
    @GetMapping("/test")
    public String test() {
        return "BOOKING API WORKING";
    }
}