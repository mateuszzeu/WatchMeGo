//
//  AppStyle.swift
//  WatchMeGo
//
//  Created by Liza on 02/06/2025.
//

import UIKit

struct AppStyle {

    struct Colors {
        static var background: UIColor {
            UIColor(light: "#F8F8FC", dark: "#181520")
        }
        
        static var backgroundSecondary: UIColor {
            UIColor(light: "#F2F2F7", dark: "#282631")
        }

        static var textPrimary: UIColor {
            UIColor(light: "#1A1A1A", dark: "#DDD9E8")
        }

        static var textSecondary: UIColor {
            UIColor(light: "#444444", dark: "#AAAAAA")
        }

        static var border: UIColor {
            UIColor(light: "#D4D3E0", dark: "#3D394D")
        }

        static var accent: UIColor {
            UIColor(light: "#123524", dark: "#123524")
        }

        static var buttonText: UIColor {
            accent
        }
    }

    struct Fonts {
        static var largeTitle: UIFont { .systemFont(ofSize: 32, weight: .bold) }
        static var title: UIFont { .systemFont(ofSize: 22, weight: .bold) }
        static var subtitle: UIFont { .systemFont(ofSize: 18, weight: .semibold) }
        static var body: UIFont { .systemFont(ofSize: 16) }
        static var caption: UIFont { .systemFont(ofSize: 13) }
        static var button: UIFont { .systemFont(ofSize: 18, weight: .bold) }
        static var smallButton: UIFont { .systemFont(ofSize: 15, weight: .bold) }
    }
}



extension UIColor {
    convenience init(hex: String) {
        var hexString = hex
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255
        let blue = CGFloat(rgbValue & 0x0000FF) / 255

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    convenience init(light: String, dark: String) {
        self.init { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: dark)
                : UIColor(hex: light)
        }
    }
}


extension UITextField {
    func applyInputFieldStyle(placeholder: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.borderStyle = .none
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 0.5
        self.layer.borderColor = AppStyle.Colors.border.cgColor
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 35))
        self.leftViewMode = .always
        self.backgroundColor = AppStyle.Colors.background
        self.textColor = AppStyle.Colors.textPrimary
        self.font = UIFont.systemFont(ofSize: 15)
        self.placeholder = placeholder
    }
}
