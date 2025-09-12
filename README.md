# ⌚️ WatchMeGo - iOS Fitness Competition App

<p align="center">
  <img src="https://img.shields.io/badge/SwiftUI-007AFF?style=for-the-badge&logo=swift&logoColor=white">
  <img src="https://img.shields.io/badge/Firebase-%23222222.svg?style=for-the-badge&logo=firebase&logoColor=%23FFCA28">
  <img src="https://img.shields.io/badge/MVVM%2BC-000000?style=for-the-badge">
  <img src="https://img.shields.io/badge/iOS%2017%2B-lightgrey?style=for-the-badge&logo=apple&logoColor=white">
</p>

## 🚀 About The App

**WatchMeGo** is a modern iOS application for fitness competitions with friends. The app uses data from Apple's HealthKit to track daily activity, allowing users to create challenges, monitor progress in real-time, and earn motivating achievements. It combines elements of gamification, activity tracking, and social features into a single, cohesive platform.

## 📸 Visualisation

### 🚀 Launch, Register & Quick Login
![launch](https://github.com/user-attachments/assets/3baedd87-606c-4fa7-8be2-45d9d4462119) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ![face_id_login](https://github.com/user-attachments/assets/7f9ba8df-d295-44fb-88b0-486b9eae1ad1)

---

### 🏠 Dashboard
<img width="332" height="720" alt="Main_Solo_View" src="https://github.com/user-attachments/assets/eed3258f-a6ac-4545-bac2-a96152919949" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <img width="332" height="720" alt="Social_View_NoFriends" src="https://github.com/user-attachments/assets/6d6d9691-5725-46d3-9626-5a095eaf98db" />

---

### 👫 Social Section
<img width="332" height="720" alt="Social_View" src="https://github.com/user-attachments/assets/aa926b94-57ee-44d0-be2c-1e35099f4684" />  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img width="332" height="720" alt="Social_View_v2" src="https://github.com/user-attachments/assets/a5bef075-8fcf-44e0-b570-8c7d4dc627fc" />

---

### 🏆 Create Challenge
<img width="332" height="720" alt="CHallenge_View" src="https://github.com/user-attachments/assets/b2c19299-43d5-4e57-a1a5-053b7fb3984b" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  ![create_challenge](https://github.com/user-attachments/assets/68986ec0-0b9a-49c0-a131-2e07bb54b62d)

---

### 📨 Challenge Invite and Ongoing View

<img width="332" height="720" alt="Invite_Competition" src="https://github.com/user-attachments/assets/3368971c-a42c-4839-8f55-6b299496b147" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ![active_challenge_main](https://github.com/user-attachments/assets/071d5988-c5b3-417c-9ae5-329290c6e369)

---
### 🔥 Active Challenge
<img width="332" height="720" alt="Active_CHallenge_Light" src="https://github.com/user-attachments/assets/b5681b67-6326-41b3-a1f8-e8f187a55c30" />  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img width="332" height="720" alt="Active_Challenge_Dark" src="https://github.com/user-attachments/assets/b8908903-02bd-43d8-8692-f517254f71ef" />

---

### ⚙️ Settings
<img width="332" height="720" alt="Settings_Light" src="https://github.com/user-attachments/assets/3804e46f-f2a4-41eb-860c-40c4dcaab84f" />  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <img width="332" height="720" alt="Settings_Dark" src="https://github.com/user-attachments/assets/a7895112-b0ac-46b8-94d1-7e3aca12dfbf" />

## ✨ Key Features

### 🏃‍♂️ Activity Tracking
- **Automatic data fetching** from HealthKit.
- Tracks **Active Energy Burned**, **Apple Exercise Time**, and **Apple Stand Hours**.
- **3 difficulty levels** (Easy, Medium, Hard) to match your personal goals.

### 🏆 Competition System
- Create **challenges with friends** for a duration of 1 to 7 days.
- Choose **1-3 metrics** to compete on.
- **Real-time leaderboard** with smooth progress animations.
- History of wins for each day of the challenge.

### 👥 Social System
- **Invite friends** by their username.
- Manage incoming invitations (accept/decline).
- A clear **friends list** showing their current challenge status.

### 🏅 Achievement System
- **3 levels of badges** (Easy, Medium, Hard) to unlock.
- **Automatic awarding and upgrading** of badges based on goals achieved.
- Motivating achievement counters on the main dashboard.

## 🏗️ Architecture & Tech Stack

The application is built with a modern tech stack and design patterns to ensure scalability, performance, and maintainability.

- **UI:** **SwiftUI** - A modern, declarative framework for building user interfaces.
- **Backend:** **Firebase** - Firestore for the real-time database and Authentication for user management.
- **Health Data:** **HealthKit** - Secure integration with Apple's health data.
- **Reactive Programming:** **Combine** - For managing asynchronous events.
- **Authentication:** **LocalAuthentication** - For quick and secure biometric login.

- **Design Patterns:**
  - **MVVM + Coordinator**: A clean separation of concerns with navigation logic handled by the Coordinator.
  - **Dependency Injection**: Ensures loose coupling and improves testability.

## 🔧 Getting Started

1.  **Requirements**: iOS 17.0+, Xcode 15+.
2.  **Firebase**: Configure your `GoogleService-Info.plist` file in the project.
3.  **HealthKit**: Add the HealthKit capabilities in the "Signing & Capabilities" tab in Xcode.
4.  **Build**: Run the app on the simulator or a physical device.

## 🚀 What's Next? (Coming Soon)

The app is actively being developed! Here’s what’s planned for the near future:

- [ ] 🖼️ **Custom Profile Pictures:** Ability to add and personalize your avatar.
- [ ] 📊 **History & Visualizations:** Detailed insights into past achievements with beautiful progress charts.
- [ ] ⚖️ **Fairer Scoring for Women:** Adjusting the calorie scoring algorithm to ensure more equitable competition.
- [ ] 📲 **App Store Release:** Making the app available to a wider audience!

## 🔐 Security

- **Authentication:** Secure sign-up and login via Firebase Authentication.
- **Quick Login:** Support for Face ID for fast access.
- **Data Privacy:** Full user consent and control over sharing HealthKit data.
- **Validation:** Client-side and server-side data validation to ensure data integrity.





