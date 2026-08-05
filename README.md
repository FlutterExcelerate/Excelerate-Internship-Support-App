# Learnify — Excelerate Internship Support App

> An AI-powered learning platform providing personalized education, wellbeing tracking, and seamless course management in one unified experience.

---

## Project Overview

Learnify (submitted under the working title **Excelerate Internship Support App**) helps interns and learners succeed by combining course enrollment, daily wellbeing check-ins, and an AI learning assistant in a single mobile app. It supports three roles — **Learner**, **Admin**, and (as a future extension) **Mentor** — and is built with Flutter on the frontend and Firebase (Auth + Firestore) on the backend.

### Problem it solves
- Interns often lack a simple way to reflect daily and get quick feedback.
- Course/program discovery and progress tracking are scattered across tools.
- Learners and admins both need fast, contextual answers without waiting on a human — this is where the AI Assistant comes in.

### Target users
- **Learners** — browse and enroll in programs, complete modules, submit assignments, check in via Daily Pulse, chat with the AI learning mentor.
- **Admins** — manage users and programs, view analytics, and use the AI assistant for platform-level insights and reports.

---

## Features

### Authentication
- Continue with Google
- Continue as Guest
- Admin login
- Terms of Service / Privacy Policy screens

### Home Dashboard
Central hub with quick access to Daily Pulse, My Courses, Upcoming Deadlines, and Notifications.

### Daily Pulse (Feedback Form)
- Emoji-based mood selection
- Text reflection entry
- Custom tags (e.g. `#Work`, `#Mission`)
- Submits directly to Firestore, saved against the learner's profile

### Program Listing & Program Details
- Search and browse available programs
- Enroll in a program
- Per-program: overview, modules, assignments, analytics, certificates, and progress tracking

### Notifications
- Categorized alerts (announcements, assignments, updates)
- View details, open an assignment, mark as completed

### Admin Dashboard
- Four-tab admin console for managing users, programs, and platform data

### AI Assistant (Gemini-powered)
A full, self-contained AI chat module, isolated from the rest of the app via Clean Architecture, so the underlying LLM provider can be swapped without touching any UI or business logic.

- **Two personas, one assistant:**
  - **Student/Learning Mentor** — explains concepts, builds quizzes, recommends the next course, helps with interview prep, tracks learning progress.
  - **Admin Assistant** — user management help, platform analytics, engagement monitoring, report generation.
  Each persona has its own system prompt and its own set of quick-suggestion chips, so behavior changes automatically based on who's logged in.
- **Context Engine** — pulls relevant live app data into the conversation, but recursively strips PII, passwords, and tokens before anything reaches the model.
- **Prompt Engine** — sanitizes and truncates all input to guard against prompt injection and oversized requests.
- **Provider-agnostic core** — currently wired to **Google Gemini** (model configurable via `.env`), with streaming responses, retry logic, and configurable temperature/topP/topK. Swapping in OpenAI or Claude only requires adding one new service class — no changes to UI, controllers, or domain logic.
- **Polished chat UI** — dedicated chat page and launcher, markdown-rendered replies, typing indicator, and empty/error states.

> Note: the AI Assistant module is complete and functional on a teammate's feature branch, pending a routine push to `main` — see Setup for the API key it requires.

---

## Tech Stack
- **Frontend:** Flutter, Dart
- **Backend:** Firebase Authentication, Cloud Firestore
- **AI Engine:** Google Gemini API (provider-agnostic architecture — OpenAI/Claude pluggable)
- **State management:** ValueNotifier-based controllers

---

## Setup Instructions

1. **Clone the repository**
   ```
   git clone <repo-url>
   cd flutter_excelerate_frontend
   ```

2. **Install dependencies**
   ```
   flutter pub get
   ```

3. **Firebase configuration**
   The project already includes `google-services.json`, `GoogleService-Info.plist`, and `firebase_options.dart` for the shared Firebase project. If you're pointing at your own Firebase project instead, replace these with your own config files from the Firebase console.

