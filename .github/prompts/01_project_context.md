# Project Context: StudALL

**App Name:** StudALL
**Type:** Student Companion & Hybrid Dashboard Application
**Platform:** Flutter (iOS/Android)

## Project Overview

StudALL is a comprehensive schedule management application designed for students, featuring Google Classroom integration, event management, note-taking capabilities, and a directory of student-friendly establishments.

## User Roles

1.  **Student (Main User):** Manages schedule, views assignments, finds study spots (Cafe/Library).
2.  **Partner (Shop/Space):** Promotes their shop, creates coupons/promotions for students.
3.  **Admin:** Verifies partners, manages global content.

## ⛔ "DO NOT" Rules (Strict Constraints)

1.  **NO In-App Submission:** Do not build features to upload files or "Turn In" assignments within the app. Always use a Deep Link to open the official Google Classroom app/web.
2.  **NO Social Feeds:** Do not build comment sections or chat features for courses. Focus on "Read-Only" feeds for announcements.
3.  **NO Boilerplate:** Avoid standard Material Design widgets (Card, Button) if they don't match the Shadcn design system except NavigationBar, AppBar.

## Core Features

### 1. Schedule Management

- Integration with Google Classroom API to import courses
- Manual course and event creation
- Day-by-day and weekly schedule views
- Support for overlapping events (max 2 simultaneous activities)
- Online course indicators
- Flexible time scheduling with skip options

### 2. Course Management

**Two Course Types:**

- **Classroom Courses**: Imported via Google Classroom API
  - Read-only display of coursework, materials, announcements
  - User can select which courses to display
  - Requires time/location input for scheduling
- **Custom Courses**: Created manually within the app
  - Full CRUD operations on course details, work, questions, materials, announcements
  - Same display capabilities as Classroom courses

### 3. Activities & Events

- Standalone events that appear only during their scheduled time
- Can overlap with courses or other events (max 2 overlaps)
- Separate from recurring course schedules

### 4. Note-Taking

- Support for image and text notes
- Organized by course or general categories
- Search functionality
- Pinned notes feature
- Recent notes display

### 5. Student Resources (Explore Tab)

- Partner establishments directory (cafes, libraries, co-working spaces)
- Map-based location search
- Filter by amenities (WiFi, 24-hour, student pricing)
- Student utilities (GPA calculator, PDF merge, PDF services, optional doc scanner, Lecture Board Snapping)

## User Roles

### 1. User (Student)

- Primary user type
- Access to all learning and scheduling features
- Can connect Google Classroom account

### 2. Partner (Business)

- Cafe, restaurant, or study space owner
- Profile display on map
- Business statistics dashboard
- _Implementation details pending_

### 3. Admin

- User and partner management
- Platform statistics
- Handle user requests/reports
- _Implementation details pending_

## Application Structure

### Navigation

**AppBar:**

- Current page title
- Notification icon
- User profile
- Date display (shows next class when not on home screen)

**Bottom Navigation (5 tabs):**

1. **Home** - Dashboard with three sections
2. **Courses** - Course list and management
3. **To-Do** - Task management
4. **Notes** - Note repository
5. **Explore** - Resources and partners

### Home Screen (3 Sections)

#### 1. Day Upcoming Schedule

- Today's classes and events in chronological order
- Detailed view with time, location, course info

#### 2. Recent Activity

- Latest coursework
- Recent materials
- New announcements
- Recent notes
- Chronological feed

#### 3. This Week's Tasks

- Coursework due this week
- Scheduled events for the week

### Courses Screen (2 Sections)

#### 1. Custom Courses

- "Add Course" button
- Form with Classroom-equivalent fields
- Full editing capabilities

#### 2. Classroom Courses

- "Edit Display" button (similar to sign-up flow)
- Select which courses to show
- Read-only content from API

#### Course Detail Page (3 Tabs)

1. **Stream**: Announcements and materials
2. **Classwork**: Assignments and coursework
3. **Notes**: Course-specific notes

### To-Do Screen (3 Tabs)

#### 1. Assigned

Organized into 4 sections:

- No due date
- This week
- Next week
- Later

#### 2. Overdue

Organized into 3 sections:

- This week
- Last week
- Earlier

#### 3. Completed

Organized into 5 sections:

- No due date
- Completed early
- This week
- Last week
- Earlier

**Coursework Detail:**

- Basic information display
- "Open in Classroom" button for API-sourced work

### Notes Screen

- Search bar at top
- Categorized sections:
  - Recent notes
  - Pinned notes
  - General notes
  - By course

### Explore Screen

- Student utility tools section
  - GPA calculator
  - PDF merge
  - PDF services
  - Doc scanner (optional)
- Partner directory
  - Libraries
  - Cafes (regular, WiFi-enabled, 24-hour)
  - Co-working spaces
  - Student-priced restaurants
- Map search: "Find nearby locations"

## User Flows

### Sign Up Flow

1. Choose authentication method:
   - Google Sign-In (recommended)
   - Email/Username/Password
2. Optional: Connect Google Classroom
3. If connecting Classroom:
   - Select Google account (can differ from sign-in account)
   - Checkbox modal to select courses to display
   - For each selected course:
     - Specify days of week
     - Set time slots
     - Add location or mark as online
     - Can skip time entry for later
4. Navigate to home screen

### Course Import Flow

1. User connects Classroom account
2. System fetches all available courses via API
3. User selects courses to display (checkbox modal)
4. For courses without time data:
   - Prompt for days of week
   - Prompt for time ranges per day
   - Options: "Skip for now" or "Online course"
5. Create schedule entries
6. Display course content per API data

## Core Value Proposition

A "Read-Only" dashboard that consolidates academic life. It integrates Google Classroom data with manual user entries (personal schedule, extra tasks, notes) into a single, offline-first interface.

## Tech Stack

- **Framework:** Flutter (Latest Stable)
- **Language:** Dart 3+ (Strict Null Safety)
- **State Management:** Riverpod (Code Generation syntax only)
- **Navigation:** GoRouter
- **Local Database:** Drift (SQLite)
- **Icons:** Phosphor Flutter
- **Font:** Google Sans
