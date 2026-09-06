# SORNET — Skilled-Technician Hiring Marketplace Platform

**SORNET** is an enterprise-grade skilled-technician hiring and service marketplace platform that connects:
1. **Businesses** — Companies, facility managers, and contractors hiring skilled technicians.
2. **Technicians** — Certified, verified professionals across AC, HVAC, electrical, plumbing, and appliance trades.
3. **SORNET Admin** — Platform governance, verification, dispute resolution, and marketplace operations.

---

## 📱 Mobile Applications & APK Distribution

All Android mobile applications are fully built, tested, and ready for installation on any Android device or emulator (Android 5.0+ / API 21+):

| Application | APK Target | File Location | Package ID |
| :--- | :--- | :--- | :--- |
| **SORNET Technician** | **Production Release** | `release_apks/sornet-technician-release.apk` | `com.sornet.technician` |
| **SORNET Technician** | **Developer Debug** | `release_apks/sornet-technician-debug.apk` | `com.sornet.technician` |
| **SORNET Business** | **Production Release** | `release_apks/sornet-business-release.apk` | `com.sornet.business` |
| **SORNET Business** | **Developer Debug** | `release_apks/sornet-business-debug.apk` | `com.sornet.business` |
| **SORNET Admin** | **Production Release** | `release_apks/sornet-admin-release.apk` | `com.sornet.admin` |
| **SORNET Admin** | **Developer Debug** | `release_apks/sornet-admin-debug.apk` | `com.sornet.admin` |

---

## 🔐 Default Demo Credentials

### 1. SORNET Technician App
| Field | Value | Notes |
| :--- | :--- | :--- |
| **Email** | `technician@sornet.com` | Pre-configured verified technician account (R. Arun Kumar) |
| **Password** | `Technician@123` | Default demo password |
| **1-Tap Login** | Included on login screen | Instant pre-fill for test evaluation |

### 2. SORNET Business App
| Field | Value | Notes |
| :--- | :--- | :--- |
| **Email** | `business@sornet.com` | Pre-configured verified business account |
| **Password** | `Business@123` | Default demo password |
| **1-Tap Login** | Included on login screen | Instant pre-fill for test evaluation |

### 3. SORNET Admin App
| Role | Email | Password | Scope & Permissions |
| :--- | :--- | :--- | :--- |
| **Super Admin** | `admin@sornet.com` | `Admin@123` | Full access across all modules, settings, approvals |
| **Verification Manager** | `verify@sornet.com` | `Admin@123` | Verification Center, ID doc inspection |
| **Operations Manager** | `ops@sornet.com` | `Admin@123` | Jobs lifecycle, dispatching, applications |
| **Support Executive** | `support@sornet.com` | `Admin@123` | Customer accounts, inquiries, dispute tracking |

---

## 🎨 Design System & Aesthetics

- **Strict Light Mode Only** (Strictly NO dark mode).
- **Color Tokens**:
  - **Primary**: Royal Blue (`#155EEF` / `RGB(21, 94, 239)`)
  - **Secondary**: Sky Blue (`#38BDF8` / `RGB(56, 189, 248)`)
  - **Dark / Navy**: Deep Navy (`#0A2540` / `RGB(10, 37, 64)`)
  - **Backgrounds**: Pure Crisp White (`#FFFFFF`), Soft Slate/Ice Blue Canvas (`#F8FAFC` & `#F0F7FF`)
  - **Status Accents**: Emerald Green (`#12B76A`), Amber Warning (`#F79009`), Crimson Red (`#F04438`), Indigo Violet (`#7C3AED`)
- **Typography**: Google Fonts Inter with calibrated hierarchy and touch targets (min 48dp).

---

## 📁 Repository Structure

```
SORNET/
├── release_apks/
│   ├── sornet-technician-release.apk  (Technician App Production APK)
│   ├── sornet-technician-debug.apk    (Technician App Debug APK)
│   ├── sornet-business-release.apk    (Business App Production APK)
│   ├── sornet-business-debug.apk      (Business App Debug APK)
│   ├── sornet-admin-release.apk       (Admin App Production APK)
│   └── sornet-admin-debug.apk         (Admin App Debug APK)
│
├── sornet_technician/                 # SORNET Technician Mobile App (Flutter)
│   ├── lib/
│   │   ├── core/                      # Constants, light theme, formatters
│   │   ├── data/
│   │   │   ├── models/                # Technician, Job, Application, Interview, Offer, Work, Review
│   │   │   ├── mock/                  # Seed data with realistic Indian market data
│   │   │   └── repositories/          # Complete repository with mock state persistence
│   │   ├── providers/                 # MultiProvider state controllers (Auth, Profile, Jobs, Offers, etc.)
│   │   ├── ui/
│   │   │   ├── auth/                  # Splash, Login, OTP, Forgot Password, 8-Step Registration Wizard
│   │   │   ├── shell/                 # Bottom navigation shell with dynamic badges
│   │   │   ├── dashboard/             # Trust score, profile strength, metrics, recent applications
│   │   │   ├── jobs/                  # Search, multi-filters, detail, bookmarking, apply sheet
│   │   │   ├── applications/          # Status badges, pipeline history, withdrawn flows
│   │   │   ├── interviews/            # Scheduled, video meeting links, reschedule requests
│   │   │   ├── offers/                # Official offer letters, salary packages, 1-tap accept/decline
│   │   │   ├── work/                  # Active employment, attendance, 2-way business ratings
│   │   │   ├── messaging/             # Real-time chat with employers & direct negotiation
│   │   │   ├── profile/               # Public profile preview, skills, brand matrix, availability
│   │   │   ├── verification/          # 5-step verification center, ID & trade credentials
│   │   │   └── common/                # Shared badges, metric cards, search bars, rating stars
│   │   └── main.dart                  # Application entry point
│   └── test/                          # Unit and widget test suite
│
├── sornet_business/                   # SORNET Business Mobile App (Flutter)
│   ├── lib/                           # Complete Business mobile application codebase
│   └── test/                          # Business test suite
│
└── sornet_admin/                      # SORNET Admin Mobile App (Flutter)
    ├── lib/                           # Complete Admin mobile application codebase
    └── test/                          # Admin test suite
```

---

## 🧪 Testing & Validation

```bash
# Test Technician App
cd sornet_technician && flutter test

# Test Business App
cd sornet_business && flutter test

# Test Admin App
cd sornet_admin && flutter test
```
