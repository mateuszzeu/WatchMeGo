//
//  RegisterViewModelTest.swift
//  WatchMeGo
//
//  Created by MAT on 22/09/2025.
//
import XCTest
@testable import WatchMeGo

@MainActor
final class RegisterViewModelTests: XCTestCase {
    
    var viewModel: RegisterViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = RegisterViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - validateInput Tests
    
    func testValidateInput_ValidInput_DoesNotThrow() {
        // Given
        let email = "test@example.com"
        let password = "password123"
        let name = "John"
        
        // When & Then
        XCTAssertNoThrow(try viewModel.validateInput(email: email, password: password, name: name))
    }
    
    func testValidateInput_EmptyEmail_ThrowsEmptyField() {
        // Given
        let email = ""
        let password = "password123"
        let name = "John"
        
        // When & Then
        XCTAssertThrowsError(try viewModel.validateInput(email: email, password: password, name: name)) { error in
            XCTAssertEqual(error as? AppError, AppError.emptyField(fieldName: "Email"))
        }
    }
    
    func testValidateInput_InvalidEmail_ThrowsInvalidEmail() {
        // Given
        let email = "invalid-email"
        let password = "password123"
        let name = "John"
        
        // When & Then
        XCTAssertThrowsError(try viewModel.validateInput(email: email, password: password, name: name)) { error in
            XCTAssertEqual(error as? AppError, AppError.invalidEmail)
        }
    }
    
    func testValidateInput_EmptyPassword_ThrowsEmptyField() {
        // Given
        let email = "test@example.com"
        let password = ""
        let name = "John"
        
        // When & Then
        XCTAssertThrowsError(try viewModel.validateInput(email: email, password: password, name: name)) { error in
            XCTAssertEqual(error as? AppError, AppError.emptyField(fieldName: "Password"))
        }
    }
    
    func testValidateInput_PasswordTooShort_ThrowsPasswordTooShort() {
        // Given
        let email = "test@example.com"
        let password = "12345"
        let name = "John"
        
        // When & Then
        XCTAssertThrowsError(try viewModel.validateInput(email: email, password: password, name: name)) { error in
            XCTAssertEqual(error as? AppError, AppError.passwordTooShort)
        }
    }
    
    func testValidateInput_EmptyName_ThrowsEmptyField() {
        // Given
        let email = "test@example.com"
        let password = "password123"
        let name = ""
        
        // When & Then
        XCTAssertThrowsError(try viewModel.validateInput(email: email, password: password, name: name)) { error in
            XCTAssertEqual(error as? AppError, AppError.emptyField(fieldName: "Name"))
        }
    }
    
    func testValidateInput_NameTooShort_ThrowsNameTooShort() {
        // Given
        let email = "test@example.com"
        let password = "password123"
        let name = "A"
        
        // When & Then
        XCTAssertThrowsError(try viewModel.validateInput(email: email, password: password, name: name)) { error in
            XCTAssertEqual(error as? AppError, AppError.nameTooShort)
        }
    }
    
    // MARK: - isValidEmail Tests
    
    func testIsValidEmail_ValidEmails() {
        XCTAssertTrue(viewModel.isValidEmail("test@example.com"))
        XCTAssertTrue(viewModel.isValidEmail("user.name+tag@domain.co.uk"))
        XCTAssertTrue(viewModel.isValidEmail("user123@domain.org"))
        XCTAssertTrue(viewModel.isValidEmail("test@sub.domain.com"))
    }
    
    func testIsValidEmail_InvalidEmails() {
        XCTAssertFalse(viewModel.isValidEmail("invalid-email"))
        XCTAssertFalse(viewModel.isValidEmail("@domain.com"))
        XCTAssertFalse(viewModel.isValidEmail("user@"))
        XCTAssertFalse(viewModel.isValidEmail(""))
        XCTAssertFalse(viewModel.isValidEmail("user@domain"))
        XCTAssertFalse(viewModel.isValidEmail("user@.com"))
        XCTAssertFalse(viewModel.isValidEmail("user@domain."))
        XCTAssertFalse(viewModel.isValidEmail("user@domain..com"))
        XCTAssertFalse(viewModel.isValidEmail(".user@domain.com"))
        XCTAssertFalse(viewModel.isValidEmail("a@b.c")) 
    }
    
    // MARK: - formatName Tests
    
    func testFormatName_BasicCapitalization() {
        XCTAssertEqual(viewModel.formatName("john"), "John")
        XCTAssertEqual(viewModel.formatName("JOHN"), "John")
        XCTAssertEqual(viewModel.formatName("jOhN"), "John")
        XCTAssertEqual(viewModel.formatName("MATEUSZ"), "Mateusz")
        XCTAssertEqual(viewModel.formatName("maTeuSz"), "Mateusz")
    }
    
    func testFormatName_WithWhitespace() {
        XCTAssertEqual(viewModel.formatName("  john  "), "John")
        XCTAssertEqual(viewModel.formatName("\tjohn\t"), "John")
        XCTAssertEqual(viewModel.formatName("\n  john  \n"), "John")
        XCTAssertEqual(viewModel.formatName("   MATEUSZ   "), "Mateusz")
    }
    
    func testFormatName_EdgeCases() {
        XCTAssertEqual(viewModel.formatName(""), "")
        XCTAssertEqual(viewModel.formatName("   "), "   ")
        XCTAssertEqual(viewModel.formatName("a"), "A")
        XCTAssertEqual(viewModel.formatName("A"), "A")
    }
    
    func testFormatName_ComplexNames() {
        XCTAssertEqual(viewModel.formatName("mary jane"), "Mary jane")
        XCTAssertEqual(viewModel.formatName("  MARY JANE  "), "Mary jane")
        XCTAssertEqual(viewModel.formatName("o'connor"), "O'connor")
    }
}