4. **AI Assistant configuration**
   Create a `.env` file at `lib/.env` with:
   ```
   GEMINI_API_KEY=your_gemini_api_key
   GEMINI_MODEL=gemini-3.1-flash-lite
   AI_TEMPERATURE=0.7
   AI_MAX_OUTPUT_TOKENS=1024
   AI_TIMEOUT_SECONDS=30
   AI_ENABLE_LOGGING=false
   ```

5. **Run the app**
   ```
   flutter run
   ```
   Select an emulator or connected device when prompted.

---

## Screenshots

### Authentication & Learner Experience

| Login | Home Dashboard | Program Listing |
|---|---|---|
| ![Login](screenshots/login.png) | ![Home Dashboard](screenshots/home_dashboard.png) | ![Program Listing](screenshots/programs_list.png) |

| Program Overview | Program Modules | Program Analytics |
|---|---|---|
| ![Program Overview](screenshots/course_overview.png) | ![Program Modules](screenshots/course_modules.png) | ![Program Analytics](screenshots/course_analytics.png) |

| Certificates | Daily Pulse | Edit Profile |
|---|---|---|
| ![Certificates](screenshots/course_certificates.png) | ![Daily Pulse](screenshots/daily_pulse.png) | ![Edit Profile](screenshots/edit_profile.png) |

| Profile | Messages | Notification Details |
|---|---|---|
| ![Profile](screenshots/profile.png) | ![Messages](screenshots/messages.png) | ![Notification Details](screenshots/notification_details.png) |

### AI Assistant

| Student/Learning Mentor Persona | Admin Assistant Persona |
|---|---|
| ![AI Assistant — Student](screenshots/ai_assistant_student.png) | ![AI Assistant — Admin](screenshots/ai_assistant_admin.png) |

### Admin Dashboard

| Admin Verification | Dashboard — Control Center | Dashboard — Admin Actions |
|---|---|---|
| ![Admin Verification](screenshots/admin_verification.png) | ![Admin Dashboard Top](screenshots/admin_dashboard_top.png) | ![Admin Dashboard Actions](screenshots/admin_dashboard_actions.png) |

| Content Management | Add Program | Add Module |
|---|---|---|
| ![Content Management](screenshots/admin_content_list.png) | ![Add Program](screenshots/admin_add_program.png) | ![Add Module](screenshots/admin_add_module.png) |

| Notifications & Publishing | Add Notification | Users |
|---|---|---|
| ![Content Notifications](screenshots/admin_content_notifications.png) | ![Add Notification](screenshots/admin_add_notification.png) | ![Users List](screenshots/admin_users_list.png) |

| Update User | User Activity | |
|---|---|---|
| ![Update User](screenshots/admin_update_user.png) | ![User Activity](screenshots/admin_user_activity.png) | |

---

## Changelog

| Version | Change | Notes |
|---|---|---|
| v1.0 | Initial Flutter scaffold, Login + Home screens | Learner-facing MVP |
| v1.1 | Program Listing & Program Details wired to Firestore | Live data, not mock |
| v1.2 | Daily Pulse feedback form | Submits to Firestore |
| v1.3 | Notifications & Admin dashboard | 4-tab admin console |
| v1.4 | AI Assistant module (Gemini) | Student & Admin personas, complete on feature branch, pending push to main |

---

## Navigation Flow

```text
Login (Google / Guest / Admin)
        │
        ▼
   Home Dashboard ── Daily Pulse
        │        └── Notifications ── Notification Detail
        ▼
  Program Listing ── Program Details
        │
        ▼
   AI Assistant (accessible from Home / Admin dashboard)
```

---

## Contribution Log
- Core Flutter screens, Firebase Auth/Firestore integration, Daily Pulse, Program Listing/Details, Admin dashboard.
- AI Assistant module (Gemini integration, personas, context & prompt engines) — teammate contribution, complete and functional, pending push to `main`.
