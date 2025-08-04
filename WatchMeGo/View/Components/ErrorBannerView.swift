//
//  ErrorBannerView.swift
//  WatchMeGo
//
//  Created by Liza on 03/08/2025.
//

import SwiftUI

struct ErrorBannerView: View {
    @Bindable private var handler = ErrorHandler.shared

    var body: some View {
        Group {
            if handler.showError, let message = handler.errorMessage {
                VStack {
                    Spacer()
                    Text(message)
                        .font(DesignSystem.Fonts.footnote)
                        .foregroundColor(DesignSystem.Colors.background)
                        .padding(.horizontal, DesignSystem.Spacing.l)
                        .padding(.vertical, DesignSystem.Spacing.s)
                        .background(DesignSystem.Colors.error.opacity(0.9))
                        .cornerRadius(DesignSystem.Radius.l)
                        .shadow(radius: DesignSystem.Radius.s)
                        .padding(.bottom, DesignSystem.Spacing.l * 2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut, value: handler.showError)
            }
        }
    }
}
