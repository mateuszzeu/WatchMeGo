# WatchMeGo

**WatchMeGo** is an iOS application designed to help users track their daily activity goals and stay motivated through collaboration with friends.

## Features

- Set and track daily goals for steps, stand hours, and calories
- Add friends and accept/reject invitations
- Designate one friend as your ally and view their progress alongside your own
- View a simple podium ranking based on mutual streaks
- Prevent goal changes while collaborating with an ally

## Technologies

- Swift with UIKit
- HealthKit integration for activity tracking
- Firebase Firestore for real-time data synchronization
- Core Data (used locally before full migration to Firestore)

## Architecture

- MVC-based structure
- Reusable custom views (`ProgressCardView`, `PrimaryInputView`, etc.)
- Dedicated `FriendService` layer for managing invites and friendships
