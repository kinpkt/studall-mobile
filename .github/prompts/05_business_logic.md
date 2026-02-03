# Core Business Logic

## 1. Schedule Conflict Resolution
* **Rule:** Max 2 concurrent activities/classes allowed.
* **UI Handling:** If slots overlap time ranges:
    * Calculate `width = availableWidth / 2`.
    * Render them side-by-side.

## 2. To-Do Categorization Logic
* **Assigned:** `status != Done` AND `dueDate >= Now` (or No Due Date).
* **Missing:** `status != Done` AND `dueDate < Now`.
    * *Auto-Move Logic:* App checks everyday; if due date passes, move from Assigned to Missing.
* **Done:** `status == Done`.

## 3. Google Classroom Sync Strategy
* **Direction:** One-way (Google -> App).
* **Conflict:** User manual edits (Room, Time) take precedence over synced data for those specific fields.
* **Flow:**
    1.  Fetch Courses from API.
    2.  Match with Local DB by `google_course_id`.
    3.  Update names/instructors.
    4.  IF new course: Prompt user to set Schedule Slots (Day/Time).

## 4. Explore/Partner Logic
* **Sorting:** Sort places by `Distance` (if Location Permission granted) or `Category`.
* **Tools:**
    * **GPA Calc:** Use Settings (Total Credits, Grade Points) to calculate.