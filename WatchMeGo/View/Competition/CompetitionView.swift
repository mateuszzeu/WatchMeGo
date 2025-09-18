//
//  CompetitionView.swift
//  WatchMeGo
//
//  Created by Liza on 06/08/2025.
//

import SwiftUI

struct CompetitionView: View {
    @Bindable var coordinator: Coordinator
    @Bindable private var viewModel: CompetitionViewModel
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self.viewModel = CompetitionViewModel(coordinator: coordinator)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.l) {
                if let competition = viewModel.activeCompetition {
                    ActiveCompetitionCardView(
                        competition: competition,
                        onAbortCompetition: { await viewModel.abortActiveCompetition() }
                    )
                } else {
                    VStack(spacing: DesignSystem.Spacing.l) {
                        Text("Create Competition")
                            .font(.title2.bold())
                            .foregroundColor(DesignSystem.Colors.primary)
                        
                        VStack(spacing: DesignSystem.Spacing.s) {
                            Text("Select Friend")
                                .font(.body.weight(.semibold))
                                .foregroundColor(DesignSystem.Colors.primary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: DesignSystem.Spacing.s) {
                                    ForEach(viewModel.friendEmails, id: \.self) { friend in
                                        let isSelected = (viewModel.selectedFriendEmail == friend)
                                        Text(friend)
                                            .font(.callout.weight(isSelected ? .semibold : .regular))
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 14)
                                            .background(
                                                Capsule()
                                                    .fill(isSelected ? DesignSystem.Colors.accent : DesignSystem.Colors.surface)
                                            )
                                            .overlay(
                                                Capsule().stroke(DesignSystem.Colors.primary.opacity(isSelected ? 0 : 0.25), lineWidth: 1)
                                            )
                                            .foregroundColor(isSelected ? .white : DesignSystem.Colors.primary)
                                            .onTapGesture {
                                                viewModel.selectedFriendEmail = friend
                                            }
                                    }
                                }
                            }
                            
                            StyledTextField(title: "Competition Name", text: $viewModel.competitionName)
                        }
                        .cardStyle()
                        .onAppear {
                            if viewModel.selectedFriendEmail.isEmpty, let first = viewModel.friendEmails.first {
                                viewModel.selectedFriendEmail = first
                            }
                        }
                        
                        VStack(spacing: DesignSystem.Spacing.s) {
                            Text("Select Metrics")
                                .font(.body.weight(.semibold))
                                .foregroundColor(DesignSystem.Colors.primary)
                            
                            ForEach($viewModel.metricSelections) { $metric in
                                Toggle(isOn: $metric.isSelected) {
                                    Text(metric.metric.title)
                                        .font(.callout)
                                }
                                .disabled(!metric.isSelected && viewModel.metricSelections.filter { $0.isSelected }.count >= 3)
                            }
                        }
                        .cardStyle()
                        
                        VStack(spacing: DesignSystem.Spacing.s) {
                            Text("Competition Duration")
                                .font(.body.weight(.semibold))
                                .foregroundColor(DesignSystem.Colors.primary)
                            
                            Stepper(value: $viewModel.competitionDurationDays, in: 1...7) {
                                Text("\(viewModel.competitionDurationDays) day\(viewModel.competitionDurationDays > 1 ? "s" : "")")
                                    .foregroundColor(DesignSystem.Colors.secondary)
                            }
                            
                            StyledTextField(title: "Prize (optional)", text: $viewModel.competitionPrize)
                            
                            PrimaryButton(title: "Send Competition") {
                                Task { await viewModel.sendCompetition() } 
                            }
                            .disabled(!viewModel.isReadyToSend)
                        }
                        .cardStyle()
                    }
                }
            }
            .padding(DesignSystem.Spacing.l)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .hideKeyboardOnTap()
            .overlay(InfoBannerView())
            .task { await viewModel.refreshUser() }
        }
        .background(DesignSystem.Colors.background)
    }
}

#Preview {
    CompetitionView(coordinator: Coordinator())
}
