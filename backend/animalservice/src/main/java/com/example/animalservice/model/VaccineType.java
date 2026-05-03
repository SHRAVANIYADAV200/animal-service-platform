package com.example.animalservice.model;

import jakarta.persistence.*;

@Entity
@Table(name = "vaccine_types")
public class VaccineType {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    public VaccineType() {}
    public VaccineType(String name) { this.name = name; }
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}
