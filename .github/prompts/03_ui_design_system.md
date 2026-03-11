# UI Design System (Shadcn Style)

The UI mimics **Shadcn UI** ported to Flutter.
**Goal:** Clean, Minimal, Thin Borders, Consistent Spacing.

## Design Tokens

- **Font:** `Google Sans` (Apply globally in ThemeData).
- **Icons:** `phosphor_flutter` (Regular weight for general, Fill for active states).
- **Border Radius:**
  - Standard: `8.0` or `12.0`
  - Inner elements: `4.0`
  - Avoid fully rounded corners unless it's a "Pill" tag.
- **Colors:**
  - **ColorScheme:** ShadTheme.of(context).colorScheme.
  - **Background:** colorScheme.background. (shadcn colorScheme)
  - **Border:** colorScheme.border (Width: 1.0). (shadcn colorScheme)
  - **Text:** Primary colorScheme.foreground, Muted colorScheme.muted.
  - **Primary Action:** colorScheme.primary or Brand Color.
- **Spacing:** Multiples of 4 (4, 8, 12, 16, 24, 32).
- **Shadow:**
  - **ShadowSmall:** `BoxShadow(color: ShadTheme.of(context).colorScheme.primary, blurRadius: 3, offset: Offset(0, 1), spreadRadius: 0,)`
  - **ShadowMedium:** `boxShadow: [BoxShadow(color: Color(0x190A0A0A), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -1,), BoxShadow(color: Color(0x190A0A0A), blurRadius: 4, offset: Offset(0, 2), spreadRadius: -2,)],`
  - **ShadowLarge:** `boxShadow: [BoxShadow(color: Color(0x190A0A0A), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -4,),BoxShadow(color: Color(0x190A0A0A), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3,)],`

## Reusable Components Guidelines

### 1. Shadcn Card (The Standard Container)

Never use the default Flutter `Card`. Use a `Container` with:

- `color`: colorSheme.card
- `border`: `Border.all(color: colorSheme.border, width: 1)`
- `borderRadius`: `BorderRadius.circular(12)`
- `boxShadow`: ShadowSmall.

### 2. Buttons

- **Primary Button:** Follow Shadcn UI
- **Ghost/Outline Button:** Follow Shadcn UI.

### 3. Headers & Typography

- Use `TextTheme` Follow ShadTextTheme.
- **Section Headers:** Bold, sized 18-20sp.
- **Body Text:** Regular, sized 14-16sp.
- **Muted Text:** Use `color: colorScheme.muted` for timestamps or secondary info.

### 4. Special Widgets
coming soon

<!-- - **Schedule Timeline:** Use precise height calculations based on duration (e.g., 1 hour = 60px height).
- **Tags/Badges:** Small container, colored background (pastel), text 12sp. -->
