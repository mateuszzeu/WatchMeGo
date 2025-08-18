//
//  InfoBannerView.swift
//  WatchMeGo
//
//  Created by Liza on 03/08/2025.
//

import SwiftUI

struct InfoBannerView: View {
    @Bindable private var handler = MessageHandler.shared

    var body: some View {
        Group {
            if handler.showMessage, let message = handler.message {
                VStack {
                    Spacer()
                    Text(message)
                        .font(DesignSystem.Fonts.footnote)
                        .foregroundColor(.white)
                        .padding(.horizontal, DesignSystem.Spacing.l)
                        .padding(.vertical, DesignSystem.Spacing.s)
                        .background(handler.messageType.backgroundColor.opacity(0.9))
                        .cornerRadius(DesignSystem.Radius.l)
                        .shadow(radius: DesignSystem.Radius.s)
                        .padding(.bottom, DesignSystem.Spacing.l * 2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut, value: handler.showMessage)
            }
        }
    }
}
