//
//  LoginView.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import SwiftUI

struct LoginView: View {
    @Bindable var coordinator: Coordinator
    @Bindable private var viewModel = LoginViewModel()
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.m) {
            Text("Sign In")
                .font(DesignSystem.Fonts.title)
                .padding(.bottom, DesignSystem.Spacing.l)

            StyledTextField(title: "Email", text: $email)

            StyledTextField(title: "Password", text: $password, isSecure: true)

            PrimaryButton(title: "Sign In") {
                Task { await viewModel.login(email: email, password: password, coordinator: coordinator) }
            }
            .disabled(email.isEmpty || password.isEmpty)

            Button("No account? Register") {
                coordinator.showRegister()
            }
            .font(DesignSystem.Fonts.footnote)
            .tint(DesignSystem.Colors.accent)

            if let info = viewModel.infoMessage {
                Text(info)
                    .font(DesignSystem.Fonts.footnote)
                    .foregroundColor(DesignSystem.Colors.secondary)
            }
        }
        .padding(DesignSystem.Spacing.l)
        .background(DesignSystem.Colors.background)
    }
}

#Preview {
    LoginView(coordinator: Coordinator())
}

