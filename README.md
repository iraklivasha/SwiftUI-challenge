# 🎬 SwiftUI Movies App Challenge

## 📱 Challenge Overview

### Your Task

Build a movie browsing app in **SwiftUI** that fetches data from [The Movie Database (TMDb)](https://developer.themoviedb.org/) or a similar public movie API. Implement a clean navigation flow using the **Coordinator Pattern** with `NavigationStack`.

---

## 🎯 Requirements

### Core Features

- [ ] **Movie List Screen**
  - Fetch and display a list of movies (title, release year, poster)
  - Handle loading & error states

- [ ] **Movie Detail Screen**
  - Show full movie details (title, overview, rating, genres, etc.)
  - Navigate using `NavigationStack` + Coordinator pattern

- [ ] **Coordinator Pattern**
  - Decouple navigation logic into a coordinator class or struct
  - Drive all navigations from a central point

- [ ] **Networking Layer**
  - Use `async/await`
  - Organize API calls in a separate service layer

- [ ] **Clean Architecture**
  - Use MVVM or similar pattern
  - Apply dependency injection (manual or via a framework)

### Bonus (Optional)

- [ ] Image caching for movie posters
- [ ] Search functionality
- [ ] Offline support with placeholder views
- [ ] Modularize project into feature, core, and UI packages
- [ ] Add unit tests for view models or services

---

## 🧱 Suggested Project Structure
