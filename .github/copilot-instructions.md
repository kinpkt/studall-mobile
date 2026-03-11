# StudALL - AI Coding Instructions

## Project Overview

**StudALL**is a comprehensive schedule management application designed for students, featuring Google Classroom integration (Read-Only), event management, note-taking capabilities, and a directory of student-friendly establishments.

**Core Value:** A "Read-Only" dashboard consolidating academic life - Google Classroom data + manual entries (schedule, tasks, notes) into a single, offline-first interface.

### Tech Stack

- **Framework:** Flutter (Latest), Dart 3+ (Strict Null Safety)
- **State Management:** Riverpod (Code Generation with `@riverpod` annotation)
- **Navigation:** GoRouter
- **Local Database:** Drift (SQLite)
- **Icons:** Phosphor Flutter (Regular/Fill variants)
- **Font:** Google Sans
- **UI Framework:** Shadcn UI (NOT Material Design)

## ⛔ Strict Constraints (DO NOT Rules)

1. **NO In-App Submission:** Never build features to upload files or "Turn In" assignments within the app. Always use Deep Links to open official Google Classroom app/web.
2. **NO Social Feeds:** Do not build comment sections or chat features for courses. Focus on "Read-Only" feeds for announcements.
3. **NO Material Boilerplate:** Avoid standard Material Design widgets (`Card`, default `AppBar`) if they don't match Shadcn design system.
4. **NO Bang Operator:** Strict null safety - avoid `!` unless absolutely justified.

## Architecture: Feature-First MVVM

Organize by **Feature**, NOT by layer (pages/widgets/providers).

### Directory Structure

```
lib/src/
├── app.dart              # Main App Widget & Routing
├── core/                 # Shared: Theme, Utils, Constants
├── common_widgets/       # Reusable Shadcn UI Components
└── features/
    ├── [feature_name]/   # e.g., schedule, authentication, course
    │   ├── data/         # Repository Impl, Data Sources (API/DB), DTOs
    │   ├── domain/       # Entities (Freezed), Repository Interfaces
    │   └── presentation/ # Widgets, Screens, Controllers (Riverpod)
```

**Each feature follows:**

- `data/` - Repository implementations, API/DB data sources, DTOs
- `domain/` - Entities (Freezed classes), Repository interfaces
- `presentation/` - Screens, Widgets, Controllers (Riverpod providers)

## State Management: Riverpod Rules

### 1. Code Generation Only

Always use `@riverpod` annotation syntax. Never use `StateNotifier` or manual `Provider` definitions.

```dart
@riverpod
class MyController extends _$MyController {
  @override
  FutureOr<MyData> build() async {
    return await _repository.fetchData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.fetchData());
  }
}
```

### 2. AsyncValue Handling

Always handle UI states using `.when` for robust error/loading states:

```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myControllerProvider);

    return state.when(
      data: (data) => ContentView(data),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => ErrorWidget(err),
    );
  }
}
```

### 3. ref Usage Rules

- Use `ConsumerWidget` or `ConsumerStatefulWidget`
- Use `ref.watch` inside `build` method
- Use `ref.read` **only** inside callbacks (e.g., `onPressed`)
- Controllers handle business logic - NO UI code (like Dialogs/Snackbars). Use Listeners in UI.

## Repository Pattern: Offline-First

- Define `abstract class` interfaces in `domain/`
- Implement specific logic (API/DB) in `data/`
- Always design for **Offline-First**: Fetch from Local DB first, sync with API in background

```dart
abstract class ScheduleRepository {
  Stream<List<ScheduleSlot>> watchSchedule(DateTime date);
  Future<void> syncWithClassroom();
}
```

## UI Design System: Shadcn Style

The UI mimics **Shadcn UI** ported to Flutter - Clean, Minimal, Thin Borders, Consistent Spacing.

### Design Tokens

**Colors:**

- Access via `ShadTheme.of(context).colorScheme` (NOT `Theme.of(context)`)
- Background: `colorScheme.background`
- Border: `colorScheme.border` (Width: 1.0)
- Text: Primary `colorScheme.foreground`, Muted `colorScheme.muted`
- Primary Action: `colorScheme.primary`

**Typography:**

