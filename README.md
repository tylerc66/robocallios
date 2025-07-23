# Robocall Blocker

This repository contains a basic iOS application with a Call Directory Extension used to block unwanted calls. The block list is fetched from a CSV file hosted online and stored in a shared app group so both the app and the extension can access it.

## Project Structure

```
RobocallBlocker/
  ├─ RobocallBlocker/                  # Main iOS app
  │   ├─ RobocallBlockerApp.swift
  │   ├─ ContentView.swift
  │   ├─ BlockListViewModel.swift
  │   ├─ Info.plist
  │   └─ RobocallBlocker.entitlements
  ├─ CallBlockerExtension/             # Call Directory Extension
  │   ├─ CallDirectoryHandler.swift
  │   ├─ Info.plist
  │   └─ CallBlockerExtension.entitlements
  ├─ Shared/                           # Files shared between targets
  │   ├─ BlockListManager.swift
  │   └─ APIKeys.swift
  └─ RobocallBlocker.xcodeproj/        # Xcode project
      └─ project.pbxproj
```

## Overview

- **BlockListManager** downloads the CSV from `http://freshtechconcepts.com/blacklists/robocall-blacklist.csv`, parses phone numbers, and saves them in the shared app group `group.com.freshtechconcepts.robocallblocker`.
- **BlockListViewModel** exposes the block list count, last update date, and provides methods to fetch new numbers and reload the extension.
- **CallDirectoryHandler** loads the saved phone numbers and registers them with `CXCallDirectoryExtensionContext`.
- **ContentView** shows the number of blocked phone numbers, the last updated date, and includes a manual update button.

The FCC API key provided (`EGRhIGCI4cus6cAvAOZaj1icneTzIxnngtCi7IYY`) is stored in `APIKeys.swift` for future use.

This project does not include automated tests.
