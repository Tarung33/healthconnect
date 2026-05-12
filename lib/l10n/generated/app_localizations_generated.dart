import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_generated_en.dart';
import 'app_localizations_generated_hi.dart';
import 'app_localizations_generated_kn.dart';
import 'app_localizations_generated_pa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizationsGenerated
/// returned by `AppLocalizationsGenerated.of(context)`.
///
/// Applications need to include `AppLocalizationsGenerated.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations_generated.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizationsGenerated.localizationsDelegates,
///   supportedLocales: AppLocalizationsGenerated.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizationsGenerated.supportedLocales
/// property.
abstract class AppLocalizationsGenerated {
  AppLocalizationsGenerated(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizationsGenerated of(BuildContext context) {
    return Localizations.of<AppLocalizationsGenerated>(
        context, AppLocalizationsGenerated)!;
  }

  static const LocalizationsDelegate<AppLocalizationsGenerated> delegate =
      _AppLocalizationsGeneratedDelegate();

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
    Locale('kn'),
    Locale('pa')
  ];

  /// Application name displayed across the app
  ///
  /// In en, this message translates to:
  /// **'A2Z HealthConnect'**
  String get appName;

  /// App tagline shown on splash and onboarding
  ///
  /// In en, this message translates to:
  /// **'Healthcare at your fingertips'**
  String get appTagline;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @found.
  ///
  /// In en, this message translates to:
  /// **'found'**
  String get found;

  /// Connectivity status when connected
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// Banner message when device is offline
  ///
  /// In en, this message translates to:
  /// **'You are offline. Data saved locally.'**
  String get offline;

  /// No description provided for @offlineShort.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offlineShort;

  /// No description provided for @syncedOnline.
  ///
  /// In en, this message translates to:
  /// **'Synced online'**
  String get syncedOnline;

  /// First onboarding page title
  ///
  /// In en, this message translates to:
  /// **'Connect with Doctors'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Consult qualified doctors from your village via video or voice call, anytime.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'AI Health Assistant'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Describe your symptoms and get instant guidance powered by AI technology.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Works Offline'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Access your health records and medicine info even without internet.'**
  String get onboardingDesc3;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Language selection screen title
  ///
  /// In en, this message translates to:
  /// **'Select Your Language'**
  String get selectLanguage;

  /// No description provided for @selectLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose the language you are comfortable with'**
  String get selectLanguageDesc;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get languageChanged;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter 10-digit phone number'**
  String get enterPhone;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to your phone'**
  String get otpSent;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @loginWithAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Continue with Aadhaar / ABHA ID'**
  String get loginWithAadhaar;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get createAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get haveAccount;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get invalidOtp;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @mockOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Mock OTP: 123456'**
  String get mockOtpHint;

  /// Aadhaar login screen title
  ///
  /// In en, this message translates to:
  /// **'Aadhaar / Health ID Login'**
  String get aadhaarLogin;

  /// No description provided for @aadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Number'**
  String get aadhaarNumber;

  /// No description provided for @enterAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Enter 12-digit Aadhaar number'**
  String get enterAadhaar;

  /// No description provided for @abhaId.
  ///
  /// In en, this message translates to:
  /// **'ABHA Health ID'**
  String get abhaId;

  /// No description provided for @enterAbha.
  ///
  /// In en, this message translates to:
  /// **'Enter your ABHA ID'**
  String get enterAbha;

  /// No description provided for @verifyIdentity.
  ///
  /// In en, this message translates to:
  /// **'Verify Identity'**
  String get verifyIdentity;

  /// No description provided for @aadhaarNote.
  ///
  /// In en, this message translates to:
  /// **'Your Aadhaar data is secure and encrypted'**
  String get aadhaarNote;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed. Please check your details.'**
  String get verificationFailed;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @consultDoctor.
  ///
  /// In en, this message translates to:
  /// **'Consult Doctor'**
  String get consultDoctor;

  /// No description provided for @checkSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Check Symptoms'**
  String get checkSymptoms;

  /// No description provided for @myRecords.
  ///
  /// In en, this message translates to:
  /// **'My Records'**
  String get myRecords;

  /// No description provided for @medicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicines;

  /// No description provided for @upcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppointments;

  /// No description provided for @noAppointments.
  ///
  /// In en, this message translates to:
  /// **'No upcoming appointments'**
  String get noAppointments;

  /// No description provided for @healthTips.
  ///
  /// In en, this message translates to:
  /// **'Health Tips'**
  String get healthTips;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// Health tip about hydration
  ///
  /// In en, this message translates to:
  /// **'Drink 8 glasses of water daily'**
  String get healthTipWater;

