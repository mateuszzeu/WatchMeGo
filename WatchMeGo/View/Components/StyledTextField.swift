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

    var body: some View {
        Group {
            if isSecure {
                SecureField(title, text: $text)
            } else {
                TextField(title, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
        }
        .font(DesignSystem.Fonts.body)
        .padding(DesignSystem.Spacing.s)
        .background(DesignSystem.Colors.surface)
        .cornerRadius(DesignSystem.Radius.m)
    }
}
