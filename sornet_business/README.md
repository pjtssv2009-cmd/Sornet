# SORNET — Business Mobile Application

**SORNET Business** is a production-grade, functional Android mobile application built with Flutter for companies, service agencies, and HVAC/facility contractors to hire, evaluate, manage, and communicate with skilled technicians.

---

## 📱 APK Distribution & Binaries

Pre-compiled Android APK binaries are ready for direct installation on physical Android devices or emulators (Android 5.0+ / API 21+):

| APK Target | File Location | Size | Description |
| :--- | :--- | :--- | :--- |
| **Production Release APK** | `release_apks/sornet-business-release.apk`<br>`sornet_business/build/app/outputs/apk/release/app-release.apk` | **25.7 MB** | Optimized, tree-shaken, signed release binary |
| **Developer Debug APK** | `release_apks/sornet-business-debug.apk`<br>`sornet_business/build/app/outputs/apk/debug/app-debug.apk` | **72.1 MB** | Unobfuscated debug build with Flutter DevTools support |

---

## 🔐 Demo Credentials

Use the following credentials on the login screen, or tap the **"1-Tap Fill Demo Business"** quick-login button:

| Field | Value | Notes |
| :--- | :--- | :--- |
| **Email** | `business@sornet.com` | Pre-configured verified business account |
| **Password** | `Business@123` | Default demo password |
| **Alternative Account** | `contact@apexsolutions.in` / `Business@123` | Multi-location Enterprise tier account |

---

## 🎨 Design System & Aesthetics

- **Strict Light Mode Only**: Crisp, professional light UI designed for daylight readability and enterprise clarity.
- **Color Palette**:
  - **Primary**: Royal Blue (`#155EEF` / `RGB(21, 94, 239)`)
  - **Secondary**: Sky Blue (`#38BDF8` / `RGB(56, 189, 248)`)
  - **Accent / Dark**: Deep Navy (`#0A2540` / `RGB(10, 37, 64)`)
  - **Backgrounds**: Pure Crisp White (`#FFFFFF`), Soft Ice Blue Canvas (`#F8FAFC` & `#F0F7FF`)
  - **Status Accents**: Emerald Green (`#12B76A`), Amber Warning (`#F79009`), Crimson Red (`#F04438`), Indigo Violet (`#7C3AED`)
- **Typography**: Google Fonts Inter with calibrated hierarchy, badge geometry, and responsive touch targets (min 48dp).

---

## 🚀 Key Feature Modules

### 1. Authentication & Onboarding
- Business Login with email/password and 1-tap demo filling.
- OTP Verification screen with auto-countdown timer.
- Forgot Password / Password Reset workflow.
- **6-Step Business Registration Wizard**:
  - Step 1: Company Profile (Legal name, registration type, contact person, phone, email).
  - Step 2: Operating Address & Cities (State, city, pincode, service radius).
  - Step 3: Business Details (Years active, employee headcount, service categories).
  - Step 4: Specialization & Trade Matrix (Split AC, Cassette, VRF/VRV, Inverter, PCB repair, brands).
  - Step 5: Document Uploads (GSTIN certificate, Trade License, Identity verification).
  - Step 6: Security & Credentials Setup (Password creation, terms agreement).

### 2. Business Dashboard & Command Shell
- Quick KPI metrics: Active Job Postings, Total Applicants, Shortlisted Candidates, Upcoming Interviews, Active Offers, Hired Technicians.
- Quick action shortcuts: Post New Requirement, Search Techs, Review Applications, Schedule Interview, Upgrade Plan.
- Upcoming interview reminders ticker with countdown timers.
- Recent applicants list with fast candidate preview and shortlisting.

### 3. Job Requirements Posting & Management
- Multi-step Job Creation Wizard:
  - Role Title, AC Sub-specialization, vacancies count, joining urgency.
  - Required skills and technical expertise (Inverter, Dual Inverter, PCB repair).
  - Brand proficiencies required (Daikin, Voltas, LG, Mitsubishi, Blue Star, etc.).
  - Location, city, and salary ranges (monthly/daily/per-job).
  - Company benefits (PF, Insurance, Fuel allowance, Tool kit provided, Accommodation).
- Interactive Job Preview screen prior to publishing.
- Job status filtering (Active, Draft, Closed).
- Job detail screen with applicants breakdown, metrics, and actions to close or edit.

