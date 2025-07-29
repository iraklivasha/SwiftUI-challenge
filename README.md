
# Product Requirements Document (PRD)

## Feature: Like a Video  
**Author**: Irakli Vashakidze  
**Owner**: Product Team / Mobile Team  
**Version**: 1.0  
**Status**: Final  
**Last Updated**: July 16, 2025

---

## 1. Objective

Allow authenticated users to like and unlike videos in order to promote user engagement, enable feedback for content creators, and power future ranking and recommendation algorithms.

---

## 2. Background

Liking is a basic interaction model in content-driven applications. Currently, there is no mechanism for users to express appreciation or feedback directly. Adding a Like feature addresses this gap and contributes to core user engagement metrics.

---

## 3. Scope

### ✅ In Scope (Implementation Required)

- UI/UX: Heart icon (outlined/filled) toggle on tap.
- Backend integration: Like/unlike API integration.
- Like count display (increment/decrement logic).
- Optimistic UI update (feedback before API confirmation).
- Haptic feedback on interaction.
- Full analytics instrumentation.
- Unit tests and integration test scenarios.

### ❌ Out of Scope (Not Part of This Release)

- Reaction emojis or animated reactions.
- Offline liking/caching.
- Like animations beyond state transition.
- Filtering/sorting videos based on like count.

---

## 4. User Stories

### ✅ Authenticated User
- Can tap a heart icon on a video to like it.
- Can tap again to unlike it.
- Sees visual state (outlined/filled) for liked status.
- Sees updated like count immediately.
- Expects consistent state after app relaunch or across devices.

### ❌ Anonymous User
- Cannot like videos.
- Tapping like should prompt sign-in flow (optional in future).

---

## 5. UX/UI Design

- Like button appears on **bottom-right corner** of each video cell (or full-screen player overlay).
- Icon:
  - Outline heart (default): `systemName: "heart"`
  - Filled heart (liked): `systemName: "heart.fill"` with scale animation
- Like count: Displayed in compact format (`1.2K`, `4.3M`) next to the icon.
- Haptic: Medium impact feedback on tap.

### Accessibility
- VoiceOver:  
  - Label: “Like button. Double tap to like this video.”
  - Dynamic: “Liked. Double tap to unlike.”

**Design Spec**: [Figma Link Placeholder]  
**Animation Spec**: 150ms spring scale effect on tap

---

## 6. API Contracts

### 🔹 Like Video

**POST** `/api/v1/videos/{video_id}/like`

```
Headers:
  Authorization: Bearer <token>

Response:
{
  "success": true,
  "liked": true,
  "likeCount": 1243
}
```

### 🔹 Unlike Video

**DELETE** `/api/v1/videos/{video_id}/like`

```
Headers:
  Authorization: Bearer <token>

Response:
{
  "success": true,
  "liked": false,
  "likeCount": 1242
}
```

### 🔹 Get Video Metadata

**GET** `/api/v1/videos/{video_id}`

```
Response:
{
  "id": "video_1234",
  "title": "Cool Skater Trick",
  "likeCount": 1242,
  "isLiked": true
}
```

---

## 7. Analytics Tracking

### 📍 Event: `video_liked`

| Property            | Type   | Example      | Description                        |
|---------------------|--------|--------------|------------------------------------|
| `video_id`          | String | video_1234   | Unique video ID                    |
| `user_id`           | String | user_5678    | Firebase or internal UID           |
| `timestamp`         | Int    | 1720457830000| Time of action                     |
| `like_count_before` | Int    | 1242         | Like count before the action       |
| `like_count_after`  | Int    | 1243         | Like count after the action        |
| `source_screen`     | String | home_feed    | Where the like happened            |
| `video_duration`    | Float  | 14.2         | Duration in seconds                |
| `percent_watched`   | Float  | 85.7         | % of video watched before like     |

### 📍 Event: `video_unliked`
(Same schema as `video_liked`)

---

## 8. Functional Requirements

