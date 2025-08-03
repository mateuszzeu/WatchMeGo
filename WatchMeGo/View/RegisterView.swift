//
//  RegisterView.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import SwiftUI

struct RegisterView: View {
    @Bindable var coordinator: Coordinator
    @Bindable private var viewModel = RegisterViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.m) {
            Text("Register")
                .font(DesignSystem.Fonts.title)
                .padding(.bottom, DesignSystem.Spacing.l)

            StyledTextField(title: "Email", text: $email)

            StyledTextField(title: "Password", text: $password, isSecure: true)

            StyledTextField(title: "Username", text: $username)

            PrimaryButton(title: "Register") {
                Task {
                    await viewModel.register(
                        email: email,
                        password: password,
                        username: username,
                        coordinator: coordinator
                    )
                }
            }
            .disabled(email.isEmpty || password.isEmpty || username.isEmpty)

            Button("Already have an account? Sign In") {
                coordinator.showLogin()
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignSystem.Colors.background)
        .ignoresSafeArea()
        .overlay(ErrorBannerView())
    }
}

#Preview {
    RegisterView(coordinator: Coordinator())
}


