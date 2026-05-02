package com.example.animalservice.controller;

import com.example.animalservice.model.ServiceProvider;
import com.example.animalservice.model.Booking;
import com.example.animalservice.service.ServiceProviderService;
import com.example.animalservice.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.Map;
import java.util.List;

@RestController
@RequestMapping("/api/service-provider")
@CrossOrigin(origins = "*")
public class ServiceProviderController {

    @Autowired
    private ServiceProviderService service;

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

    @GetMapping("/providers")
    public List<ServiceProvider> getAllProviders() {
        return service.getAllProviders();
    }

    @GetMapping("/providers/{id}")
    public ServiceProvider getProviderById(@PathVariable int id) {
        return service.getProviderById(id).orElse(null);
    }

    @GetMapping("/providers/type/{type}")
    public List<ServiceProvider> getProvidersByType(@PathVariable String type) {
        return service.getProvidersByType(type);
    }

    @GetMapping("/providers/government")
    public List<ServiceProvider> getGovernmentProviders(
            @RequestParam(required = false) String district) {
        if (district != null && !district.isEmpty()) {
            return service.getGovernmentProvidersByDistrict(district);
        }
        return service.getProvidersByType("GOVERNMENT");
    }

    @PutMapping("/booking/update/{id}/{status}")
    public Booking updateStatus(
            @PathVariable int id, 
            @PathVariable String status,
            @RequestParam(required = false) String providerEmail) {
        return bookingService.updateStatus(id, status, providerEmail);
    }

    @GetMapping("/test")
    public String test() {
        return "API WORKING";
    }

    @GetMapping("/email/{email}")
    public ServiceProvider getProviderByEmail(@PathVariable String email) {
        return service.findByEmail(email);
    }

    @PutMapping("/update")
    public ServiceProvider updateProfile(@RequestBody ServiceProvider updatedProvider) {
        ServiceProvider existing = service.findByEmail(updatedProvider.getEmail());
        if (existing != null) {
            existing.setName(updatedProvider.getName());
            existing.setSpecialization(updatedProvider.getSpecialization());
            existing.setClinicName(updatedProvider.getClinicName());
            existing.setPhone(updatedProvider.getPhone());
            existing.setConsultationFee(updatedProvider.getConsultationFee());
            existing.setLatitude(updatedProvider.getLatitude());
            existing.setLongitude(updatedProvider.getLongitude());
            return service.save(existing);
        }
        return null;
    }

    @PutMapping("/availability")
    public ServiceProvider updateAvailability(@RequestBody Map<String, Object> payload) {
        String email = (String) payload.get("email");
        boolean isAvailable = (boolean) payload.get("isAvailable");
        ServiceProvider provider = service.findByEmail(email);
        if (provider != null) {
            provider.setAvailable(isAvailable);
            return service.save(provider);
        }
        return null;
    }

    @GetMapping("/seed-markers")
    public String seedMarkers() {
        // Sample coordinates around a central point (Pune/Mumbai area for demo)
        double[][] coords = {
            {18.5204, 73.8567}, // Pune
            {18.5590, 73.8270}, // Aundh
            {18.5089, 73.9259}, // Hadapsar
            {18.5913, 73.7389}, // Hinjewadi
            {19.0760, 72.8777}  // Mumbai
        };
        String[] names = {"Dr. Sharma Vet Clinic", "Paws & Claws", "Happy Pets Hospital", "VetCare Center", "Animal Hope NGO"};
        String[] types = {"PRIVATE", "PRIVATE", "GOVERNMENT", "NGO", "PRIVATE"};

        for (int i = 0; i < names.length; i++) {
            ServiceProvider p = new ServiceProvider();
            p.setName(names[i]);
            p.setEmail("vet" + i + "@example.com");
            p.setPassword("password");
            p.setRole("Service Provider");
            p.setDoctorType(types[i]);
            p.setLatitude(coords[i][0]);
            p.setLongitude(coords[i][1]);
            p.setClinicName(names[i]);
            p.setSpecialization("General Physician");
            service.register(p);
        }
        return "5 Sample Vets Seeded with Map Coordinates!";
    }
}