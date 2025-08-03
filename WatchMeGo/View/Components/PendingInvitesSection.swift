import SwiftUI

struct PendingInvitesSection: View {
    let pendingUsers: [AppUser]
    let onAccept: (AppUser) -> Void
    let onDecline: (AppUser) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
            Text("Pending Invites")
                .font(DesignSystem.Fonts.headline)
                .foregroundColor(DesignSystem.Colors.primary)
            if pendingUsers.isEmpty {
                Text("No pending invites")
                    .font(DesignSystem.Fonts.footnote)
                    .foregroundColor(DesignSystem.Colors.secondary)
            } else {
                LazyVStack(spacing: DesignSystem.Spacing.s) {
                    ForEach(pendingUsers) { user in
                        HStack {
                            Text(user.name)
                                .font(DesignSystem.Fonts.body)
                                .foregroundColor(DesignSystem.Colors.primary)
                            Spacer()
                            Button("Accept") { onAccept(user) }
                                .buttonStyle(.borderedProminent)
                                .tint(DesignSystem.Colors.accent)
                            Button("Decline") { onDecline(user) }
                                .buttonStyle(.bordered)
                                .tint(DesignSystem.Colors.error)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignSystem.Spacing.s)
                        .padding(.horizontal, DesignSystem.Spacing.m)
                        .background(.ultraThinMaterial)
                        .cornerRadius(DesignSystem.Radius.m)
                    }
                }
            }
        }
    }
}

#Preview {
    PendingInvitesSection(pendingUsers: [], onAccept: { _ in }, onDecline: { _ in })
        .padding()
        .background(DesignSystem.Colors.background)
}
