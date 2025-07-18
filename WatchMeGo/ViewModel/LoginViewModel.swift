//
//  LoginViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import Foundation

@Observable
final class LoginViewModel {
    
}

/*
 @Observable
 final class LoginViewModel {
     var infoMessage: String?

     func login(email: String, password: String, coordinator: Coordinator) async {
         do {
             let session = try await supabase.auth.signIn(email: email, password: password)
             let user = session.user

             let newUser = AppUser(
                 id: user.id.uuidString,
                 email: user.email ?? email,
                 name: email.components(separatedBy: "@").first ?? email
             )

             await MainActor.run {
                 coordinator.login(newUser)
                 self.infoMessage = "Signed in!"
             }
         } catch {
             await MainActor.run {
                 self.infoMessage = error.localizedDescription
             }
         }
     }
 }
 */
