// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Animal Service Platform';

  @override
  String get splashIntegrated => 'Integrated';

  @override
  String get splashAnimalService => 'Animal Service';

  @override
  String get splashPlatform => 'Platform';

  @override
  String get splashSmartWelfare => 'Smart Welfare';

  @override
  String get signIn => 'Sign In';

  @override
  String get accessAccount => 'Access your account and services';

  @override
  String get animalCare => 'Animal Care';

  @override
  String get tagline => 'Simple. Reliable. Effective.';

  @override
  String get farmer => 'Farmer';

  @override
  String get serviceProvider => 'Service Provider';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get continueBtn => 'Continue';

  @override
  String get newHere => 'New here? ';

  @override
  String get createAccount => 'Create Account';

  @override
  String get fillAllFields => 'Please fill all fields';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get joinUs => 'Join Us';

  @override
  String get joinUsSubtitle => 'Help us provide better care for your animals';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get signUp => 'Sign Up';

  @override
  String get required => 'Required';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get minCharacters => 'Min 6 characters';

  @override
  String get accountCreated => 'Account created! Please login.';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get welcomeBack => 'Welcome back,';

  @override
  String get searchPlaceholder => 'Search for doctors, services...';

  @override
  String get ourServices => 'Our Services';

  @override
  String get consultation => 'Consultation';

  @override
  String get vaccination => 'Vaccination';

  @override
  String get emergency => 'Emergency';

  @override
  String get pharmacy => 'Pharmacy';

  @override
  String get recentAppointments => 'Recent Appointments';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get viewAll => 'View All';

  @override
  String get noActiveAppointments => 'No active appointments';

  @override
  String get schedulePending => 'Schedule Pending';

  @override
  String bookingRequestSent(String service) {
    return '$service booking request sent!';
  }

  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get immediateHelp => 'Immediate help for your animals';

  @override
  String get vetEmergencyHelpline => 'Vet Emergency Helpline';

  @override
  String get districtVetHospital => 'District Veterinary Hospital';

  @override
  String get mobileVetClinic => 'Mobile Vet Clinic';

  @override
  String get home => 'Home';

  @override
  String get doctors => 'Doctors';

  @override
  String get map => 'Map';

  @override
  String get profile => 'Profile';

  @override
  String get dashboard => 'Dashboard';

  @override
  String hello(String name) {
    return 'Hello, $name';
  }

  @override
  String get reviews => 'Reviews';

  @override
  String nReviews(int count) {
    return '$count Reviews';
  }

  @override
  String get pending => 'Pending';

  @override
  String get accepted => 'Accepted';

  @override
  String get completed => 'Completed';

  @override
  String get activeRequests => 'Active Requests';

  @override
  String get noRequestsToday => 'No requests today';

  @override
  String get decline => 'Decline';

  @override
  String get accept => 'Accept';

  @override
  String get medicalHistory => 'Medical History';

  @override
  String get schedule => 'Schedule';

  @override
  String get mySchedule => 'My Schedule';

  @override
  String get onlineVisible => 'Online - Visible on Map';

  @override
  String get offlineHidden => 'Offline - Hidden from Map';

  @override
  String get noAppointmentsForDay => 'No appointments for this day';

  @override
  String get myProfile => 'My Profile';

  @override
  String get editProfessionalProfile => 'Edit Professional Profile';

  @override
  String get logout => 'Logout';

  @override
  String get phone => 'Phone';

  @override
  String get role => 'Role';

  @override
  String get district => 'District';

  @override
  String get notSet => 'Not Set';

  @override
  String get nA => 'N/A';

  @override
  String get editProfile => 'Edit Professional Profile';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get specialization => 'Specialization';

  @override
  String get clinicHospitalName => 'Clinic/Hospital Name';

  @override
  String get contactNumber => 'Contact Number';

  @override
  String get districtCity => 'District / City';

  @override
  String get aboutMeBio => 'About Me / Bio';

  @override
  String get workingHoursLabel => 'Working Hours (e.g. 9AM - 6PM)';

  @override
  String get providerType => 'Provider Type';

  @override
  String get private => 'Private';

  @override
  String get government => 'Government';

  @override
  String get ngo => 'NGO';

  @override
  String get serviceDetails => 'Service Details';

  @override
  String get consultationFee => 'Consultation Fee (₹)';

  @override
  String get locationCoordinates => 'Location (Map Coordinates)';

  @override
  String get getMyCurrentLocation => 'Get My Current Location';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get locationTip =>
      'Tip: You can get these from Google Maps by long-pressing any location.';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileUpdated => 'Profile updated successfully!';

  @override
  String get profileUpdateFailed => 'Failed to update profile.';

  @override
  String get locationUpdated => 'Location updated to your current position!';

  @override
  String get locationFailed =>
      'Could not fetch location. Please check GPS settings.';

  @override
  String get findDoctors => 'Find Doctors';

  @override
  String get all => 'All';

  @override
  String get noDoctorsFound => 'No doctors found';

  @override
  String get aboutDoctor => 'About Doctor';

  @override
  String get noBioProvided => 'No bio provided.';

  @override
  String get clinicName => 'Clinic Name';

  @override
  String get location => 'Location';

  @override
  String get workingHours => 'Working Hours';

  @override
  String get patients => 'Patients';

  @override
  String get experience => 'Experience';

  @override
  String get rating => 'Rating';

  @override
  String get bookAppointment => 'Book Appointment';

  @override
  String get selectAppointmentDate => 'SELECT APPOINTMENT DATE';

  @override
  String get selectAppointmentTime => 'SELECT APPOINTMENT TIME';

  @override
  String get appointmentRequested => 'Appointment Requested!';

  @override
  String requestSentTo(String name) {
    return 'Your request has been sent to $name. You will be notified once they accept.';
  }

  @override
  String get ok => 'OK';

  @override
  String get pleaseLoginToBook => 'Please login to book';

  @override
  String get vaccinationTracking => 'Vaccination Tracking';

  @override
  String nRecords(int count) {
    return '$count Records';
  }

  @override
  String upcomingReminders(int count) {
    return '$count upcoming reminders';
  }

  @override
  String get addRecord => 'Add Record';

  @override
  String get noRecordsYet => 'No records yet';

  @override
  String get vaccine => 'Vaccine';

  @override
  String get givenOn => 'Given on';

  @override
  String get dueOn => 'Due on';

  @override
  String get nextDue => 'Next Due';

  @override
  String get addVaccination => 'Add Vaccination';

  @override
  String get alreadyGiven => 'Already Given';

  @override
  String get setReminder => 'Set Reminder';

  @override
  String get type => 'Type';

  @override
  String get animalName => 'Animal Name (e.g. Cow #1)';

  @override
  String get vaccineName => 'Vaccine Name';

  @override
  String get dateGiven => 'Date Given:';

  @override
  String get today => 'Today';

  @override
  String get reminderDate => 'Reminder Date:';

  @override
  String get nextDueDate => 'Next Due Date:';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get animalPharmacy => 'Animal Pharmacy';

  @override
  String get buy => 'Buy';

  @override
  String get rateConsultation => 'Rate Consultation';

  @override
  String get howWasExperience => 'How was your experience with the doctor?';

  @override
  String get writeComment => 'Write a comment (optional)';

  @override
  String get submit => 'Submit';

  @override
  String get thankYouRating => 'Thank you for your rating!';

  @override
  String get failedRating => 'Failed to submit rating.';

  @override
  String get noTreatmentNotes => 'No treatment notes recorded';

  @override
  String get notesMedications => 'Notes & Medications:';

  @override
  String get viewDetails => 'View Details →';

  @override
  String get noPastAppointments => 'No past appointments found';

  @override
  String get dateUnknown => 'Date Unknown';

  @override
  String get generalConsultation => 'General Consultation';

  @override
  String get searchNearbyVets => 'Search nearby vets...';

  @override
  String get viewAndBook => 'View & Book';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिंदी';

  @override
  String get marathi => 'मराठी';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get veterinarySpecialist => 'Veterinary Specialist';

  @override
  String get chat => 'Chat';

  @override
  String get medical => 'Medical';

  @override
  String get firstAid => 'First Aid';

  @override
  String get prescribeMedication => 'Prescribe Medication';

  @override
  String get medicineName => 'Medicine name';

  @override
  String get dosageInstructions => 'Dosage & instructions';

  @override
  String get addCharge => 'Add Charge';

  @override
  String get chargeDescriptionHint => 'e.g. Consultation fee';

  @override
  String get amount => 'Amount';

  @override
  String get noVaccinationHistory => 'No vaccination history';

  @override
  String get recordVaccination => 'Record Vaccination / Reminder';

  @override
  String get newVaccination => 'New Vaccination / Reminder';

  @override
  String get administeredToday => 'Administered Today';

  @override
  String get setFutureReminder => 'Set Future Reminder';

  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get startConsultation => 'Start the consultation';

  @override
  String get typeMessage => 'Type your message...';

  @override
  String get paymentDue => 'Payment Due';

  @override
  String get payNow => 'Pay Now';

  @override
  String get completePayment => 'Complete Payment';

  @override
  String get confirmCashPayment => 'Confirm Cash Payment';

  @override
  String get cashPaymentConfirmed => 'Cash payment confirmed!';

  @override
  String get medications => 'Medications';

  @override
  String get chargesFees => 'Charges & Fees';

  @override
  String get rateYourDoctor => 'Rate your Doctor';

  @override
  String get total => 'Total';

  @override
  String get patient => 'Patient';

  @override
  String get viewBill => 'View Bill';

  @override
  String get viewBillTooltip => 'View Bill';

  @override
  String get paymentOptionUPI => 'UPI / Net Banking';

  @override
  String get paymentOptionCard => 'Credit / Debit Card';

  @override
  String get paymentOptionCash => 'Pay at Clinic (Cash)';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get confirmCashPaymentSmall => 'Confirm cash payment';

  @override
  String get consultationBill => 'Consultation Bill';

  @override
  String get paymentReceipt => 'PAYMENT RECEIPT';

  @override
  String get transactionDate => 'Transaction Date';

  @override
  String get serviceType => 'Service Type';

  @override
  String get patientId => 'Patient ID';

  @override
  String get totalAmount => 'TOTAL AMOUNT';

  @override
  String get thankYouService => 'Thank you for using Animal Service Platform!';

  @override
  String get close => 'Close';

  @override
  String get downloadPdf => 'Download PDF';
}
