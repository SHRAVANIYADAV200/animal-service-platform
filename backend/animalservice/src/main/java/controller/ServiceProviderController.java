package com.example.animalservice.controller;

import com.example.animalservice.model.ServiceProvider;
import com.example.animalservice.model.Booking; // ✅ ADD THIS
import com.example.animalservice.service.ServiceProviderService;
import com.example.animalservice.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/service-provider")
@CrossOrigin(origins = "*")
public class ServiceProviderController {

    @Autowired
    private ServiceProviderService service;

    // ✅ FIXED HERE
    @Autowired
    private BookingService bookingService;

    @PostMapping("/register")
    public ServiceProvider register(@RequestBody ServiceProvider provider) {
        return service.register(provider);
    }

    @PostMapping("/login")
    public ServiceProvider login(@RequestBody ServiceProvider provider) {
        return service.login(provider.getEmail(), provider.getPassword());
    }

    @PutMapping("/booking/update/{id}/{status}")
    public Booking updateStatus(@PathVariable int id, @PathVariable String status) {
        return bookingService.updateStatus(id, status);
    }

    @GetMapping("/test")
    public String test() {
        return "API WORKING";
    }
}