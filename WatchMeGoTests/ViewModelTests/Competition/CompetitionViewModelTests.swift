//
//  CompetitionViewModelTest.swift
//  WatchMeGo
//
//  Created by MAT on 22/09/2025.
//
import XCTest
@testable import WatchMeGo

@MainActor
final class CompetitionViewModelTests: XCTestCase {
    
    var viewModel: CompetitionViewModel!
    
    override func setUp() {
        super.setUp()
        let coordinator = Coordinator()
        viewModel = CompetitionViewModel(coordinator: coordinator)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    
    private func selectFirstMetric() {
        guard !viewModel.metricSelections.isEmpty else { return }
        viewModel.metricSelections[0].isSelected = true
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization_DefaultValues() {
        XCTAssertEqual(viewModel.selectedFriendEmail, "")
        XCTAssertEqual(viewModel.competitionName, "")
        XCTAssertEqual(viewModel.competitionDurationDays, 1)
        XCTAssertEqual(viewModel.competitionPrize, "")
        XCTAssertFalse(viewModel.isReadyToSend)
    }
    
    func testInitialization_MetricSelections() {
        // Given & When
        let metricSelections = viewModel.metricSelections
        
        // Then
        XCTAssertEqual(metricSelections.count, Metric.allCases.count)
        XCTAssertTrue(metricSelections.allSatisfy { !$0.isSelected })
    }
    
    // MARK: - friendEmails Tests
    
    func testFriendEmails_MapsFromFriends() {
        // Given
        let friend1 = AppUser(id: "1", name: "John", email: "john@test.com", createdAt: Date())
        let friend2 = AppUser(id: "2", name: "Jane", email: "jane@test.com", createdAt: Date())
        viewModel.friends = [friend1, friend2]
        
        // When
        let emails = viewModel.friendEmails
        
        // Then
        XCTAssertEqual(emails, ["john@test.com", "jane@test.com"])
    }
    
    func testFriendEmails_EmptyFriends_ReturnsEmptyArray() {
        // Given
        viewModel.friends = []
        
        // When
        let emails = viewModel.friendEmails
        
        // Then
        XCTAssertTrue(emails.isEmpty)
    }
    
    // MARK: - isReadyToSend Tests
    
    func testIsReadyToSend_AllConditionsMet_ReturnsTrue() {
        // Given
        viewModel.selectedFriendEmail = "friend@example.com"
        viewModel.competitionName = "Test Competition"
        viewModel.competitionDurationDays = 3
        selectFirstMetric()
        
        // When & Then
        XCTAssertTrue(viewModel.isReadyToSend)
    }
    
    func testIsReadyToSend_EmptyEmail_ReturnsFalse() {
        // Given
        viewModel.selectedFriendEmail = ""
        viewModel.competitionName = "Test Competition"
        viewModel.competitionDurationDays = 3
        selectFirstMetric()
        
        // When & Then
        XCTAssertFalse(viewModel.isReadyToSend)
    }
    
    func testIsReadyToSend_EmptyCompetitionName_ReturnsFalse() {
        // Given
        viewModel.selectedFriendEmail = "friend@example.com"
        viewModel.competitionName = ""
        viewModel.competitionDurationDays = 3
        selectFirstMetric()
        
        // When & Then
        XCTAssertFalse(viewModel.isReadyToSend)
    }
    
    func testIsReadyToSend_NoMetricsSelected_ReturnsFalse() {
        // Given
        viewModel.selectedFriendEmail = "friend@example.com"
        viewModel.competitionName = "Test Competition"
        viewModel.competitionDurationDays = 3
        // No metrics selected
        
        // When & Then
        XCTAssertFalse(viewModel.isReadyToSend)
    }
    
    func testIsReadyToSend_DurationTooLow_ReturnsFalse() {
        // Given
        viewModel.selectedFriendEmail = "friend@example.com"
        viewModel.competitionName = "Test Competition"
        viewModel.competitionDurationDays = 0
        selectFirstMetric()
        
        // When & Then
        XCTAssertFalse(viewModel.isReadyToSend)
    }
    
    func testIsReadyToSend_DurationTooHigh_ReturnsFalse() {
        // Given
        viewModel.selectedFriendEmail = "friend@example.com"
        viewModel.competitionName = "Test Competition"
        viewModel.competitionDurationDays = 8
        selectFirstMetric()
        
        // When & Then
        XCTAssertFalse(viewModel.isReadyToSend)
    }
    
    func testIsReadyToSend_Duration1_ReturnsTrue() {
        // Given
        viewModel.selectedFriendEmail = "friend@example.com"
        viewModel.competitionName = "Test Competition"
        viewModel.competitionDurationDays = 1
        selectFirstMetric()
        
        // When & Then
        XCTAssertTrue(viewModel.isReadyToSend)
    }
    
    func testIsReadyToSend_Duration7_ReturnsTrue() {
        // Given
        viewModel.selectedFriendEmail = "friend@example.com"
        viewModel.competitionName = "Test Competition"
        viewModel.competitionDurationDays = 7
        selectFirstMetric()
        
        // When & Then
        XCTAssertTrue(viewModel.isReadyToSend)
    }
}
