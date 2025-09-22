//
//  ManageViewModelTest.swift
//  WatchMeGo
//
//  Created by MAT on 22/09/2025.
//

import XCTest
@testable import WatchMeGo

@MainActor
final class ManageViewModelTests: XCTestCase {
    
    var viewModel: ManageViewModel!
    
    override func setUp() {
        super.setUp()
        let coordinator = Coordinator()
        viewModel = ManageViewModel(coordinator: coordinator)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization_DefaultValues() {
        XCTAssertEqual(viewModel.emailToInvite, "")
        XCTAssertTrue(viewModel.pendingInvites.isEmpty)
        XCTAssertTrue(viewModel.requesterNames.isEmpty)
        XCTAssertTrue(viewModel.friends.isEmpty)
    }
    
    // MARK: - Early Exit Tests (Guard Logic)
    
    func testLoadData_NoCurrentUser_DoesNothing() async {
        viewModel.pendingInvites = [Friendship(id: "x", users: ["r", "v"], requesterId: "r", status: .pending)]
        viewModel.friends = [AppUser(id: "f1", name: "A", email: "a@x.com", createdAt: Date())]
        viewModel.requesterNames = ["r": "Requester"]
        
        // When
        await viewModel.loadData()
        
        // Then
        XCTAssertEqual(viewModel.pendingInvites.count, 1)
        XCTAssertEqual(viewModel.friends.count, 1)
        XCTAssertEqual(viewModel.requesterNames.count, 1)
    }
    
    func testSendInviteTapped_NoCurrentUser_KeepsEmailAndNoCrash() {
        // Given
        viewModel.emailToInvite = "friend@example.com"
        
        // When
        viewModel.sendInviteTapped()
        
        // Then
        XCTAssertEqual(viewModel.emailToInvite, "friend@example.com")
    }
}
