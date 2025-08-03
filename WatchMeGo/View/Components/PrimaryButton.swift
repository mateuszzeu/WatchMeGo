import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var color: Color = DesignSystem.Colors.accent

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DesignSystem.Fonts.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.s)
        }
        .buttonStyle(.plain)
        .background(color)
        .foregroundColor(DesignSystem.Colors.background)
        .cornerRadius(DesignSystem.Radius.m)
        .shadow(radius: DesignSystem.Radius.s, y: DesignSystem.Spacing.xs)
    }
}
