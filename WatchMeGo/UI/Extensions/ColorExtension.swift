//
//  ColorExtension.swift
//  WatchMeGo
//
//  Created by Liza on 03/08/2025.
//

import SwiftUI


//extension Color {
//    func darker(by amount: Double = 0.2) -> Color {
//        let resolved = UIColor(self).resolvedColor(with: UIScreen.main.traitCollection)
//
//        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
//        
//        guard resolved.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
//            return self
//        }
//
//        let delta = CGFloat(max(0, min(amount, 1)))
//        let newBrightness = max(brightness - delta, 0)
//
//        let darkerUIColor = UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
//        return Color(uiColor: darkerUIColor)
//    }
//}
