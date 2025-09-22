//
//  MainViewModelTests.swift
//  WatchMeGo
//
//  Created by MAT on 22/09/2025.
//

import XCTest
@testable import WatchMeGo

@MainActor
final class MainViewModelTests: XCTestCase {
    
    var viewModel: MainViewModel!
    
    override func setUp() {
        super.setUp()
        let coordinator = Coordinator()
        viewModel = MainViewModel(coordinator: coordinator)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization_DefaultValues() {
        XCTAssertFalse(viewModel.isAuthorized)
        XCTAssertEqual(viewModel.calories, 0)
        XCTAssertEqual(viewModel.exerciseMinutes, 0)
        XCTAssertEqual(viewModel.standHours, 0)
        XCTAssertNil(viewModel.pendingCompetitionChallengerName)
        XCTAssertNil(viewModel.couponCompetition)
        XCTAssertNil(viewModel.competitiveUser)
        XCTAssertNil(viewModel.activeCompetition)
        XCTAssertNil(viewModel.todaysBadge)
        XCTAssertEqual(viewModel.badgeCounts.easy, 0)
        XCTAssertEqual(viewModel.badgeCounts.medium, 0)
        XCTAssertEqual(viewModel.badgeCounts.hard, 0)
        XCTAssertFalse(viewModel.hasPendingCompetitionInvite)
    }
    
    // MARK: - hasPendingCompetitionInvite Tests
    
    func testHasPendingCompetitionInvite_NoCompetition_ReturnsFalse() {
        // Given
        viewModel.couponCompetition = nil
        
        // When & Then
        XCTAssertFalse(viewModel.hasPendingCompetitionInvite)
    }
    
    func testHasPendingCompetitionInvite_HasCompetition_ReturnsTrue() {
        // Given
        let competition = Competition(
            id: "test-id",
            name: "Test Competition",
            users: ["user1", "user2"],
            initiatorId: "user1",
            status: .pending,
            startDate: Date(),
            endDate: nil,
            metrics: [.calories],
            duration: 7,
            prize: nil,
            progress: nil
        )
        viewModel.couponCompetition = competition
        
        // When & Then
        XCTAssertTrue(viewModel.hasPendingCompetitionInvite)
    }
    
    // MARK: - displayedMetrics Tests
    
    func testDisplayedMetrics_NoCompetition_ReturnsAllCases() {
        // Given
        viewModel.activeCompetition = nil
        
        // When & Then
        XCTAssertEqual(viewModel.displayedMetrics, Metric.allCases)
    }
    
    func testDisplayedMetrics_WithCompetition_ReturnsCompetitionMetrics() {
        // Given
        let competition = Competition(
            id: "c1",
            name: "X",
            users: ["u1", "u2"],
            initiatorId: "u1",
            status: .active,
            startDate: Date(),
            endDate: nil,
            metrics: [.exerciseMinutes, .standHours],
            duration: 3,
            prize: nil,
            progress: nil
        )
        viewModel.activeCompetition = competition
        
        // When & Then
        XCTAssertEqual(Set(viewModel.displayedMetrics), Set([.exerciseMinutes, .standHours]))
    }
    
    // MARK: - defaultGoal Tests
    
    func testDefaultGoal_Calories_ReturnsDifficultyGoal() {
        // Given
        viewModel.selectedDifficulty = .easy
        
        // When
        let goal = viewModel.defaultGoal(for: .calories)
        
        // Then
        XCTAssertEqual(goal, Difficulty.easy.caloriesGoal)
    }
    
    func testDefaultGoal_ExerciseMinutes_ReturnsDifficultyGoal() {
        // Given
        viewModel.selectedDifficulty = .medium
        
        // When
        let goal = viewModel.defaultGoal(for: .exerciseMinutes)
        
        // Then
        XCTAssertEqual(goal, Difficulty.medium.exerciseMinutesGoal)
    }
    
    func testDefaultGoal_StandHours_ReturnsDifficultyGoal() {
        // Given
        viewModel.selectedDifficulty = .hard
        
        // When
        let goal = viewModel.defaultGoal(for: .standHours)
        
        // Then
        XCTAssertEqual(goal, Difficulty.hard.standHoursGoal)
    }
    
    // MARK: - remainingString Tests
    
    func testRemainingString_DaysRemaining_ReturnsDaysFormat() {
        // Given
        let startDate = Date()
        let days = 3
        let now = startDate
        
        // When
        let result = viewModel.remainingString(from: startDate, days: days, now: now)
        
        // Then
        XCTAssertTrue(result.contains("d"))
        XCTAssertTrue(result.contains("h"))
        XCTAssertTrue(result.contains("m"))
        XCTAssertTrue(result.contains("s"))
    }
    
    func testRemainingString_NoDaysRemaining_ReturnsTimeFormat() {
        // Given
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let days = 1
        let now = Date()
        
        // When
        let result = viewModel.remainingString(from: startDate, days: days, now: now)
        
        // Then
        XCTAssertTrue(result.contains(":"))
        XCTAssertFalse(result.contains("d"))
    }
    
    // MARK: - value Tests
    
    func testValue_NoUser_ReturnsLocalValue() {
        // Given
        viewModel.calories = 500
        viewModel.exerciseMinutes = 30
        viewModel.standHours = 8
        
        // When & Then
        XCTAssertEqual(viewModel.value(for: .calories, of: nil), 500)
        XCTAssertEqual(viewModel.value(for: .exerciseMinutes, of: nil), 30)
        XCTAssertEqual(viewModel.value(for: .standHours, of: nil), 8)
    }
    
    func testValue_NoActiveCompetition_ReturnsZero() {
        // Given
        let user = AppUser(id: "test", name: "Test", email: "test@test.com", createdAt: Date())
        viewModel.activeCompetition = nil
        
        // When & Then
        XCTAssertEqual(viewModel.value(for: .calories, of: user), 0)
        XCTAssertEqual(viewModel.value(for: .exerciseMinutes, of: user), 0)
        XCTAssertEqual(viewModel.value(for: .standHours, of: user), 0)
    }
    
    func testValue_NoProgressForUser_ReturnsZero() {
        // Given
        let user = AppUser(id: "test", name: "Test", email: "test@test.com", createdAt: Date())
        let competition = Competition(
            id: "comp-id",
            name: "Test Competition",
            users: ["user1", "user2"],
            initiatorId: "user1",
            status: .active,
            startDate: Date(),
            endDate: nil,
            metrics: [.calories],
            duration: 7,
            prize: nil,
            progress: [:]
        )
        viewModel.activeCompetition = competition
        
        // When & Then
        XCTAssertEqual(viewModel.value(for: .calories, of: user), 0)
    }
    
    func testValue_WithProgressForToday_ReturnsCorrectValues() {
        // Given
        let user = AppUser(id: "u2", name: "Rival", email: "r@x.com", createdAt: Date())
        let today = DateFormatter.dayFormatter.string(from: Date())
        let rivalProgress = DailyProgress(calories: 350, exerciseMinutes: 12, standHours: 10)
        
        let competition = Competition(
            id: "c2",
            name: "Y",
            users: ["u1", "u2"],
            initiatorId: "u1",
            status: .active,
            startDate: Date(),
            endDate: nil,
            metrics: [.calories, .exerciseMinutes, .standHours],
            duration: 7,
            prize: nil,
            progress: ["u2": [today: rivalProgress]]
        )
        viewModel.activeCompetition = competition
        
        // When & Then
        XCTAssertEqual(viewModel.value(for: .calories, of: user), 350)
        XCTAssertEqual(viewModel.value(for: .exerciseMinutes, of: user), 12)
        XCTAssertEqual(viewModel.value(for: .standHours, of: user), 10)
    }
}
