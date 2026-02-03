# Architecture & Folder Structure

We use **Feature-First MVVM** architecture.
Do not organize by layer (pages/widgets/providers). Organize by **Feature**.

## Directory Structure Pattern
```text
lib/
├── src/
│   ├── app.dart
│   ├── core/                 # Shared logic (Theme, Dio, Utils)
│   ├── common_widgets/       # Reusable UI Atoms (Buttons, Cards)
│   └── features/
│       ├── [feature_name]/   # e.g., schedule, authentication, course
│       │   ├── data/         # Repository Impl, Data Sources (API/DB), DTOs
│       │   ├── domain/       # Entities (Freezed classes), Repository Interfaces
│       │   └── presentation/ # Widgets, Screens, Controllers (Riverpod)

```

## State Management Rules (Riverpod)

1. **Code Generation:** Always use `@riverpod` annotation.
```dart
@riverpod
class MyController extends _$MyController { ... }

```


2. **AsyncValue:** Always handle UI states using `.when`:
```dart
ref.watch(provider).when(
  data: (data) => Content(),
  loading: () => Loading(),
  error: (e, st) => ErrorView(),
);

```


3. **Controller Responsibility:** Controllers handle business logic and talk to Repositories. They should NOT contain UI code (like Dialogs/Snackbars). Use Listeners in the UI for that.

## Repository Pattern

* Define `abstract class` in `domain/`.
* Implement specific logic (API/DB) in `data/`.
* Always design for **Offline-First**. Fetch from Local DB first, then Sync with API in the background.
