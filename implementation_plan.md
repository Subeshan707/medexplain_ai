# Full-Screen Splash Implementation Plan

## Goal
Replace the current generic splash screen with a full-screen, uncropped display of the "AI Ignite" logo (`assets/images/splash_logo.jpg`), as requested by the user to avoid OS-level cropping issues.

## Proposed Changes

### [SplashScreen Re-implementation]
**File:** [splash_screen.dart](file:///d:/projects/ignite/medexplain_ai/lib/screens/splash_screen.dart)

- **[MODIFY]** `build` method to replace the current text/icon layout with a full-screen `Image.asset`.
- **Logic:**
    - Use `Image.asset('assets/images/splash_logo.jpg')`.
    - Set `fit: BoxFit.cover` (or `BoxFit.contain` depending on aspect ratio preference, but `cover` with centered content usually works best for splash, or `contain` with a background color if the logo is distinct).
    - Given the user said "cut the image", `BoxFit.contain` is safer to ensure 100% of pixels are visible, centered on the background color. 
    - Keep the existing navigation logic (`_checkAuthStatus`).
    - Keep the background color consistent with the native splash `#02131E`.

## Verification Plan

### Manual Verification
1.  Run the app (`flutter run`).
2.  Observe the app launch.
3.  Verify the "AI Ignite" image appears fully visible (uncropped).
4.  Verify the app automatically navigates to `Login` or `Home` after the delay.
