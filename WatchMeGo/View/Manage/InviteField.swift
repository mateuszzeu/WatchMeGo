//  InviteField.swift
//  WatchMeGo
//
//  Created by MAT on 20/08/2025.
//

import SwiftUI

struct InviteField: View {
    @Binding var text: String
    var onSend: () -> Void

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.s) {
            TextField("Friend username", text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .font(.body)
                .padding(.horizontal, DesignSystem.Spacing.s)
                .frame(height: 44)
                .background(.ultraThinMaterial)
                .cornerRadius(DesignSystem.Radius.m)

            Button(action: onSend) {
                HStack(spacing: 6) {
                    Image(systemName: "paperplane.fill")
                    Text("Invite")
                }
                .font(.callout.weight(.semibold))
                .padding(.horizontal, DesignSystem.Spacing.m)
                .frame(height: 44)
                .background(DesignSystem.Colors.accent)
                .foregroundColor(DesignSystem.Colors.background)
                .clipShape(Capsule())
            }
            .disabled(text.isEmpty)
            .opacity(text.isEmpty ? 0.5 : 1)
        }
    }
}

