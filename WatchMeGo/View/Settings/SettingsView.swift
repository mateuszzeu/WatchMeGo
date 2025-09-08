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
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self.viewModel = SettingsViewModel(coordinator: coordinator)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.l) {
                HStack(spacing: DesignSystem.Spacing.s) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 56))
                        .foregroundColor(DesignSystem.Colors.accent)
                    
                    Text(viewModel.currentUser?.name ?? "User")
                        .font(.title)
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    Spacer()
                }
                .cardStyle()
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
                    Text("Daily Goals")
                        .font(.headline)
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    Text("Set your daily activity goals.")
                        .font(.caption)
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .multilineTextAlignment(.leading)
                    
                    Picker("Difficulty", selection: $viewModel.selectedDifficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.rawValue).tag(difficulty)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .cardStyle()
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
                    Text("Appearance")
                        .font(.headline)
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                .cardStyle()
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                    Text("Account options")
                        .font(.headline)
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
    SettingsView(coordinator: Coordinator())
}
