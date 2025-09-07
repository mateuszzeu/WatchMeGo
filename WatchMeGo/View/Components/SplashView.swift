import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: DesignSystem.Spacing.l) {
                Text("WatchMeGo")
                    .font(.title)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .opacity(textOpacity)
                
                Image(systemName: "figure.run.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(DesignSystem.Colors.accent)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        withAnimation(.easeOut(duration: 0.8)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        withAnimation(.easeIn(duration: 0.6).delay(0.3)) {
            textOpacity = 1.0
        }
    }
}

#Preview {
    SplashView()
}