  /// No description provided for @healthTipWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk 30 minutes every day'**
  String get healthTipWalk;

  /// No description provided for @healthTipFruits.
  ///
  /// In en, this message translates to:
  /// **'Eat seasonal fruits & vegetables'**
  String get healthTipFruits;

  /// No description provided for @healthTipSleep.
  ///
  /// In en, this message translates to:
  /// **'Get 7-8 hours of sleep'**
  String get healthTipSleep;

  /// Bottom navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navConsult.
  ///
  /// In en, this message translates to:
  /// **'Consult'**
  String get navConsult;

  /// No description provided for @navAiCheck.
  ///
  /// In en, this message translates to:
  /// **'AI Check'**
  String get navAiCheck;

  /// No description provided for @navRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get navRecords;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @availableDoctors.
  ///
  /// In en, this message translates to:
  /// **'Available Doctors'**
  String get availableDoctors;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @consultationFee.
  ///
  /// In en, this message translates to:
  /// **'Consultation Fee'**
  String get consultationFee;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @videoCall.
  ///
  /// In en, this message translates to:
  /// **'Video Call'**
  String get videoCall;

  /// No description provided for @voiceCall.
  ///
  /// In en, this message translates to:
  /// **'Voice Call'**
  String get voiceCall;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @doctorDetails.
  ///
  /// In en, this message translates to:
  /// **'Doctor Details'**
  String get doctorDetails;

  /// No description provided for @generalPhysician.
  ///
  /// In en, this message translates to:
  /// **'General Physician'**
  String get generalPhysician;

  /// No description provided for @pediatrician.
  ///
  /// In en, this message translates to:
  /// **'Pediatrician'**
  String get pediatrician;

  /// No description provided for @gynecologist.
  ///
  /// In en, this message translates to:
  /// **'Gynecologist'**
  String get gynecologist;

  /// No description provided for @dermatologist.
  ///
  /// In en, this message translates to:
  /// **'Dermatologist'**
  String get dermatologist;

  /// No description provided for @noDoctorsFound.
  ///
  /// In en, this message translates to:
  /// **'No doctors found'**
  String get noDoctorsFound;

  /// No description provided for @bookingWith.
  ///
  /// In en, this message translates to:
  /// **'Booking with'**
  String get bookingWith;

  /// Symptom checker screen title
  ///
  /// In en, this message translates to:
  /// **'AI Symptom Checker'**
  String get symptomChecker;

  /// No description provided for @symptomCheckerDesc.
  ///
  /// In en, this message translates to:
  /// **'Select your symptoms to get AI-powered health guidance'**
  String get symptomCheckerDesc;

  /// No description provided for @selectSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Select Symptoms'**
  String get selectSymptoms;

  /// No description provided for @commonSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Common Symptoms'**
  String get commonSymptoms;

  /// No description provided for @selectedSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Selected Symptoms'**
  String get selectedSymptoms;

  /// No description provided for @checkNow.
  ///
  /// In en, this message translates to:
  /// **'Check Now'**
  String get checkNow;

  /// No description provided for @aiResult.
  ///
  /// In en, this message translates to:
  /// **'AI Assessment'**
  String get aiResult;

  /// No description provided for @aiDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is AI guidance only. Please consult a doctor for accurate diagnosis.'**
  String get aiDisclaimer;

  /// No description provided for @fever.
  ///
  /// In en, this message translates to:
  /// **'Fever'**
  String get fever;

  /// No description provided for @headache.
  ///
  /// In en, this message translates to:
  /// **'Headache'**
  String get headache;

  /// No description provided for @cough.
  ///
  /// In en, this message translates to:
  /// **'Cough'**
  String get cough;

  /// No description provided for @cold.
  ///
  /// In en, this message translates to:
  /// **'Cold'**
  String get cold;

  /// No description provided for @bodyPain.
  ///
  /// In en, this message translates to:
  /// **'Body Pain'**
  String get bodyPain;

  /// No description provided for @stomachPain.
  ///
  /// In en, this message translates to:
  /// **'Stomach Pain'**
  String get stomachPain;

  /// No description provided for @vomiting.
  ///
  /// In en, this message translates to:
  /// **'Vomiting'**
  String get vomiting;

  /// No description provided for @diarrhea.
  ///
  /// In en, this message translates to:
  /// **'Diarrhea'**
  String get diarrhea;

  /// No description provided for @fatigue.
  ///
  /// In en, this message translates to:
  /// **'Fatigue'**
  String get fatigue;

  /// No description provided for @soreThroat.
  ///
  /// In en, this message translates to:
  /// **'Sore Throat'**
  String get soreThroat;