### 4. Technician Search & Candidate Discovery
- Real-time search with instant filtering by:
  - Trade & AC Specialization (Split AC, Cassette AC, VRF/VRV, Duct AC).
  - Technical Skills (Inverter, Non-Inverter, PCB Board Repair).
  - Brand Expertise (Daikin, Voltas, LG, Samsung, Blue Star, Carrier, Hitachi).
  - City / Location, Minimum Experience (Years), Minimum Rating (Stars), Verified Only toggle.
  - Sorting: Top Rated, Highest Trust Score, Most Experienced, Expected Salary.
- Deep Technician Profile Viewer:
  - Trust score & verified badge breakdown.
  - Skill chips & brand tags.
  - Work history & experience cards.
  - Government ID & technical certification verification badges.
  - Client reviews & multi-category star ratings.
- **Side-by-Side Candidate Comparison Tool**:
  - Compare 2 to 4 candidates simultaneously across experience, trust score, ratings, expected salary, availability, and brand skills.

### 5. Application Pipeline & Shortlisting
- Tabbed candidate review: All Applications, Shortlisted, In Review, Rejected.
- Candidate card with experience, expected salary, current city, and match percentage.
- 1-tap candidate actions: Shortlist, Schedule Interview, Send Offer, Reject with remarks.

### 6. Interview Scheduler & Tracker
- Schedule In-Person, Video Call, or Phone interviews.
- Date and time picker with calendar sync reminder.
- Location address or video conference URL generator.
- Interview notes, preparation instructions, and status updating (Scheduled, Completed, Rescheduled, Cancelled).

### 7. Direct Real-Time Messaging & Chat
- In-app chat threads between business hiring managers and candidates.
- Instant messaging with read receipts, timestamps, and active status indicators.
- Quick-reply action buttons for interview invites and offer follow-ups.

### 8. Hiring Offers & Onboarding
- Offer creation wizard with offered compensation, joining date, probation terms, working hours, and customized benefits.
- Offer status tracker: Sent, Accepted, Rejected, Expired, Cancelled.
- Accept & Hire workflow transitioning candidate to active hired roster.

### 9. Hired Technicians & Performance Rating
- Hired technicians roster with active role, joining date, and contact shortcuts.
- **Multi-Category Performance Rating System**:
  - Technical Skill (1–5 Stars)
  - Professionalism & Attitude (1–5 Stars)
  - Communication (1–5 Stars)
  - Punctuality & Attendance (1–5 Stars)
  - Quality of Work (1–5 Stars)
  - Written review text and instant trust score update.

### 10. Business Verification & SaaS Subscription
- Document upload and verification tracker (GSTIN, Incorporation, Trade License).
- Live verification status indicator (Verified, Under Review, More Info Required).
- Subscription tiers management:
  - **Starter (Free)**: 3 active job posts, standard candidate search.
  - **Professional (₹2,999/mo)**: 15 active job posts, priority candidate matching, verified badge, direct chat.
  - **Enterprise (₹7,999/mo)**: Unlimited job posts, dedicated account manager, bulk hiring discounts, candidate comparison engine.

---

## 🛠 Tech Stack & Architecture

- **Framework**: Flutter 3.29.0 (Dart 3.7.0)
- **State Management**: `Provider` (`ChangeNotifier`, `MultiProvider`, `context.watch`, `context.read`)
- **Theme**: Material 3 strictly in Light Mode
- **Charts & Visualization**: `fl_chart`
- **Typography & Icons**: `google_fonts` (Inter), `cupertino_icons`, Material Symbols
- **Android Target**: minSdk 21, targetSdk 35, compileSdk 35, Java 17, Kotlin 1.9.22, Gradle 8.6

---

## 🧪 Testing & Verification

Run the comprehensive test suite:

```bash
cd sornet_business
flutter test
```

All 8 test suites and smoke tests pass cleanly with 0 analyzer warnings:
- Initial Business Profile loading
- Jobs listing and creation workflow
- Technician search, filtering, and detail lookup
- Application shortlisting and status updates
- Interview scheduling and rescheduling
- Hiring offers generation and status tracking
- Hired technician multi-criteria rating submission
- SORNET Business App UI smoke test

---

## 📦 Building from Source

```bash
# Set environment variables
export JAVA_HOME="$HOME/.tools/jdk-17/Contents/Home"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$HOME/.tools/flutter/bin:$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# Get dependencies
cd sornet_business
flutter pub get

# Run analyzer
flutter analyze

# Build Release APK
flutter build apk --release --suppress-analytics --no-version-check

# Build Debug APK
flutter build apk --debug --suppress-analytics --no-version-check
```
