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
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    DesignSystem.Colors.background,
                    DesignSystem.Colors.surface.opacity(0.3),
                    DesignSystem.Colors.background
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: DesignSystem.Spacing.l) {
                Spacer()
                
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [DesignSystem.Colors.accent, DesignSystem.Colors.accent.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                
                Text("Join the Challenge!")
                    .font(.title)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeIn(duration: 0.8).delay(0.3), value: isAnimating)
                
                Text("Start your fitness journey today")
                    .font(.body)
                    .foregroundColor(DesignSystem.Colors.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeIn(duration: 0.8).delay(0.5), value: isAnimating)
                
                VStack(spacing: DesignSystem.Spacing.m) {
                    StyledTextField(title: "Username", text: $username)
                        .offset(x: isAnimating ? 0 : -50)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.7), value: isAnimating)
                    
                    StyledTextField(title: "Email", text: $email)
                        .offset(x: isAnimating ? 0 : -50)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.9), value: isAnimating)
                    
                    StyledTextField(title: "Password", text: $password, isSecure: true)
                        .offset(x: isAnimating ? 0 : -50)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(1.1), value: isAnimating)
                }
                .padding(.horizontal, DesignSystem.Spacing.s)
                
                PrimaryButton(title: "Create Account") {
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
                .scaleEffect(isAnimating ? 1.0 : 0.8)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.3), value: isAnimating)
                
                Button("Already have an account? Sign In") {
                    coordinator.navigate(to: .login)
                }
                .font(.footnote)
                .foregroundColor(DesignSystem.Colors.accent)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeIn(duration: 0.8).delay(1.5), value: isAnimating)
                
                if let info = viewModel.infoMessage {
                    Text(info)
                        .font(.footnote)
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .padding(.top, DesignSystem.Spacing.s)
                }
                
                Spacer()
            }
            .padding(DesignSystem.Spacing.l)
        }
        .overlay(InfoBannerView())
        .onAppear { isAnimating = true }
    }
}

#Preview {
    RegisterView(coordinator: Coordinator())
}



