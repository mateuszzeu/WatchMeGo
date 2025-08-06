//
//  ChallengeView.swift
//  WatchMeGo
//
//  Created by Liza on 06/08/2025.
//

import SwiftUI

struct ChallengeView: View {
    @Bindable var coordinator: Coordinator
    @Bindable private var viewModel: ChallengeViewModel

    init(coordinator: Coordinator, user: AppUser) {
        self.coordinator = coordinator
        self.viewModel = ChallengeViewModel(currentUser: user)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                Picker("Friend", selection: $viewModel.selectedFriend) {
                    Text("Select Friend").tag("")
                    ForEach(viewModel.availableFriends, id: \.self) { friend in
                        Text(friend).tag(friend)
                    }
                }
                .pickerStyle(.menu)

                StyledTextField(title: "Challenge Name", text: $viewModel.name)

                Picker("Mode", selection: $viewModel.mode) {
                    ForEach(Mode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
                    ForEach($viewModel.metrics) { $metric in
                        Toggle(metric.metric.title, isOn: $metric.isSelected)
                            .disabled(!metric.isSelected && viewModel.metrics.filter { $0.isSelected }.count >= 3)
                        if viewModel.mode == .coop && metric.isSelected {
                            StyledTextField(title: "\(metric.metric.title) Target", text: $metric.target)
                                .keyboardType(.numberPad)
                        }
                    }
                }
                .padding(.vertical, DesignSystem.Spacing.s)

                Stepper(value: $viewModel.duration, in: 1...7) {
                    Text("Duration: \(viewModel.duration) day\(viewModel.duration > 1 ? "s" : "")")
                }

                StyledTextField(title: "Prize / Forfeit (optional)", text: $viewModel.prize)

                PrimaryButton(title: "Send Challenge") { }
                    .disabled(!viewModel.canSend)
                    .opacity(viewModel.canSend ? 1 : 0.5)
            }
            .padding(DesignSystem.Spacing.l)
        }
        .background(DesignSystem.Colors.background.ignoresSafeArea())
    }
}

#Preview {
    ChallengeView(
        coordinator: Coordinator(),
        user: AppUser(
            id: "1",
            name: "Alice",
            createdAt: Date(),
            friends: ["Bob", "Carol"],
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

