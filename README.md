# 🐄 Integrated Animal Service Platform for Smart Welfare

The Animal Service Platform is a full-stack solution designed to bridge the gap between farmers and veterinary service providers. It offers real-time booking, GPS-based tracking, professional profile management, and a comprehensive animal healthcare system.

---

## 🚀 Tech Stack

*   **📱 Frontend**: Flutter (Web & Mobile)
*   **☕ Backend**: Spring Boot (Java 17+)
*   **🗄️ Database**: Supabase (PostgreSQL)
*   **📍 Maps**: Google Maps API
*   **🔗 Connection**: REST APIs with SSL support

---

## 📁 Project Structure

*   `/lib` → Flutter frontend logic & UI components
*   `/backend/animalservice` → Spring Boot backend source code
*   `/database` → SQL migration scripts and schemas
*   `/assets` → Static images and icons

---

## 🛠️ Getting Started (How to Run)

### 1. 🗄️ Database Setup (Supabase)
The project is already configured to use a cloud-hosted Supabase PostgreSQL instance. If you need to set up a new one:
1. Create a new project in [Supabase](https://supabase.com/).
2. Run the SQL script found in `database/animal_service.sql` in the Supabase SQL Editor.
3. Obtain your JDBC connection string from the Supabase Settings.

### 2. ☕ Run the Backend (Spring Boot)
1. Navigate to the backend directory:
   ```bash
   cd backend/animalservice
   ```
2. Ensure your `.env` file in the backend root has the correct credentials:
   ```env
   DB_URL=jdbc:postgresql://db.mosatjxgsidunjvtpsku.supabase.co:5432/postgres?sslmode=require
   DB_USERNAME=postgres
   DB_PASSWORD=YOUR_PASSWORD
   GOOGLE_MAPS_API_KEY=YOUR_KEY
   ```
3. Run the application:
   ```bash
   ./mvnw spring-boot:run
   ```
   *The backend will start on `http://localhost:8080`*

### 3. 📱 Run the Frontend (Flutter)
1. Navigate to the project root.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app (Web/Chrome is recommended for testing):
   ```bash
   flutter run -d chrome --web-renderer html
   ```
   *Note: Using `--web-renderer html` is required for proper Google Maps rendering.*

---

## ⚙️ Core Features

*   **👨‍🌾 Farmer Dashboard**: View nearby vets on an interactive map, book appointments, and track animal vaccination records.
*   **👨‍⚕️ Doctor Dashboard**: Manage upcoming schedules, chat with patients, prescribe medications, and update professional profile.
*   **📍 GPS Integration**: Real-time location detection for doctors and farmers.
*   **💬 Consultation System**: Integrated chat, prescription management, and service fee tracking.
*   **⭐ Rating System**: Farmers can rate and review veterinary services after consultations.

---

## 📡 API Endpoints

*   **Auth**: `POST /api/service-provider/login`, `POST /api/service-provider/register`
*   **Providers**: `GET /api/service-provider/providers`, `PUT /api/service-provider/update`
*   **Bookings**: `POST /api/bookings/create`, `GET /api/bookings/provider/{email}`
*   **Reviews**: `POST /api/reviews`, `GET /api/reviews/provider/{id}/rating`

---

## 🧪 Testing
You can import the Postman collection located in `postman/My Collection.postman_collection.json` to test the REST endpoints independently of the UI.