  /// No description provided for @breathingDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Breathing Difficulty'**
  String get breathingDifficulty;

  /// No description provided for @chestPain.
  ///
  /// In en, this message translates to:
  /// **'Chest Pain'**
  String get chestPain;

  /// No description provided for @skinRash.
  ///
  /// In en, this message translates to:
  /// **'Skin Rash'**
  String get skinRash;

  /// No description provided for @jointPain.
  ///
  /// In en, this message translates to:
  /// **'Joint Pain'**
  String get jointPain;

  /// No description provided for @dizziness.
  ///
  /// In en, this message translates to:
  /// **'Dizziness'**
  String get dizziness;

  /// No description provided for @lossOfAppetite.
  ///
  /// In en, this message translates to:
  /// **'Loss of Appetite'**
  String get lossOfAppetite;

  /// AI result for 4+ symptoms
  ///
  /// In en, this message translates to:
  /// **'Based on your symptoms, this could indicate a viral infection. Please consult a doctor within 24 hours. Stay hydrated and rest. If you experience breathing difficulty, seek immediate medical attention.'**
  String get aiResultSevere;

  /// No description provided for @aiResultModerate.
  ///
  /// In en, this message translates to:
  /// **'Your symptoms suggest a common cold or mild infection. Take rest, drink warm fluids, and monitor for 2-3 days. If symptoms worsen, please consult a doctor.'**
  String get aiResultModerate;

  /// No description provided for @aiResultMild.
  ///
  /// In en, this message translates to:
  /// **'Your symptom appears mild. Monitor for changes over the next 24-48 hours. Maintain good hygiene and stay hydrated. Consult a doctor if the condition persists.'**
  String get aiResultMild;

  /// No description provided for @healthRecords.
  ///
  /// In en, this message translates to:
  /// **'Health Records'**
  String get healthRecords;

  /// No description provided for @savedOffline.
  ///
  /// In en, this message translates to:
  /// **'Saved Offline'**
  String get savedOffline;

  /// No description provided for @prescriptions.
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get prescriptions;

  /// No description provided for @labReports.
  ///
  /// In en, this message translates to:
  /// **'Lab Reports'**
  String get labReports;

  /// No description provided for @vaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get vaccination;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No records saved yet'**
  String get noRecords;

  /// No description provided for @addRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get addRecord;

  /// No description provided for @recordDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get recordDate;

  /// No description provided for @recordDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get recordDoctor;

  /// No description provided for @recordDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get recordDiagnosis;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @addRecordComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Add record feature coming soon'**
  String get addRecordComingSoon;

  /// No description provided for @medicineAvailability.
  ///
  /// In en, this message translates to:
  /// **'Medicine Availability'**
  String get medicineAvailability;

  /// No description provided for @searchMedicine.
  ///
  /// In en, this message translates to:
  /// **'Search medicine name'**
  String get searchMedicine;

  /// No description provided for @nearbyStores.
  ///
  /// In en, this message translates to:
  /// **'Nearby Stores'**
  String get nearbyStores;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @genericAvailable.
  ///
  /// In en, this message translates to:
  /// **'Generic Available'**
  String get genericAvailable;

  /// No description provided for @storeName.
  ///
  /// In en, this message translates to:
  /// **'Store Name'**
  String get storeName;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @noMedicinesFound.
  ///
  /// In en, this message translates to:
  /// **'No medicines found'**
  String get noMedicinesFound;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @village.
  ///
  /// In en, this message translates to:
  /// **'Village / Town'**
  String get village;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @notificationsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Notifications settings coming soon'**
  String get notificationsComingSoon;

  /// No description provided for @helpComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Help & Support coming soon'**
  String get helpComingSoon;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @logoutConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'You will need to login again.'**
  String get logoutConfirmDesc;
}

class _AppLocalizationsGeneratedDelegate
    extends LocalizationsDelegate<AppLocalizationsGenerated> {
  const _AppLocalizationsGeneratedDelegate();

  @override
  Future<AppLocalizationsGenerated> load(Locale locale) {
    return SynchronousFuture<AppLocalizationsGenerated>(
        lookupAppLocalizationsGenerated(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'kn', 'pa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsGeneratedDelegate old) => false;
}

AppLocalizationsGenerated lookupAppLocalizationsGenerated(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsGeneratedEn();
    case 'hi':
      return AppLocalizationsGeneratedHi();
    case 'kn':
      return AppLocalizationsGeneratedKn();
    case 'pa':
      return AppLocalizationsGeneratedPa();
  }

  throw FlutterError(
      'AppLocalizationsGenerated.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
