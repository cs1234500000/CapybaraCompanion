# Capybara Companion 🐹

A lightweight macOS SwiftUI pet that stays on top of your desktop, shows Siddhartha's current task and queue, and nudges with speech bubbles. State is driven by a simple JSON file so the assistant can update progress programmatically.

## Features

- Floating, borderless capybara panel (draggable across spaces)
- Speech bubbles for automatic updates + manual check-ins (single tap)
- Status overlay card (double tap or use the round button)
- File watcher hooked to `~/Library/Application Support/CapybaraCompanion/state.json`
- CLI helper to update the state from the terminal or scripts

## Prerequisites

- macOS 13+
- Xcode 15 / Swift 5.9 toolchain (`xcode-select --install` for command-line tools)

## Running locally

```bash
cd /Users/shuchen/Projects/CapybaraCompanion
swift run
```

The first launch seeds `~/Library/Application Support/CapybaraCompanion/state.json`.

### Controls

- **Single tap** the capybara → friendly check-in bubble
- **Double tap** the body _or_ tap the small round button → toggle the status overlay
- **Drag** the body → reposition the always-on-top window

## Updating state from the CLI

A helper script updates the JSON without editing files by hand:

```bash
swift Scripts/update_state.swift \
  --task "Running ablation study" \
  --progress 0.42 \
  --queue "Clean charts|Write draft paragraph"
```

- `--progress` accepts decimals (0–1) or percents (0–100).
- `--queue` separates entries with `|`.
- `--reset-queue` clears the queue while leaving other fields intact.

Each invocation updates `updatedAt`, which the overlay displays via a relative timestamp.

## Roadmap

- Custom sprite sheet for richer animations (idle, speak, sleepy)
- Menu bar controller + quiet hours
- Notarized `.app` bundle + auto-launch toggle
- Integration hooks for Siddhartha's workflow logs so updates are automatic
