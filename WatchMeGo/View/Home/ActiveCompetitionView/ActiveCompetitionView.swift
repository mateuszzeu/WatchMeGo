//
//  ActiveCompetitionView.swift
//  WatchMeGo
//
//  Created by MAT on 09/09/2025.
//
import SwiftUI

struct ActiveCompetitionView: View {
    let competition: Competition
    let competitiveUser: AppUser?
    let remainingString: String
    let onTick: (Date) -> Void
    
    @State private var now = Date()
    @State private var ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.s) {
            VStack {
                Text(competition.name)
                    .font(.title2)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                if let competitiveUser = competitiveUser {
                    Text("Active competition with \(competitiveUser.name)")
                        .font(.caption2)
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .opacity(0.7)
                }
            }
            
            VStack {
                Text("TIME LEFT")
                    .font(.caption2)
                    .foregroundColor(DesignSystem.Colors.accent)
                    .tracking(1)
                
                Text(remainingString)
                    .font(.title2.bold())
                    .foregroundColor(DesignSystem.Colors.accent)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.l)
        .padding(.vertical, DesignSystem.Spacing.s)
        .frame(maxWidth: .infinity)
        .background(DesignSystem.Colors.surface)
        .cornerRadius(DesignSystem.Radius.l)
        .onReceive(ticker) { currentTime in
            now = currentTime
            onTick(currentTime)
        }
    }
}