| ID   | Requirement                                   | Priority | Notes                                  |
|------|-----------------------------------------------|----------|----------------------------------------|
| FR1  | Render outlined heart if not liked            | High     | Icon only interactive if authenticated |
| FR2  | Tap heart toggles like state                  | High     | Optimistic UI update                   |
| FR3  | Update heart icon (filled/unfilled)           | High     | Includes scale animation               |
| FR4  | Show updated like count next to icon          | High     | Format: compact (e.g. 1.2K)            |
| FR5  | Save like state on backend                    | High     | Use `POST` and `DELETE` API            |
| FR6  | Load like state when video appears            | High     | From `/videos/:id`                     |
| FR7  | Fire analytics events                         | High     | See section 7                          |
| FR8  | Haptic feedback on tap                        | Medium   | Use `UIImpactFeedbackGenerator`        |
| FR9  | Handle API error and revert optimistic state  | High     | Toast: “Something went wrong.”         |
| FR10 | Disable button during in-flight request       | High     | Prevent spamming                       |

---

## 9. Non-Functional Requirements

| Requirement          | Value                        |
|----------------------|------------------------------|
| Latency              | < 500ms API roundtrip        |
| Error Tolerance      | Max 1 retry for network errors |
| Accessibility        | VoiceOver & Dynamic Type     |
| Test Coverage        | 95%+ for Like module         |
| Offline Support      | Out of scope                 |
| Rate Limiting        | Max 5 likes per 10s/user     |

---

## 10. Edge Cases & Error Handling

| Scenario                        | Expected Behavior                                    |
|--------------------------------|------------------------------------------------------|
| Network fails on like          | Revert icon and show toast                          |
| Backend returns unauthorized   | Prompt user to log in                               |
| Backend returns 500            | Show retry option                                   |
| Like count becomes negative    | Clamp at 0                                          |

---

## 11. Example Swift Snippet

```swift
struct LikeButton: View {
    @State var isLiked: Bool
    @State var likeCount: Int
    let videoID: String

    var body: some View {
        HStack {
            Button(action: {
                toggleLike()
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .scaleEffect(isLiked ? 1.2 : 1.0)
                    .foregroundColor(.red)
                    .animation(.easeInOut(duration: 0.2), value: isLiked)
            }
            Text(likeCount.formatted(.abbreviated))
        }
        .onAppear {
            fetchInitialLikeState()
        }
    }

    func toggleLike() {
        isLiked.toggle()
        likeCount += isLiked ? 1 : -1
        HapticFeedback.medium()
        Analytics.logEvent(isLiked ? "video_liked" : "video_unliked", parameters: [...])

        Task {
            do {
                if isLiked {
                    try await LikeAPI.like(videoID)
                } else {
                    try await LikeAPI.unlike(videoID)
                }
            } catch {
                isLiked.toggle()
                likeCount += isLiked ? 1 : -1
                showToast("Like failed")
            }
        }
    }
}
```

---

## 12. Success Metrics

| Metric                         | Target          |
|--------------------------------|-----------------|
| % DAUs using Like feature      | ≥ 70% in week 1 |
| Avg likes/user/day            | ≥ 3             |
| Backend error rate             | < 1%            |
| Bounce on Like errors          | < 0.5%          |

---

## 13. Timeline

| Milestone              | Date        |
|------------------------|-------------|
| Final PRD approval     | July 16     |
| Design Signoff         | July 18     |
| Backend API Ready      | July 22     |
| Mobile Dev Start       | July 23     |
| QA Period              | July 30–Aug 2 |
| Production Launch      | Aug 5       |

---

## 14. Dependencies

- Backend Like API
- Authentication SDK
- Analytics SDK
- Video metadata provider

---

## 15. Open Questions

| Question                                 | Owner     | Status         |
|------------------------------------------|-----------|----------------|
| Show like button for unauthenticated users? | Product | Decided: Yes (disabled) |
| Capture watch % before like?             | Analytics | Yes            |
| Like from widgets/notifications?         | Mobile    | Future scope   |
