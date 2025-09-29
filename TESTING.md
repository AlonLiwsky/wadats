# Testing Guide

This document describes how to test Wadats (What's that timestamp?) to ensure all features work correctly.

## Pre-Testing Setup

1. Build and launch the app
2. Grant accessibility permissions when prompted
3. Verify the clock icon appears in the menu bar

## Test Cases

### 1. Core Conversion Logic

#### Test 1.1: Unix Seconds → Other Formats

**Input:** `1737025200`

**Expected Output:**
- ✅ Milliseconds: `1737025200000`
- ✅ Microseconds: `1737025200000000`
- ✅ ISO 8601: `2025-01-16T10:00:00.000Z` (or similar with timezone)
- ✅ Human Readable: Contains "January 16, 2025" or similar
- ✅ Relative: Shows time difference from now

**How to Test:**
1. Open TextEdit
2. Type `1737025200`
3. Select the text
4. Press `⌘⇧T`
5. Verify all conversion results appear

---

#### Test 1.2: Unix Milliseconds → Other Formats

**Input:** `1737025200000`

**Expected Output:**
- ✅ Seconds: `1737025200.000` or `1737025200`
- ✅ Microseconds: `1737025200000000`
- ✅ ISO 8601: `2025-01-16T10:00:00.000Z`
- ✅ Human Readable: Date and time format
- ✅ Relative: Time difference

---

#### Test 1.3: ISO 8601 → Unix Timestamps

**Input:** `2025-01-16T10:00:00Z`

**Expected Output:**
- ✅ Unix Seconds: `1737025200`
- ✅ Unix Milliseconds: `1737025200000`
- ✅ Human Readable: Full date and time
- ✅ Short Format: Abbreviated date/time
- ✅ Relative: Time difference

---

#### Test 1.4: Human Readable Date → Other Formats

**Input:** `January 16, 2025`

**Expected Output:**
- ✅ Unix Seconds: Valid timestamp
- ✅ Unix Milliseconds: Valid timestamp
- ✅ ISO 8601: `2025-01-16T...`
- ✅ Relative: Time difference

**Additional Formats to Test:**
- `01/16/2025`
- `16/01/2025`
- `2025-01-16`
- `Jan 16, 2025`

---

#### Test 1.5: Edge Cases

| Input | Expected Behavior |
|-------|-------------------|
| `0` | Shows Unix epoch (1970-01-01) |
| `9999999999` | Shows year 2286 |
| Empty string | Shows "No timestamp detected" |
| `abc123` | Shows "No timestamp detected" |
| `   1737025200   ` | Trims whitespace, converts normally |

---

### 2. User Interface

#### Test 2.1: Global Keyboard Shortcut

**Steps:**
1. Open any app (Safari, TextEdit, Terminal, etc.)
2. Type or paste: `1737025200`
3. Select the text
4. Press `⌘⇧T`

**Expected:**
- ✅ Popup window appears at cursor position
- ✅ Window is Maccy-style list (not centered on screen)
- ✅ Window is floating (stays on top)
- ✅ Conversion results are displayed
- ✅ Arrow keys work for navigation
- ✅ ESC closes window
- ✅ Click outside closes window

---

#### Test 2.2: Menu Bar

**Steps:**
1. Click the clock icon in the menu bar

**Expected:**
- ✅ Menu appears with:
  - "Convert Selected Text"
  - Separator
  - "Settings"
  - Separator
  - "Quit"

**Test "Convert Selected Text":**
1. Select text: `1737025200`
2. Click menu bar icon → "Convert Selected Text"
3. Verify popup appears

**Test "Settings":**
1. Click menu bar icon → "Settings"
2. Verify settings window appears
3. Check that info is displayed correctly

**Test "Quit":**
1. Click menu bar icon → "Quit"
2. Verify app quits (icon disappears from menu bar)

---

#### Test 2.3: Popup Window Actions

**Navigate with Arrow Keys:**
1. Open popup with any timestamp
2. Press ↓ arrow key
3. Verify selection moves down
4. Press ↑ arrow key
5. Verify selection moves up

**Copy to Clipboard (Enter):**
1. Open popup with any timestamp
2. Use arrow keys to select a result
3. Press **Enter**
4. Verify popup closes
5. Paste in another app (`⌘V`)
6. Verify correct value is pasted

**Insert into App (Cmd+Enter):**
1. Open TextEdit with cursor in document
2. Select timestamp in another location
3. Press `⌘⇧T`
4. Use arrow keys to select a result
5. Press **Cmd+Enter**
6. Verify:
   - Popup closes
   - Value is inserted at cursor position

**Close Window:**
1. Open popup
2. Press **ESC**
3. Verify window closes
4. Open popup again
5. Click outside the popup window
6. Verify window closes

---

#### Test 2.4: Settings Window

**Steps:**
1. Open Settings from menu bar

**Expected:**
- ✅ Window shows app icon
- ✅ "Wadats" title with "What's that timestamp?" tagline
- ✅ Version number
- ✅ Global shortcut info (⌘⇧T)
- ✅ Keyboard shortcuts reference (Enter=copy, Cmd+Enter=insert)
- ✅ Context menu instructions
- ✅ How to use guide
- ✅ "Quit Wadats" button works

---

### 3. macOS Integration

#### Test 3.1: Accessibility Permissions

**First Launch:**
1. Launch app for first time
2. Verify alert appears asking for accessibility
3. Click "Open System Settings"
4. Verify System Settings opens to correct pane
5. Enable permission
6. Restart app
7. Verify shortcut now works

**Denied Permission:**
1. Disable accessibility permission
2. Try to use `⌘⇧T`
3. Verify graceful handling (no crash)

---

#### Test 3.2: Services Integration

**Enable Service:**
1. Go to System Settings → Keyboard → Keyboard Shortcuts → Services
2. Find "Convert Timestamp" under Text
3. Enable it

**Test Service:**
1. Open Safari or TextEdit
2. Select text: `1737025200`
3. Right-click
4. Navigate to Services → "Convert Timestamp"
5. Verify popup appears

**Note:** Services may take time to register. Try:
- Logging out and back in
- Restarting the Mac
- Rebuilding services database: `/System/Library/CoreServices/pbs -flush`

---

### 4. Cross-Application Testing

Test the app works in various applications:

| App | Test | Expected |
|-----|------|----------|
| **TextEdit** | Select timestamp, press ⌘⇧T | ✅ Works |
| **Safari** | Select timestamp in webpage | ✅ Works |
| **Chrome** | Select timestamp in webpage | ✅ Works |
| **Terminal** | Select command output | ✅ Works |
| **VS Code** | Select in code file | ✅ Works |
| **Slack** | Select in message | ✅ Works |
| **Notes** | Select in note | ✅ Works |
| **Mail** | Select in email | ✅ Works |

---

### 5. Performance & Stability

#### Test 5.1: Rapid Usage

**Steps:**
1. Select timestamp
2. Press `⌘⇧T` rapidly 10 times

**Expected:**
- ✅ App doesn't crash
- ✅ No memory leaks
- ✅ Popup opens/closes correctly

---

#### Test 5.2: Long-Running

**Steps:**
1. Launch app
2. Leave running for several hours
3. Periodically use conversion features

**Expected:**
- ✅ No memory leaks (check Activity Monitor)
- ✅ Menu bar icon remains
- ✅ All features continue working

---

#### Test 5.3: Large Inputs

**Test with:**
- Very long strings (1000+ characters)
- Multiple timestamps in selection
- Unicode characters
- Emojis mixed with timestamps

**Expected:**
- ✅ Graceful handling
- ✅ No crashes
- ✅ Appropriate conversion or "not detected" message

---

### 6. Visual Testing

#### Test 6.1: Dark Mode

**Steps:**
1. Enable dark mode: System Settings → Appearance → Dark
2. Open popup window
3. Open settings window

**Expected:**
- ✅ All UI elements visible in dark mode
- ✅ Proper contrast
- ✅ Icons visible
- ✅ No white backgrounds where unexpected

---

#### Test 6.2: Multiple Displays

**Steps:**
1. Connect second monitor
2. Move active app to second monitor
3. Select text and press `⌘⇧T`

**Expected:**
- ✅ Popup appears on correct display
- ✅ Properly centered

---

### 7. Error Handling

#### Test 7.1: Invalid Input

| Input | Expected Behavior |
|-------|-------------------|
| Empty selection | "No timestamp detected" |
| Non-numeric text | "No timestamp detected" |
| Whitespace only | "No timestamp detected" |
| Special characters | Graceful handling |

---

#### Test 7.2: System Issues

**No Accessibility Permission:**
- Shortcut doesn't work
- App shows alert on first use

**Services Not Registered:**
- Manual registration instructions in README
- App continues to work via shortcut

---

## Automated Verification

### Code Review Checklist

- [ ] No force unwraps (`!`) without proper guards
- [ ] Proper error handling
- [ ] No print statements left in code
- [ ] Memory management (no retain cycles)
- [ ] Accessibility labels for UI elements
- [ ] Proper date/time handling across timezones

### Build Verification

```bash
# Build should complete without errors
./build-direct.sh

# Or install the app
./install.sh
```

---

## Regression Testing

After any code changes, verify:

1. ✅ App builds successfully
2. ✅ No new warnings
3. ✅ Menu bar icon appears
4. ✅ Global shortcut works
5. ✅ Basic timestamp conversion works
6. ✅ Copy and insert functions work
7. ✅ Settings window opens
8. ✅ App quits cleanly

---

## Reporting Issues

When reporting test failures, include:

1. macOS version
2. App version
3. Steps to reproduce
4. Expected vs actual behavior
5. Screenshots if applicable
6. Console logs if relevant

---

## Test Coverage Goals

- ✅ Core conversion: 100%
- ✅ UI interactions: 100%
- ✅ Error cases: 100%
- ✅ Cross-app compatibility: Major apps
- ✅ Edge cases: Common scenarios

---

**Happy Testing! 🧪**