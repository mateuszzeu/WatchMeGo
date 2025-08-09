import SwiftUI

extension Color {
    func darker(by amount: Double = 0.2) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        guard uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else { return self }
        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(max(brightness - CGFloat(amount), 0)), opacity: Double(alpha))
    }
}
