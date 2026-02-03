# Database Schema (Drift/SQLite/Firebase)

The app relies on a relational local database for offline capability.

## Tables

### 1. `courses` table
Stores both Google Classroom courses and User-created courses.
* `id` (Int, AutoIncrement): Local Primary Key.
* `google_course_id` (String, Nullable): If null, it's a manual course.
* `name` (String): Course name.
* `instructor` (String): Teacher name.
* `color` (String): Hex code for UI.
* `is_hidden` (Bool): If true, hide from schedule.

### 2. `schedule_slots` table
Handles the "One Course, Many Times" logic.
* `id` (Int, PK)
* `course_id` (Int, FK -> courses.id)
* `day_of_week` (Int): 1 (Mon) - 7 (Sun).
* `start_time` (String): "HH:mm" format.
* `end_time` (String): "HH:mm" format.
* `location` (String): Room number.

### 3. `assignments` table
Consolidated To-Do list.
* `id` (Int, PK)
* `course_id` (Int, FK)
* `title` (String)
* `due_date` (DateTime, Nullable)
* `status` (Enum): Assigned, Done, Missing.
* `link_url` (String): Deep link to Google Classroom work page.

### 4. `notes` table
* `id` (Int, PK)
* `course_id` (Int, FK, Nullable): Null means "General Note".
* `content` (String): JSON or Markdown content.
* `is_pinned` (Bool).