import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Animal Service Platform'**
  String get appTitle;

  /// No description provided for @splashIntegrated.
  ///
  /// In en, this message translates to:
  /// **'Integrated'**
  String get splashIntegrated;

  /// No description provided for @splashAnimalService.
  ///
  /// In en, this message translates to:
  /// **'Animal Service'**
  String get splashAnimalService;

  /// No description provided for @splashPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get splashPlatform;

  /// No description provided for @splashSmartWelfare.
  ///
  /// In en, this message translates to:
  /// **'Smart Welfare'**
  String get splashSmartWelfare;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @accessAccount.
  ///
  /// In en, this message translates to:
  /// **'Access your account and services'**
  String get accessAccount;

  /// No description provided for @animalCare.
  ///
  /// In en, this message translates to:
  /// **'Animal Care'**
  String get animalCare;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Simple. Reliable. Effective.'**
  String get tagline;

  /// No description provided for @farmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get farmer;

  /// No description provided for @serviceProvider.
  ///
  /// In en, this message translates to:
  /// **'Service Provider'**
  String get serviceProvider;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @newHere.
  ///
  /// In en, this message translates to:
  /// **'New here? '**
  String get newHere;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredentials;

  /// No description provided for @joinUs.
  ///
  /// In en, this message translates to:
  /// **'Join Us'**
  String get joinUs;

  /// No description provided for @joinUsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us provide better care for your animals'**
  String get joinUsSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @minCharacters.
  ///
  /// In en, this message translates to:
  /// **'Min 6 characters'**
  String get minCharacters;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created! Please login.'**
  String get accountCreated;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search for doctors, services...'**
  String get searchPlaceholder;

  /// No description provided for @ourServices.
  ///
  /// In en, this message translates to:
  /// **'Our Services'**
  String get ourServices;

  /// No description provided for @consultation.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get consultation;

  /// No description provided for @vaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get vaccination;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @pharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get pharmacy;

  /// No description provided for @recentAppointments.
  ///
  /// In en, this message translates to:
  /// **'Recent Appointments'**
  String get recentAppointments;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noActiveAppointments.
  ///
  /// In en, this message translates to:
  /// **'No active appointments'**
  String get noActiveAppointments;

  /// No description provided for @schedulePending.
  ///
  /// In en, this message translates to:
  /// **'Schedule Pending'**
  String get schedulePending;

  /// No description provided for @bookingRequestSent.
  ///
  /// In en, this message translates to:
  /// **'{service} booking request sent!'**
  String bookingRequestSent(String service);

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @immediateHelp.
  ///
  /// In en, this message translates to:
  /// **'Immediate help for your animals'**
  String get immediateHelp;

  /// No description provided for @vetEmergencyHelpline.
  ///
  /// In en, this message translates to:
  /// **'Vet Emergency Helpline'**
  String get vetEmergencyHelpline;

  /// No description provided for @districtVetHospital.
  ///
  /// In en, this message translates to:
  /// **'District Veterinary Hospital'**
  String get districtVetHospital;

  /// No description provided for @mobileVetClinic.
  ///
  /// In en, this message translates to:
  /// **'Mobile Vet Clinic'**
  String get mobileVetClinic;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @doctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String hello(String name);

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @nReviews.
  ///
  /// In en, this message translates to:
  /// **'{count} Reviews'**
  String nReviews(int count);

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @activeRequests.
  ///
  /// In en, this message translates to:
  /// **'Active Requests'**
  String get activeRequests;

  /// No description provided for @noRequestsToday.
  ///
  /// In en, this message translates to:
  /// **'No requests today'**
  String get noRequestsToday;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @medicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistory;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @mySchedule.
  ///
  /// In en, this message translates to:
  /// **'My Schedule'**
  String get mySchedule;

  /// No description provided for @onlineVisible.
  ///
  /// In en, this message translates to:
  /// **'Online - Visible on Map'**
  String get onlineVisible;

  /// No description provided for @offlineHidden.
  ///
  /// In en, this message translates to:
  /// **'Offline - Hidden from Map'**
  String get offlineHidden;

  /// No description provided for @noAppointmentsForDay.
  ///
  /// In en, this message translates to:
  /// **'No appointments for this day'**
  String get noAppointmentsForDay;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @editProfessionalProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Professional Profile'**
  String get editProfessionalProfile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not Set'**
  String get notSet;

  /// No description provided for @nA.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get nA;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Professional Profile'**
  String get editProfile;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;

  /// No description provided for @clinicHospitalName.
  ///
  /// In en, this message translates to:
  /// **'Clinic/Hospital Name'**
  String get clinicHospitalName;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumber;

  /// No description provided for @districtCity.
  ///
  /// In en, this message translates to:
  /// **'District / City'**
  String get districtCity;

  /// No description provided for @aboutMeBio.
  ///
  /// In en, this message translates to:
  /// **'About Me / Bio'**
  String get aboutMeBio;

  /// No description provided for @workingHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Working Hours (e.g. 9AM - 6PM)'**
  String get workingHoursLabel;

  /// No description provided for @providerType.
  ///
  /// In en, this message translates to:
  /// **'Provider Type'**
  String get providerType;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @government.
  ///
  /// In en, this message translates to:
  /// **'Government'**
  String get government;

  /// No description provided for @ngo.
  ///
  /// In en, this message translates to:
  /// **'NGO'**
  String get ngo;

  /// No description provided for @serviceDetails.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get serviceDetails;

  /// No description provided for @consultationFee.
  ///
  /// In en, this message translates to:
  /// **'Consultation Fee (₹)'**
  String get consultationFee;

  /// No description provided for @locationCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Location (Map Coordinates)'**
  String get locationCoordinates;

  /// No description provided for @getMyCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Get My Current Location'**
  String get getMyCurrentLocation;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @locationTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: You can get these from Google Maps by long-pressing any location.'**
  String get locationTip;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdated;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile.'**
  String get profileUpdateFailed;

  /// No description provided for @locationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Location updated to your current position!'**
  String get locationUpdated;

  /// No description provided for @locationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not fetch location. Please check GPS settings.'**
  String get locationFailed;

  /// No description provided for @findDoctors.
  ///
  /// In en, this message translates to:
  /// **'Find Doctors'**
  String get findDoctors;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @noDoctorsFound.
  ///
  /// In en, this message translates to:
  /// **'No doctors found'**
  String get noDoctorsFound;

  /// No description provided for @aboutDoctor.
  ///
  /// In en, this message translates to:
  /// **'About Doctor'**
  String get aboutDoctor;

  /// No description provided for @noBioProvided.
  ///
  /// In en, this message translates to:
  /// **'No bio provided.'**
  String get noBioProvided;

  /// No description provided for @clinicName.
  ///
  /// In en, this message translates to:
  /// **'Clinic Name'**
  String get clinicName;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @workingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get workingHours;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// No description provided for @selectAppointmentDate.
  ///
  /// In en, this message translates to:
  /// **'SELECT APPOINTMENT DATE'**
  String get selectAppointmentDate;

  /// No description provided for @selectAppointmentTime.
  ///
  /// In en, this message translates to:
  /// **'SELECT APPOINTMENT TIME'**
  String get selectAppointmentTime;

  /// No description provided for @appointmentRequested.
  ///
  /// In en, this message translates to:
  /// **'Appointment Requested!'**
  String get appointmentRequested;

  /// No description provided for @requestSentTo.
  ///
  /// In en, this message translates to:
  /// **'Your request has been sent to {name}. You will be notified once they accept.'**
  String requestSentTo(String name);

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @pleaseLoginToBook.
  ///
  /// In en, this message translates to:
  /// **'Please login to book'**
  String get pleaseLoginToBook;

  /// No description provided for @vaccinationTracking.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Tracking'**
  String get vaccinationTracking;

  /// No description provided for @nRecords.
  ///
  /// In en, this message translates to:
  /// **'{count} Records'**
  String nRecords(int count);

  /// No description provided for @upcomingReminders.
  ///
  /// In en, this message translates to:
  /// **'{count} upcoming reminders'**
  String upcomingReminders(int count);

  /// No description provided for @addRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get addRecord;

  /// No description provided for @noRecordsYet.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get noRecordsYet;

  /// No description provided for @vaccine.
  ///
  /// In en, this message translates to:
  /// **'Vaccine'**
  String get vaccine;

  /// No description provided for @givenOn.
  ///
  /// In en, this message translates to:
  /// **'Given on'**
  String get givenOn;

  /// No description provided for @dueOn.
  ///
  /// In en, this message translates to:
  /// **'Due on'**
  String get dueOn;

  /// No description provided for @nextDue.
  ///
  /// In en, this message translates to:
  /// **'Next Due'**
  String get nextDue;

  /// No description provided for @addVaccination.
  ///
  /// In en, this message translates to:
  /// **'Add Vaccination'**
  String get addVaccination;

  /// No description provided for @alreadyGiven.
  ///
  /// In en, this message translates to:
  /// **'Already Given'**
  String get alreadyGiven;

  /// No description provided for @setReminder.
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get setReminder;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @animalName.
  ///
  /// In en, this message translates to:
  /// **'Animal Name (e.g. Cow #1)'**
  String get animalName;

  /// No description provided for @vaccineName.
  ///
  /// In en, this message translates to:
  /// **'Vaccine Name'**
  String get vaccineName;

  /// No description provided for @dateGiven.
  ///
  /// In en, this message translates to:
  /// **'Date Given:'**
  String get dateGiven;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @reminderDate.
  ///
  /// In en, this message translates to:
  /// **'Reminder Date:'**
  String get reminderDate;

  /// No description provided for @nextDueDate.
  ///
  /// In en, this message translates to:
  /// **'Next Due Date:'**
  String get nextDueDate;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @animalPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Animal Pharmacy'**
  String get animalPharmacy;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @rateConsultation.
  ///
  /// In en, this message translates to:
  /// **'Rate Consultation'**
  String get rateConsultation;

  /// No description provided for @howWasExperience.
  ///
  /// In en, this message translates to:
  /// **'How was your experience with the doctor?'**
  String get howWasExperience;

  /// No description provided for @writeComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment (optional)'**
  String get writeComment;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @thankYouRating.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your rating!'**
  String get thankYouRating;

  /// No description provided for @failedRating.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit rating.'**
  String get failedRating;

  /// No description provided for @noTreatmentNotes.
  ///
  /// In en, this message translates to:
  /// **'No treatment notes recorded'**
  String get noTreatmentNotes;

  /// No description provided for @notesMedications.
  ///
  /// In en, this message translates to:
  /// **'Notes & Medications:'**
  String get notesMedications;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details →'**
  String get viewDetails;

  /// No description provided for @noPastAppointments.
  ///
  /// In en, this message translates to:
  /// **'No past appointments found'**
  String get noPastAppointments;

  /// No description provided for @dateUnknown.
  ///
  /// In en, this message translates to:
  /// **'Date Unknown'**
  String get dateUnknown;

  /// No description provided for @generalConsultation.
  ///
  /// In en, this message translates to:
  /// **'General Consultation'**
  String get generalConsultation;

  /// No description provided for @searchNearbyVets.
  ///
  /// In en, this message translates to:
  /// **'Search nearby vets...'**
  String get searchNearbyVets;

  /// No description provided for @viewAndBook.
  ///
  /// In en, this message translates to:
  /// **'View & Book'**
  String get viewAndBook;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिंदी'**
  String get hindi;

  /// No description provided for @marathi.
  ///
  /// In en, this message translates to:
  /// **'मराठी'**
  String get marathi;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @veterinarySpecialist.
  ///
  /// In en, this message translates to:
  /// **'Veterinary Specialist'**
  String get veterinarySpecialist;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @medical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get medical;

  /// No description provided for @firstAid.
  ///
  /// In en, this message translates to:
  /// **'First Aid'**
  String get firstAid;

  /// No description provided for @prescribeMedication.
  ///
  /// In en, this message translates to:
  /// **'Prescribe Medication'**
  String get prescribeMedication;

  /// No description provided for @medicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine name'**
  String get medicineName;

  /// No description provided for @dosageInstructions.
  ///
  /// In en, this message translates to:
  /// **'Dosage & instructions'**
  String get dosageInstructions;

  /// No description provided for @addCharge.
  ///
  /// In en, this message translates to:
  /// **'Add Charge'**
  String get addCharge;

  /// No description provided for @chargeDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Consultation fee'**
  String get chargeDescriptionHint;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @noVaccinationHistory.
  ///
  /// In en, this message translates to:
  /// **'No vaccination history'**
  String get noVaccinationHistory;

  /// No description provided for @recordVaccination.
  ///
  /// In en, this message translates to:
  /// **'Record Vaccination / Reminder'**
  String get recordVaccination;

  /// No description provided for @newVaccination.
  ///
  /// In en, this message translates to:
  /// **'New Vaccination / Reminder'**
  String get newVaccination;

  /// No description provided for @administeredToday.
  ///
  /// In en, this message translates to:
  /// **'Administered Today'**
  String get administeredToday;

  /// No description provided for @setFutureReminder.
  ///
  /// In en, this message translates to:
  /// **'Set Future Reminder'**
  String get setFutureReminder;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @startConsultation.
  ///
  /// In en, this message translates to:
  /// **'Start the consultation'**
  String get startConsultation;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeMessage;

  /// No description provided for @paymentDue.
  ///
  /// In en, this message translates to:
  /// **'Payment Due'**
  String get paymentDue;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @completePayment.
  ///
  /// In en, this message translates to:
  /// **'Complete Payment'**
  String get completePayment;

  /// No description provided for @confirmCashPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cash Payment'**
  String get confirmCashPayment;

  /// No description provided for @cashPaymentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Cash payment confirmed!'**
  String get cashPaymentConfirmed;

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// No description provided for @chargesFees.
  ///
  /// In en, this message translates to:
  /// **'Charges & Fees'**
  String get chargesFees;

  /// No description provided for @rateYourDoctor.
  ///
  /// In en, this message translates to:
  /// **'Rate your Doctor'**
  String get rateYourDoctor;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// No description provided for @viewBill.
  ///
  /// In en, this message translates to:
  /// **'View Bill'**
  String get viewBill;

  /// No description provided for @viewBillTooltip.
  ///
  /// In en, this message translates to:
  /// **'View Bill'**
  String get viewBillTooltip;

  /// No description provided for @paymentOptionUPI.
  ///
  /// In en, this message translates to:
  /// **'UPI / Net Banking'**
  String get paymentOptionUPI;

  /// No description provided for @paymentOptionCard.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get paymentOptionCard;

  /// No description provided for @paymentOptionCash.
  ///
  /// In en, this message translates to:
  /// **'Pay at Clinic (Cash)'**
  String get paymentOptionCash;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @confirmCashPaymentSmall.
  ///
  /// In en, this message translates to:
  /// **'Confirm cash payment'**
  String get confirmCashPaymentSmall;

  /// No description provided for @consultationBill.
  ///
  /// In en, this message translates to:
  /// **'Consultation Bill'**
  String get consultationBill;

  /// No description provided for @paymentReceipt.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT RECEIPT'**
  String get paymentReceipt;

  /// No description provided for @transactionDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get transactionDate;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// No description provided for @patientId.
  ///
  /// In en, this message translates to:
  /// **'Patient ID'**
  String get patientId;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'TOTAL AMOUNT'**
  String get totalAmount;

  /// No description provided for @thankYouService.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using Animal Service Platform!'**
  String get thankYouService;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
