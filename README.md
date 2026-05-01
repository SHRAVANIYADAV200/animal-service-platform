# animal1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


 🐄 Integrated Animal Service Platform for Smart Welfare

📌 Project Overview

The Animal Service Platform is a full-stack application designed to help farmers and rural users access animal healthcare and agricultural services digitally.
It connects users with service providers such as veterinarians and enables efficient management of animal health and services.

---

🚀 Tech Stack

* 📱 Frontend: Flutter
* ☕ Backend: Spring Boot (Java)
* 🗄️ Database: MySQL
* 🔗 API Testing: Postman

---

 📁 Project Structure

* `android/`, `lib/`, etc → Flutter frontend
* `backend/animalservice/` → Spring Boot backend
* `database/animal_service.sql` → Database file
* `postman/` → API collection

---

 ⚙️ Features

* User Registration & Login
* Animal Health Management
* Veterinary Service Booking
* Service Provider Listing
* Database Storage & Retrieval
* REST API Integration

---

 🛠️ How to Run the Project

📱 1. Run Frontend (Flutter)

flutter pub get
flutter run

---

 ☕ 2. Run Backend (Spring Boot)

* Open `backend/animalservice` in IntelliJ
* Run: `AnimalserviceApplication.java`

---

🗄️ 3. Setup Database

1. Open MySQL Workbench
2. Create database:
   animal_service_db
3. Import file:
   database/animal_service.sql

---

🔗 4. Configure Backend

Update `application.properties`:

spring.datasource.url=jdbc:mysql://localhost:3306/animal_service_db
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD

---
📡 5. API Usage

* Backend runs on:
  http://localhost:8080

* For Android Emulator use:
  http://10.0.2.2:8080

---

🧪 6. Postman Testing

1. Open Postman

2. Click on **Import**

3. Select file from:
   `postman/My Collection.postman_collection.json`

4. After importing, you can test APIs like:

   * GET all service providers
   * POST booking
   * GET bookings

5. Make sure backend is running on:
   `http://localhost:8080`



This project provides a scalable and efficient digital solution for livestock management and animal welfare, improving accessibility and service delivery for rural users.
