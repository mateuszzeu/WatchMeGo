//
//  PendingInviteView.swift
//  WatchMeGo
//
//  Created by MAT on 20/09/2025.
//
import SwiftUI

struct PendingInviteView: View {
    let friendship: Friendship
    let requesterName: String
    let onAccept: () -> Void
    let onDecline: () -> Void
    
    var body: some View {
        HStack {
            Text(requesterName)
                .font(.body.weight(.medium))
                .foregroundColor(DesignSystem.Colors.primary)
            
            Spacer()
            
            HStack(spacing: DesignSystem.Spacing.s) {
                Button("Accept") {
                    onAccept()
                }
                .font(.caption.weight(.medium))
                .padding(.horizontal, DesignSystem.Spacing.m)
                .padding(.vertical, DesignSystem.Spacing.s)
                .background(DesignSystem.Colors.accent)
                .foregroundColor(.white)
                .cornerRadius(DesignSystem.Radius.s)
                
                Button("Decline") {
                    onDecline()
                }
                .font(.caption.weight(.medium))
                .padding(.horizontal, DesignSystem.Spacing.m)
                .padding(.vertical, DesignSystem.Spacing.s)
                .background(DesignSystem.Colors.error.opacity(0.1))
                .foregroundColor(DesignSystem.Colors.error)
                .cornerRadius(DesignSystem.Radius.s)
            }
        }
        .padding(DesignSystem.Spacing.m)
        .background(DesignSystem.Colors.surface)
        .cornerRadius(DesignSystem.Radius.m)
        .shadow(color: DesignSystem.Colors.primary.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
