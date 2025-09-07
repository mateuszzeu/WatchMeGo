//
//  StyledTextField.swift
//  WatchMeGo
//
//  Created by Liza on 03/08/2025.
//

import SwiftUI

struct StyledTextField: View {
    let title: String
    @Binding var text: String
    var isSecure: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
            Text(title)
                .font(.body)
                .foregroundColor(isFocused ? DesignSystem.Colors.accent : DesignSystem.Colors.secondary.opacity(0.6))
                .animation(.easeInOut(duration: 0.2), value: isFocused)
            
            Group {
                if isSecure {
                    SecureField("", text: $text)
                        .placeholder(when: text.isEmpty) {
                            Text("Type...")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.secondary.opacity(0.5))
                        }
                } else {
                    TextField("", text: $text)
                        .placeholder(when: text.isEmpty) {
                            Text("Type...")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.secondary.opacity(0.5))
                        }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
            .font(.body)
            .focused($isFocused)
        }
        .padding(DesignSystem.Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.m)
                .fill(DesignSystem.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Radius.m)
                        .stroke(
                            isFocused ? DesignSystem.Colors.accent : Color.clear,
                            lineWidth: 2
                        )
                )
        )
        .scaleEffect(isFocused ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
