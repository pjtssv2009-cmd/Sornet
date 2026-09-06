# SORNET — Technician Mobile Application

**SORNET Technician App** is a production-grade Android mobile application architected and designed for skilled service technicians (specialized for AC / HVAC technicians, and architected for electricians, plumbers, and home appliance specialists) in the **SORNET** technician marketplace platform.

The app empowers technicians to create verified profiles, showcase skills and brand experience, discover and apply for high-paying technician jobs, manage live interviews and video links, review offer letters, track active employment, and manage verifiable credentials and identity documents.

---

## 🚀 Key Features

### 1. Identity, Auth & 8-Step Onboarding Wizard
- **1-Tap Demo Login**: Instant login with pre-configured technician credentials (`technician@sornet.com` / `Technician@123`).
- **Comprehensive 8-Step Onboarding**:
  1. **Personal & Contact Info**: Name, phone, email, date of birth, gender, city, state, pincode.
  2. **Professional Profile**: Trade selection, total experience, employment preference (Full Time / Part Time / Contract), expected salary, availability.
  3. **Technical Expertise**: AC type matrix (Split, Window, Cassette, Ductable, VRF/VRV, Tower, Chiller), inverter vs non-inverter, refrigeration systems.
  4. **Brand Experience**: Daikin, Voltas, LG, Blue Star, Carrier, Hitachi, Mitsubishi, Panasonic, Samsung, Lloyd, Godrej, O General.
  5. **Work History**: Company name, job title, location, duration, and key responsibilities.
  6. **Certifications & Training**: ITI Diploma, NSDC Skill India, OEM Brand Certification, HVAC License.
  7. **Document Upload & Verification**: Aadhaar Card, PAN Card, Driving License, Trade Certificates.
  8. **Review & Verification Submission**: Complete summary review before final submission to SORNET Admin.

### 2. Technician Dashboard & Real-Time Stats
- **Trust Score & Profile Strength Gauge**: Real-time visual meters showing profile completion and trustworthiness (0–100).
- **Metric Cards**: Active Applications, Scheduled Interviews, Pending Offers, Completed Jobs, Average Rating, Total Earnings.
- **Quick Action Hub**: Find Jobs, Manage Availability, Update Skills, Upload Certificates, View Verification Status.
- **Recent Applications & Upcoming Interviews Carousel**: Immediate visibility into pending next steps and interview schedules.

### 3. Job Search, Filtering & 1-Tap Application
- **Intelligent Search & Multi-Filters**: Filter by trade, location/city, employment type (Full-Time, Contract, Urgent), brand experience required, salary range, and minimum experience.
- **Interactive Job Details**: Full job descriptions, business verification badges, required skill tags, brand checklists, tools provided, accommodation/perks, and salary ranges.
- **Application Sheet**: Custom expected salary input, immediate availability picker, and cover notes.
- **Job Bookmarking & Saved Jobs**: Bookmark jobs for quick application.

### 4. Application Tracking & Status Pipeline
- **Visual Application Status Badges**: Applied → Profile Viewed → Shortlisted → Interview Scheduled → Offer Received → Hired → Rejected.
- **Full History & Timeline**: Detailed application audit trail with timestamped events.

### 5. Interview Management & Video Links
- **Interview Scheduling**: View upcoming, completed, and rescheduled interviews.
- **Video Call Support**: Direct join buttons for Google Meet / Zoom video interviews.
- **In-Person Details**: Business address, Google Maps location directions, interviewer contact details, and candidate preparation guidelines.
- **Reschedule / Cancel Requests**: Built-in flow to propose alternate interview dates/times.

### 6. Job Offers & Contract Acceptance
- **Formal Offer Letter Viewer**: Role, fixed salary (₹/month or ₹/year), incentives, joining date, probation duration, working hours, accommodation details.
- **1-Tap Offer Acceptance / Decline**: Instant acceptance updating the SORNET hiring database and initiating onboarding.

### 7. Active Work Management & Ratings
- **Active Job Workspace**: Current employer details, work location, supervisor contacts, and daily attendance / shift logs.
- **Two-Way Rating System**: Technicians can review and rate businesses upon job completion, promoting high trust and accountability.

### 8. Direct Employer Messaging
- **Real-Time Chat Threads**: Direct messaging with hiring managers and verified businesses.
- **Unread Counters & System Notices**: Interview invitations and offer links embedded directly in chats.

### 9. Profile Management & Verification Center
- **Public Profile Preview**: See exactly how hiring businesses view your verified profile.
- **Availability Toggle**: Instant switch between `Available Immediately`, `Looking for Opportunities`, `Employed / Unavailable`.
- **Certificate & Document Manager**: Upload, view, and delete professional certificates and identity documents.

---

## 🎨 UI/UX Design System

- **Strict Light Mode Only**: Surfaces `#FFFFFF` and canvas `#F8FAFC`.
- **Curated Palette**:
  - Primary Royal Blue: `#155EEF`
  - Sky Blue Accent: `#38BDF8`
  - Dark Navy Accent: `#0A2540`
  - Success Emerald: `#12B76A`
  - Warning Amber: `#F79009`
  - Error Crimson: `#F04438`
- **Typography**: Google Fonts Inter with modern geometric styling.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: Flutter 3.27+ (Dart 3.6+)
- **State Management**: `provider` (MultiProvider pattern)
- **Target OS**: Android (minSdk 21, compileSdk 35, targetSdk 35)
- **Architecture**: Clean Architecture with separated `core/`, `data/`, `providers/`, and `ui/` layers.

---

## 📱 Build & Installation

### Release APK
```bash
flutter build apk --release
```
Artifact generated at:
`SORNET/release_apks/sornet-technician-release.apk`

### Debug APK
```bash
flutter build apk --debug
```
Artifact generated at:
`SORNET/release_apks/sornet-technician-debug.apk`

---

## 🧪 Testing

Run full test suite:
```bash
flutter test
```
All unit and widget tests pass with 100% success.
