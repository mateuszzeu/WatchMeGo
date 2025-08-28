//
//  SettingsView.swift
//  WatchMeGo
//
//  Created by Liza on 2025-08-18.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var coordinator: Coordinator
    @Bindable private var viewModel: SettingsViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showDeleteAlert = false
    
    init(coordinator: Coordinator, user: AppUser) {
        self.coordinator = coordinator
        self.viewModel = SettingsViewModel(currentUser: user)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.l) {
                HStack(spacing: DesignSystem.Spacing.m) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 56))
                        .foregroundColor(DesignSystem.Colors.accent)
                    
                    Text(viewModel.currentUser.name)
                        .font(DesignSystem.Fonts.title)
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    Spacer()
                }
                .cardStyle()
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                    Text("Appearance")
                        .font(DesignSystem.Fonts.headline)
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                .cardStyle()
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                    Text("Account options")
                        .font(DesignSystem.Fonts.headline)
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    PrimaryButton(title: "Reset password") { viewModel.resetPassword() }
                    
                    PrimaryButton(title: "Delete Account") { showDeleteAlert = true }
                    
                    PrimaryButton(title: "Log out") { viewModel.logout(coordinator: coordinator) }
                }
                .cardStyle()
            }
            .padding(DesignSystem.Spacing.l)
        }
        .background(DesignSystem.Colors.background)
        .alert("Delete Account?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteAccount(coordinator: coordinator)
            }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone.")
        }
    }
}

#Preview {
    SettingsView(
        coordinator: Coordinator(),
        user: AppUser(
            id: "test",
            name: "Test",
            createdAt: Date(),
            friends: [],
            pendingInvites: [],
            sentInvites: [],
            currentProgress: nil,
            history: [:],
            activeCompetitionWith: nil,
            pendingCompetitionWith: nil,
            competitionStatus: "none"
        )
    )
}
