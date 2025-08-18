//
//  SettingsView.swift
//  WatchMeGo
//
//  Created by Cursor on 2025-08-18.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var coordinator: Coordinator
    @Bindable private var viewModel: SettingsViewModel

    init(coordinator: Coordinator, user: AppUser) {
        self.coordinator = coordinator
        self.viewModel = SettingsViewModel(currentUser: user)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.l) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                    HStack(spacing: DesignSystem.Spacing.m) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 56))
                            .foregroundColor(DesignSystem.Colors.accent)
                        
                        Text(viewModel.currentUser.name)
                            .font(DesignSystem.Fonts.title)
                            .foregroundColor(DesignSystem.Colors.primary)
                        
                        Spacer()
                    }
                }
                .padding(DesignSystem.Spacing.l)
                .background(DesignSystem.Colors.surface)
                .cornerRadius(DesignSystem.Radius.l)
                .shadow(radius: DesignSystem.Radius.s, y: DesignSystem.Spacing.xs)

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                    Text("Account options")
                        .font(DesignSystem.Fonts.headline)
                        .foregroundColor(DesignSystem.Colors.primary)

                    PrimaryButton(title: "Reset password", action: {}) // TO DO ADD RESET FUNC

                    PrimaryButton(title: "Log out") {
                        viewModel.logout(coordinator: coordinator)
                    }
                    
                }
                .padding(DesignSystem.Spacing.l)
                .background(DesignSystem.Colors.surface)
                .cornerRadius(DesignSystem.Radius.l)
                .shadow(radius: DesignSystem.Radius.s, y: DesignSystem.Spacing.xs)
            }
            .padding(DesignSystem.Spacing.l)
        }
        .background(DesignSystem.Colors.background.ignoresSafeArea())
        .navigationTitle("Settings")
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


