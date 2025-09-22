//
//  ActiveCompetitionCardViewModel.swift
//  WatchMeGo
//
//  Created by MAT on 22/09/2025.
//
import XCTest
@testable import WatchMeGo

@MainActor
final class ActiveCompetitionCardViewModelTests: XCTestCase {
    
    var viewModel: ActiveCompetitionCardViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ActiveCompetitionCardViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - isUserWinning Tests (Główna logika biznesowa)
    
    func testIsUserWinning_UserWinning_ReturnsTrue() {
        // Given
        viewModel.currentUserProgress = 100
        viewModel.competitorProgress = 50
        
        // When & Then
        XCTAssertTrue(viewModel.isUserWinning)
    }
    
    func testIsUserWinning_UserLosing_ReturnsFalse() {
        // Given
        viewModel.currentUserProgress = 50
        viewModel.competitorProgress = 100
        
        // When & Then
        XCTAssertFalse(viewModel.isUserWinning)
    }
    
    func testIsUserWinning_Tie_ReturnsFalse() {
        // Given
        viewModel.currentUserProgress = 100
        viewModel.competitorProgress = 100
        
        // When & Then
        XCTAssertFalse(viewModel.isUserWinning)
    }
    
    func testIsUserWinning_ZeroProgress_ReturnsFalse() {
        // Given
        viewModel.currentUserProgress = 0
        viewModel.competitorProgress = 0
        
        // When & Then
        XCTAssertFalse(viewModel.isUserWinning)
    }
    
    func testIsUserWinning_UserZeroCompetitorPositive_ReturnsFalse() {
        // Given
        viewModel.currentUserProgress = 0
        viewModel.competitorProgress = 50
        
        // When & Then
        XCTAssertFalse(viewModel.isUserWinning)
    }
    
    func testIsUserWinning_UserPositiveCompetitorZero_ReturnsTrue() {
        // Given
        viewModel.currentUserProgress = 50
        viewModel.competitorProgress = 0
        
        // When & Then
        XCTAssertTrue(viewModel.isUserWinning)
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization_DefaultValues() {
        XCTAssertEqual(viewModel.currentUserProgress, 0)
        XCTAssertEqual(viewModel.competitorProgress, 0)
        XCTAssertEqual(viewModel.currentUserName, "You")
        XCTAssertEqual(viewModel.competitorName, "Rival")
        XCTAssertTrue(viewModel.dailyWinners.isEmpty)
        XCTAssertFalse(viewModel.isUserWinning)
    }
}
