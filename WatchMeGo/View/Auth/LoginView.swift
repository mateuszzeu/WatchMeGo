//
//  LoginView.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @Bindable var coordinator: Coordinator
    @Bindable private var viewModel = LoginViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var isAnimating = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.l) {
                Image(systemName: "figure.run.circle.fill")
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
                
                Text("Welcome Back!")
                    .font(.title)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeIn(duration: 0.8).delay(0.3), value: isAnimating)
                
                Text("Ready to crush your goals?")
                    .font(.body)
                    .foregroundColor(DesignSystem.Colors.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeIn(duration: 0.8).delay(0.5), value: isAnimating)
                
                if viewModel.isQuickLoginAvailable {
                    VStack(spacing: DesignSystem.Spacing.s) {
                        HStack(spacing: DesignSystem.Spacing.s) {
                            Image(systemName: "faceid")
                                .font(.title2)
                                .foregroundColor(DesignSystem.Colors.accent)
                            
                            Text("Quick Login")
                                .font(.headline)
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                        
                        if let userName = viewModel.lastLoggedInUser?.name {
                            Text("Sign in as \(userName)")
                                .font(.footnote)
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                        
                        Button("Face ID Login") {
                            Task {
                                await viewModel.quickLoginWithFaceID(coordinator: coordinator)
                            }
                        }
                        .foregroundColor(DesignSystem.Colors.background)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignSystem.Spacing.s)
                        .background(DesignSystem.Colors.accent)
                        .cornerRadius(DesignSystem.Radius.m)
                        .buttonStyle(.plain)
                        .shadow(radius: DesignSystem.Radius.s, y: DesignSystem.Spacing.xs)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: isAnimating)
                    }
                    .cardStyle()
                }
                
                VStack(spacing: DesignSystem.Spacing.m) {
                    StyledTextField(title: "Email", text: $email)
                        .offset(x: isAnimating ? 0 : -50)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.7), value: isAnimating)
                    
                    StyledTextField(title: "Password", text: $password, isSecure: true)
                        .offset(x: isAnimating ? 0 : -50)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.9), value: isAnimating)
                }
                
                PrimaryButton(title: "Sign In") {
                    Task { await viewModel.login(email: email, password: password, coordinator: coordinator) }
                }
                .disabled(email.isEmpty || password.isEmpty)
                .scaleEffect(isAnimating ? 1.0 : 0.8)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.1), value: isAnimating)
                
                Button("No account? Register") {
                    coordinator.navigate(to: .register)
                }
                .font(.footnote)
                .foregroundColor(DesignSystem.Colors.accent)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeIn(duration: 0.8).delay(1.3), value: isAnimating)
                
                Spacer()
                    .frame(height: 60)
            }
            .padding(DesignSystem.Spacing.l)
        }
        .background(DesignSystem.Colors.background)
        .overlay(InfoBannerView())
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    LoginView(coordinator: Coordinator())
}




