## GitHub VOIS – SwiftUI Sample App

A polished SwiftUI app to search GitHub users and view rich user profiles with repositories, followers/following, and in‑app web browsing.
<img src="https://github.com/user-attachments/assets/aa5bfcdb-b9e6-408a-9d24-bf3b8d89f8bd" width="250" />


### Features
- **Search users**: Find GitHub users by username.
- **User details**: Avatar, name, username, bio, company, location, followers/following.
- **Tap actions**:
  - Followers and Following counts open the respective pages in‑app.
  - Repo cards are tappable and open the repository in‑app.
- **Context menu on profile**: Share Profile, Copy Profile URL, Open in the GitHub app (falls back to web).
- **Sorting**: Repositories can be sorted by Updated date or Name.
- **In‑app web view**: Uses SFSafariViewController for a consistent, secure browsing experience.

### Project Structure
```text
GitHub-VOIS/
  GitHub-VOIS/
    Assets.xcassets/           # App assets & images
    Model/                     # Data models
      User.swift
      UserDetailsModel.swift
      UserRepo.swift
    ViewModel/                 # View models
      SearchViewModel.swift
      UserDetailsViewModel.swift
    View/                      # SwiftUI views
      LaunchScreen.swift
      SearchView.swift
      SearchResultsView.swift
      UserDetailsView.swift
    Util/
      Constants.swift
      Extensions/
        View+Background.swift
  GitHub-VOIS.xcodeproj/
```

### Requirements
- Xcode 15 or newer
- iOS 16+ target (can be adjusted if needed)
- Internet connection

### Setup & Run
1. Open `GitHub-VOIS.xcodeproj` in Xcode.
2. Select an iOS Simulator (or your device) and build/run.
3. No API keys are required. The app uses public GitHub endpoints.

### Usage Guide
- From the search screen, type a username and select a result.
- In the details screen:
  - Tap the arrow icon to open the user’s GitHub profile in‑app.
  - Long‑press the profile row to Share/Copy URL or try opening the GitHub app.
  - Tap Followers/Following to view those pages in‑app.
  - Change repo sorting using the segmented control (Updated or Name).
  - Tap a repository to open it in‑app.

### Notes & Decisions
- Background visuals are implemented via `withStaticBackground()` in `View+Background.swift`.
- In‑app navigation to GitHub content uses `SFSafariViewController` (SafariView wrapper) for privacy and performance.
- UI colors prefer system‑aware styles for dark/light compatibility.


