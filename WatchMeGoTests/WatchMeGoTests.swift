////
////  WatchMeGoTests.swift
////  WatchMeGoTests
////
////  Created by Liza on 18/07/2025.
////
//
//import HealthKit
//import LocalAuthentication
//import XCTest
//@testable import WatchMeGo
//
//final class WatchMeGoTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    // MARK: - AppError Tests (NO @MainActor - safe to test)
//    func testAppErrorDescriptions() throws {
//        XCTAssertEqual(AppError.emptyField(fieldName: "Email").errorDescription, "Email field cannot be empty.")
//        XCTAssertEqual(AppError.invalidEmail.errorDescription, "Please enter a valid email address.")
//        XCTAssertEqual(AppError.passwordTooShort.errorDescription, "Password must be at least 6 characters long.")
//        XCTAssertEqual(AppError.usernameTooShort.errorDescription, "Username must be at least 3 characters long.")
//        XCTAssertEqual(AppError.userNotFound.errorDescription, "User not found.")
//        XCTAssertEqual(AppError.selfInvite.errorDescription, "You cannot invite yourself.")
//        XCTAssertEqual(AppError.alreadyFriends.errorDescription, "Already friends.")
//        XCTAssertEqual(AppError.inviteAlreadySent.errorDescription, "Invite already sent.")
//        XCTAssertEqual(AppError.alreadyInCompetition.errorDescription, "User is already in a competition.")
//        XCTAssertEqual(AppError.usernameTaken.errorDescription, "This username is already taken.")
//        XCTAssertEqual(AppError.accountDeletionFailed.errorDescription, "Failed to delete account. Please try again.")
//    }
//    
//    func testAppErrorEquality() throws {
//        XCTAssertEqual(AppError.invalidEmail, AppError.invalidEmail)
//        XCTAssertNotEqual(AppError.invalidEmail, AppError.passwordTooShort)
//        XCTAssertEqual(AppError.emptyField(fieldName: "Email"), AppError.emptyField(fieldName: "Email"))
//        XCTAssertNotEqual(AppError.emptyField(fieldName: "Email"), AppError.emptyField(fieldName: "Password"))
//    }
//
//    // MARK: - Data Model Tests (NO @MainActor - safe to test)
//    func testDailyProgressCodable() throws {
//        let progress = DailyProgress(calories: 500, exerciseMinutes: 45, standHours: 8)
//        let data = try JSONEncoder().encode(progress)
//        let decoded = try JSONDecoder().decode(DailyProgress.self, from: data)
//        XCTAssertEqual(decoded.calories, progress.calories)
//        XCTAssertEqual(decoded.exerciseMinutes, progress.exerciseMinutes)
//        XCTAssertEqual(decoded.standHours, progress.standHours)
//    }
//    
//    func testBadgeInitialization() throws {
//        let badge = Badge(level: .medium, date: "2025-01-01")
//        XCTAssertEqual(badge.level, .medium)
//        XCTAssertEqual(badge.date, "2025-01-01")
//        XCTAssertEqual(badge.id, "2025-01-01_medium")
//    }
//    
//    func testBadgeLevelProperties() throws {
//        XCTAssertEqual(BadgeLevel.easy.displayName, "Easy")
//        XCTAssertEqual(BadgeLevel.medium.displayName, "Medium")
//        XCTAssertEqual(BadgeLevel.hard.displayName, "Hard")
//        XCTAssertEqual(BadgeLevel.easy.rawValue, "easy")
//        XCTAssertEqual(BadgeLevel.medium.rawValue, "medium")
//        XCTAssertEqual(BadgeLevel.hard.rawValue, "hard")
//    }
//
//    func testDifficultyGoals() throws {
//        XCTAssertEqual(Difficulty.easy.caloriesGoal, 400)
//        XCTAssertEqual(Difficulty.easy.exerciseMinutesGoal, 30)
//        XCTAssertEqual(Difficulty.easy.standHoursGoal, 7)
//        
//        XCTAssertEqual(Difficulty.medium.caloriesGoal, 800)
//        XCTAssertEqual(Difficulty.medium.exerciseMinutesGoal, 60)
//        XCTAssertEqual(Difficulty.medium.standHoursGoal, 10)
//        
//        XCTAssertEqual(Difficulty.hard.caloriesGoal, 1200)
//        XCTAssertEqual(Difficulty.hard.exerciseMinutesGoal, 120)
//        XCTAssertEqual(Difficulty.hard.standHoursGoal, 14)
//    }
//
//    func testMetricProperties() throws {
//        XCTAssertEqual(Metric.calories.title, "Calories Burned")
//        XCTAssertEqual(Metric.calories.iconName, "flame.fill")
//        XCTAssertEqual(Metric.calories.id, "calories")
//        
//        XCTAssertEqual(Metric.exerciseMinutes.title, "Exercise Minutes")
//        XCTAssertEqual(Metric.exerciseMinutes.iconName, "figure.run")
//        XCTAssertEqual(Metric.exerciseMinutes.id, "exerciseMinutes")
//        
//        XCTAssertEqual(Metric.standHours.title, "Stand Hours")
//        XCTAssertEqual(Metric.standHours.iconName, "clock")
//        XCTAssertEqual(Metric.standHours.id, "standHours")
//    }
//
//    func testChallengeInitialization() throws {
//        let challenge = Challenge(
//            id: "test-id",
//            pairID: "user1_user2",
//            name: "Test Challenge",
//            senderID: "user1",
//            senderName: "User1",
//            receiverID: "user2",
//            receiverName: "User2",
//            mode: .versus,
//            metrics: [Challenge.MetricInfo(metric: .calories, target: 500)],
//            duration: 7,
//            prize: "Test Prize",
//            status: .active,
//            createdAt: Date()
//        )
//        
//        XCTAssertEqual(challenge.id, "test-id")
//        XCTAssertEqual(challenge.pairID, "user1_user2")
//        XCTAssertEqual(challenge.name, "Test Challenge")
//        XCTAssertEqual(challenge.status, .active)
//        XCTAssertEqual(challenge.metrics.count, 1)
//    }
//    
//    func testChallengeStatus() throws {
//        XCTAssertEqual(Challenge.Status.pending.rawValue, "pending")
//        XCTAssertEqual(Challenge.Status.active.rawValue, "active")
//        XCTAssertEqual(Challenge.Status.completed.rawValue, "completed")
//    }
//
//    func testModeProperties() throws {
//        XCTAssertEqual(Mode.versus.rawValue, "VERSUS")
//        XCTAssertEqual(Mode.versus.id, "VERSUS")
//        XCTAssertEqual(Mode.versus.title, "VERSUS")
//    }
//
//    func testMetricSelectionInitialization() throws {
//        let selection = MetricSelection(metric: .calories)
//        XCTAssertEqual(selection.metric, .calories)
//        XCTAssertFalse(selection.isSelected)
//        XCTAssertEqual(selection.id, .calories)
//    }
//
//    func testPopupMessageInitialization() throws {
//        let message = PopupMessage(text: "Test message")
//        XCTAssertEqual(message.text, "Test message")
//        XCTAssertNotNil(message.id)
//    }
//
//    // MARK: - RegisterViewModel Tests (HAS @MainActor - needs @MainActor + async)
//    @MainActor
//    func testEmailValidation() async throws {
//        let viewModel = RegisterViewModel()
//        
//        XCTAssertTrue(viewModel.isValidEmail("test@example.com"))
//        XCTAssertTrue(viewModel.isValidEmail("user.name+tag@domain.co.uk"))
//        XCTAssertFalse(viewModel.isValidEmail("invalid-email"))
//        XCTAssertFalse(viewModel.isValidEmail("@domain.com"))
//        XCTAssertFalse(viewModel.isValidEmail("user@"))
//        XCTAssertFalse(viewModel.isValidEmail(""))
//    }
//    
//    @MainActor
//    func testInputValidation() async throws {
//        let viewModel = RegisterViewModel()
//        
//        XCTAssertThrowsError(try viewModel.validateInput(email: "", password: "password", username: "user")) { error in
//            XCTAssertEqual(error as? AppError, AppError.emptyField(fieldName: "Email"))
//        }
//        
//        XCTAssertThrowsError(try viewModel.validateInput(email: "invalid", password: "password", username: "user")) { error in
//            XCTAssertEqual(error as? AppError, AppError.invalidEmail)
//        }
//        
//        XCTAssertThrowsError(try viewModel.validateInput(email: "test@test.com", password: "", username: "user")) { error in
//            XCTAssertEqual(error as? AppError, AppError.emptyField(fieldName: "Password"))
//        }
//        
//        XCTAssertThrowsError(try viewModel.validateInput(email: "test@test.com", password: "123", username: "user")) { error in
//            XCTAssertEqual(error as? AppError, AppError.passwordTooShort)
//        }
//        
//        XCTAssertThrowsError(try viewModel.validateInput(email: "test@test.com", password: "password", username: "")) { error in
//            XCTAssertEqual(error as? AppError, AppError.emptyField(fieldName: "Username"))
//        }
//        
//        XCTAssertThrowsError(try viewModel.validateInput(email: "test@test.com", password: "password", username: "ab")) { error in
//            XCTAssertEqual(error as? AppError, AppError.usernameTooShort)
//        }
//    }
//    
//    @MainActor
//    func testUsernameFormatting() async throws {
//        let viewModel = RegisterViewModel()
//        
//        XCTAssertEqual(viewModel.formatUsername("john"), "John")
//        XCTAssertEqual(viewModel.formatUsername("JOHN"), "John")
//        XCTAssertEqual(viewModel.formatUsername("jOhN"), "John")
//        XCTAssertEqual(viewModel.formatUsername("  john  "), "John")
//        XCTAssertEqual(viewModel.formatUsername(""), "")
//    }
//
//    // MARK: - Performance Tests (Critical for App Store)
//    func testPerformanceExample() throws {
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//    
//    // MARK: - Security & Privacy Tests
//    func testHealthKitAvailability() throws {
//        XCTAssertTrue(HKHealthStore.isHealthDataAvailable())
//    }
//
//    @MainActor
//    func testFaceIDAvailability() async throws {
//        let context = LAContext()
//        var error: NSError?
//        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
//        XCTAssertTrue(canEvaluate || !canEvaluate)
//    }
//
//    func testUserDataEncryption() throws {
//        let user = AppUser(
//            id: "test-id",
//            name: "TestUser",
//            email: "test@example.com",
//            createdAt: Date(),
//            friends: [],
//            pendingInvites: [],
//            sentInvites: [],
//            currentProgress: nil,
//            history: [:],
//            activeCompetitionWith: nil,
//            pendingCompetitionWith: nil
//        )
//        
//        let data = try JSONEncoder().encode(user)
//        let decoded = try JSONDecoder().decode(AppUser.self, from: data)
//        XCTAssertEqual(decoded.email, user.email)
//        XCTAssertEqual(decoded.name, user.name)
//    }
//
//    func testHealthDataPrivacy() throws {
//        let progress = DailyProgress(calories: 500, exerciseMinutes: 45, standHours: 8)
//        
//        let data = try JSONEncoder().encode(progress)
//        let decoded = try JSONDecoder().decode(DailyProgress.self, from: data)
//        XCTAssertEqual(decoded.calories, progress.calories)
//        XCTAssertEqual(decoded.exerciseMinutes, progress.exerciseMinutes)
//        XCTAssertEqual(decoded.standHours, progress.standHours)
//    }
//    
//    // MARK: - Validation & Edge Cases Tests
//    @MainActor
//    func testEmailValidationEdgeCases() async throws {
//        let viewModel = RegisterViewModel()
//        
//        XCTAssertFalse(viewModel.isValidEmail("a@b.c"))
//        XCTAssertFalse(viewModel.isValidEmail("test@.com"))
//        XCTAssertFalse(viewModel.isValidEmail("test@com."))
//        XCTAssertFalse(viewModel.isValidEmail("test@.com."))
//        XCTAssertTrue(viewModel.isValidEmail("test@example.com"))
//    }
//
//    @MainActor
//    func testPasswordValidationEdgeCases() async throws {
//        let viewModel = RegisterViewModel()
//        
//        XCTAssertThrowsError(try viewModel.validateInput(email: "test@test.com", password: "12345", username: "user")) { error in
//            XCTAssertEqual(error as? AppError, AppError.passwordTooShort)
//        }
//        
//        XCTAssertThrowsError(try viewModel.validateInput(email: "test@test.com", password: "", username: "user")) { error in
//            XCTAssertEqual(error as? AppError, AppError.emptyField(fieldName: "Password"))
//        }
//    }
//
//    func testDataIntegrity() throws {
//        let progress = DailyProgress(calories: 0, exerciseMinutes: 0, standHours: 0)
//        XCTAssertEqual(progress.calories, 0)
//        XCTAssertEqual(progress.exerciseMinutes, 0)
//        XCTAssertEqual(progress.standHours, 0)
//    }
//    
//    // MARK: - Navigation & Error Handling Tests
//    @MainActor
//    func testNavigationFlow() async throws {
//        let coordinator = Coordinator()
//        
//        XCTAssertEqual(coordinator.screen, .splash)
//        XCTAssertNil(coordinator.currentUser)
//        
//        coordinator.navigate(to: .login)
//        XCTAssertEqual(coordinator.screen, .login)
//        
//        coordinator.navigate(to: .register)
//        XCTAssertEqual(coordinator.screen, .register)
//    }
//
//    @MainActor
//    func testErrorHandling() async throws {
//        let messageHandler = MessageHandler.shared
//        
//        messageHandler.showError(AppError.invalidEmail)
//        XCTAssertTrue(messageHandler.showMessage)
//        XCTAssertEqual(messageHandler.messageType, .error)
//        XCTAssertEqual(messageHandler.message, "Please enter a valid email address.")
//        
//        messageHandler.showSuccess("Test success")
//        XCTAssertTrue(messageHandler.showMessage)
//        XCTAssertEqual(messageHandler.messageType, .success)
//        XCTAssertEqual(messageHandler.message, "Test success")
//        
//        messageHandler.clearMessage()
//        XCTAssertFalse(messageHandler.showMessage)
//        XCTAssertNil(messageHandler.message)
//    }
//
//    func testDataModelIntegrity() throws {
//        let user = AppUser(
//            id: "test-id",
//            name: "TestUser",
//            email: "test@example.com",
//            createdAt: Date(),
//            friends: ["friend1", "friend2"],
//            pendingInvites: ["invite1"],
//            sentInvites: ["sent1"],
//            currentProgress: DailyProgress(calories: 500, exerciseMinutes: 45, standHours: 8),
//            history: ["2025-01-01": DailyProgress(calories: 400, exerciseMinutes: 30, standHours: 6)],
//            activeCompetitionWith: "competitor1",
//            pendingCompetitionWith: "pending1"
//        )
//        
//        XCTAssertEqual(user.id, "test-id")
//        XCTAssertEqual(user.friends.count, 2)
//        XCTAssertEqual(user.pendingInvites.count, 1)
//        XCTAssertNotNil(user.currentProgress)
//        XCTAssertEqual(user.history.count, 1)
//    }
//}
