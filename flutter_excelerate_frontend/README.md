# Learnify

> An AI-powered learning platform designed to provide personalized education, wellbeing tracking, and seamless course management in one unified experience.

---

## Vision

Learnify aims to create an engaging learning ecosystem where education, wellbeing, and productivity work together. The platform enables learners to enroll in programs, monitor their progress, receive timely notifications, and maintain their daily wellbeing through simple check-ins.

---

# Objectives

- Provide a seamless authentication experience.
- Deliver a centralized learning dashboard.
- Allow learners to discover and enroll in programs.
- Track learning progress with analytics.
- Maintain learner wellbeing using Daily Pulse.
- Keep users updated with real-time notifications.
- Preserve user progress across sessions.
- Create a scalable platform for future AI-powered learning features.

---

# Features

## Authentication

- Continue with Google
- Continue as Guest
- Admin Login
- Terms of Service
- Privacy Policy

---

## Home Dashboard

The central hub of Learnify providing quick access to:

-  Daily Pulse
-  My Courses
-  Upcoming Deadlines
-  Notifications

---

##  Daily Pulse

Users can perform a daily wellbeing check-in.

Features:

- Emoji Mood Selection
- Text Reflection
- Custom Tags (#Work, #Mission, etc.)
- Automatic profile storage

---

##  Course Management

### Program Listing

- Search Programs
- Browse Available Courses
- Enroll in Programs

### Program Details

Each enrolled program includes:

- Overview
- Modules
- Assignments
- Analytics
- Certificates
- Progress Tracking

---

##  Notifications

Categorized notifications including:

- Announcements
- Assignments
- Updates

Users can:

- View Details
- Open Assignment
- Mark as Completed

---

#  Navigation Flow

```text
                    ┌────────────────────┐
                    │      Login         │
                    │ Google / Guest     │
                    │ Admin Login        │
                    └─────────┬──────────┘
                              │
                              ▼
                  ┌─────────────────────────┐
                  │     Home Dashboard      │
                  │ Daily Pulse             │
                  │ My Courses              │
                  │ Deadlines               │
                  └───────┬───────┬─────────┘
                          │       │
          ┌───────────────┘       └────────────────┐
          ▼                                        ▼
 ┌─────────────────┐                    ┌──────────────────┐
 │   Daily Pulse   │                    │ Notification List│
 └─────────────────┘                    └─────────┬────────┘
                                                  ▼
                                      ┌────────────────────┐
                                      │ Notification Detail│
                                      └────────────────────┘

                │
                ▼

      ┌─────────────────────┐
      │  Program Listing    │
      └─────────┬───────────┘
                ▼
      ┌─────────────────────┐
      │ Program Details     │
      └─────────────────────┘

                ▼

        Logout / Exit App
```

---

#  User Journey

##  1 Login

Users authenticate using:

- Google Sign-In
- Guest Mode
- Admin Login

After successful authentication, users are redirected directly to the Home Dashboard.

---

## 2️ Home Dashboard

The dashboard acts as the application's central hub where users can:

- Complete their Daily Pulse
- Browse Courses
- View Deadlines
- Access Notifications

---

## 3️ Daily Pulse

Users can:

- Select today's mood
- Write reflections
- Add custom tags

The entry is automatically saved to their profile.

---

## 4️ Course Enrollment

Users:

- Browse Programs
- Search Courses
- Enroll
- Complete Modules
- Submit Assignments
- View Analytics
- Earn Certificates

---

## 5️ Notifications

Users receive categorized alerts for:

- Assignments
- Announcements
- Updates

Each notification opens a detailed page with available actions.

---

## 6️ Logout / Exit

When users leave the application:

- Learning progress is saved
- Daily Pulse history is preserved
- Notification state remains intact
- Future sessions resume seamlessly

---

#  Application Lifecycle

## Start

```
Launch App
      ↓
Login
      ↓
Dashboard
```

---

## During Session

Users freely navigate between:

- Dashboard
- Daily Pulse
- Courses
- Notifications

No re-authentication is required during the session.

---

## Background State

When the app is minimized:

- Session remains active
- Push notifications continue
- User returns to the last active screen

---

## Session End

The session concludes when:

- User logs out
- App is closed

All user data remains securely stored.

---

#  Screen Structure

```
Login
│
├── Google Login
├── Guest Login
├── Admin Login
├── Privacy Policy
└── Terms of Service

Home Dashboard
│
├── Daily Pulse
├── My Courses
├── Upcoming Deadlines
└── Notifications

Daily Pulse
│
├── Mood
├── Notes
└── Tags

Programs
│
├── Program Listing
└── Program Details
    ├── Overview
    ├── Modules
    ├── Analytics
    ├── Assignments
    └── Certificates

Notifications
│
├── Notification List
└── Notification Details
```

---

#  Proposed Roadmap

- [ ] Validate complete navigation flow
- [ ] Design wireframes for all screens
- [ ] Implement "Last Active Screen" restoration
- [ ] Improve Daily Pulse post-submission UX
- [ ] AI-powered course recommendations
- [ ] Smart reminder system
- [ ] Personalized learning insights
- [ ] Achievement badges & gamification

---

#  Tech Stack (Suggested)

- Flutter
- Firebase / Supabase
- Node.js
- REST API
- Cloud Functions
- Push Notifications

---

#  Contributing

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push your branch.
5. Open a Pull Request for review.

---

#  License

This project is licensed under the MIT License.

---



Empowering learners through personalized education, wellbeing tracking, and intelligent learning experiences.
