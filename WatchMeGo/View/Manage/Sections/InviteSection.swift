//
//  InviteSection.swift
//  WatchMeGo
//
//  Created by MAT on 20/09/2025.
//
import SwiftUI

struct InviteSection: View {
    @Binding var emailToInvite: String
    let onSendInvite: () -> Void
    
    var body: some View {
        VStack {
            Text("Invite a Friend")
                .font(.headline)
                .foregroundColor(DesignSystem.Colors.primary)
                .multilineTextAlignment(.center)

            InviteField(text: $emailToInvite) {
                onSendInvite()
            }
        }
        .cardStyle()
    }
}