- Font: Google Sans (applied globally)
- Section Headers: Bold, 18-20sp
- Body Text: Regular, 14-16sp
- Muted Text: Use `colorScheme.muted` for timestamps/secondary info

**Spacing:** Multiples of 4 (4, 8, 12, 16, 24, 32)

**Border Radius:**

- Standard: 8.0 or 12.0
- Inner elements: 4.0
- Avoid fully rounded corners unless "Pill" tag

**Icons:**

- Use `phosphor_flutter` exclusively
- Regular weight for general use
- Fill weight for active states

**Shadows:**

- Small: `BoxShadow(color: colorScheme.primary, blurRadius: 3, offset: Offset(0, 1))`
- Medium: Multiple shadows for depth (see UI design system prompt)
- Large: For elevated components

### Component Guidelines

**Shadcn Card (Standard Container):**
Never use default Flutter `Card`. Use `Container` with:

- `color`: `colorScheme.card`
- `border`: `Border.all(color: colorScheme.border, width: 1)`
- `borderRadius`: `BorderRadius.circular(12)`
- Optional: Small shadow

**Buttons:**
Follow Shadcn UI patterns (Primary, Ghost, Outline)

### ❌ Don't Use:

- `ElevatedButton` with high elevation
- Default `Card` with heavy shadows
- Material Icons
- `Theme.of(context)` for colors

### ✅ Do Use:

- Custom containers with borders
- Flat backgrounds (white or light gray #F8F9FA)
- `ShadTheme.of(context)`
- `phosphor_flutter` icons

## Navigation Structure

### Bottom Navigation (5 Tabs)

1. **Home** - Dashboard (3 sections: Day Schedule, Recent Activity, Week Tasks)
2. **Courses** - Course list and management
3. **To-Do** - Task management (Assigned/Overdue/Completed)
4. **Notes** - Note repository
5. **Explore** - Resources and partner locations

### AppBar Elements

- Current page title
- Notification icon
- User profile
- Date display (shows next class when not on home screen)

## Core Business Logic

### 1. Schedule Conflict Resolution

- **Rule:** Max 2 concurrent activities allowed
- **UI Handling:** If slots overlap, calculate `width = availableWidth / 2` and render side-by-side

### 2. To-Do Categorization

- **Assigned:** `status != Done` AND `dueDate >= Now` (or No Due Date)
- **Overdue:** `status != Done` AND `dueDate < Now`
  - Auto-move logic: Check daily; if due date passes, move from Assigned to Overdue
- **Completed:** `status == Done`

### 3. Google Classroom Sync

- **Direction:** One-way (Google → App)
- **Conflict Resolution:** User manual edits (Room, Time) take precedence over synced data
- **Flow:**
  1. Fetch Courses from API
  2. Match with Local DB by `google_course_id`
  3. Update names/instructors
  4. If new course: Prompt user to set Schedule Slots (Day/Time)

### 4. Course Types

- **Classroom Courses:** From Google Classroom API (read-only content)
- **Custom Courses:** Created manually (full CRUD operations)

## Database Schema (Drift/SQLite)

**Key Tables:**

1. `courses` - Both Google Classroom and user-created courses
2. `schedule_slots` - One course can have multiple time slots
3. `assignments` - Consolidated To-Do list
4. `notes` - Course-specific or general notes

## Coding Standards

**Functional Programming:**

- Prefer `.map()`, `.where()`, `.fold()` over `for` loops
- Use records `(int, String)` for returning multiple values
- Use pattern matching `switch` for state handling

**Imports:**

- Relative imports within same feature
- Absolute imports (`package:studall/src/...`) for cross-feature/core modules

**Data Classes:**

- Use `Freezed` for entities (`copyWith`, `toString`, `==` equality)
- Use `@JsonSerializable()` + `part '*.g.dart'` for DTOs
- Run `dart run build_runner build --delete-conflicting-outputs` after model changes

**UI Language:** Thai for all user-facing text

## Git Workflow

- Use Git Flow: `git flow feature start <name>`

## Current Development State

- ✅ Theme system, Login UI, Models (Course, Task, Schedule, Student)
- ⚠️ Firebase Auth stubbed (needs implementation)
- ⚠️ Dashboard screens are placeholders
- ⚠️ Google Classroom API integration pending
