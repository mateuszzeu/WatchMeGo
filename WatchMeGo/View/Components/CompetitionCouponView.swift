import SwiftUI

struct CompetitionCouponView: View {
    let challenger: String
    let onAccept: () -> Void
    let onDecline: () -> Void
    @State private var appear = false

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
            Text("\(challenger) invited you to a competition!")
                .font(DesignSystem.Fonts.headline)
                .foregroundColor(DesignSystem.Colors.primary)
            HStack(spacing: DesignSystem.Spacing.m) {
                Button("Accept", action: onAccept)
                    .buttonStyle(.borderedProminent)
                    .tint(DesignSystem.Colors.accent)
                Button("Decline", action: onDecline)
                    .buttonStyle(.bordered)
                    .tint(DesignSystem.Colors.error)
            }
        }
        .padding(DesignSystem.Spacing.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DesignSystem.Colors.surface)
        .cornerRadius(DesignSystem.Radius.l)
        .shadow(radius: DesignSystem.Radius.s)
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.l)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                .foregroundColor(DesignSystem.Colors.accent.opacity(0.5))
        )
        .scaleEffect(appear ? 1 : 0.95)
        .opacity(appear ? 1 : 0)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: appear)
        .onAppear { appear = true }
    }
}

#Preview {
    CompetitionCouponView(challenger: "Jane", onAccept: {}, onDecline: {})
        .padding()
        .background(DesignSystem.Colors.background)
}
