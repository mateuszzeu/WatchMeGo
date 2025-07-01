//
//  PodiumView.swift
//  WatchMeGo
//
//  Created by Liza on 20/06/2025.
//

import UIKit

class PodiumView: UIView {

    let iconLabel = UILabel()
    let nameLabel = UILabel()
    let daysLabel = UILabel()

    private let place: Int
    private(set) var name: String?
    private(set) var days: Int?

    init(place: Int, name: String? = nil, days: Int? = nil) {
        self.place = place
        self.name = name
        self.days = days
        super.init(frame: .zero)
        setupUI()
        update(name: name, days: days)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(iconLabel)
        addSubview(nameLabel)
        addSubview(daysLabel)

        let icons = ["🥇", "🥈", "🥉"]
        let borderColors: [UIColor] = [.systemYellow, .systemGray2, .systemOrange]

        backgroundColor = AppStyle.Colors.backgroundSecondary
        layer.cornerRadius = 14
        layer.borderWidth = 3
        layer.borderColor = borderColors[place].cgColor

        iconLabel.text = icons[place]
        iconLabel.font = AppStyle.Fonts.title
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = AppStyle.Fonts.subtitle
        nameLabel.textAlignment = .left
        nameLabel.textColor = AppStyle.Colors.textPrimary
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        daysLabel.font = AppStyle.Fonts.caption
        daysLabel.textColor = AppStyle.Colors.textSecondary
        daysLabel.textAlignment = .right
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 30),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            daysLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            daysLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func update(name: String?, days: Int?) {
        self.name = name
        self.days = days

        if let name = name, let days = days {
            nameLabel.text = name
            daysLabel.text = "\(days) days 🔥"
            let borderColors: [UIColor] = [.systemYellow, .systemGray2, .systemOrange]
            layer.borderColor = borderColors[place].cgColor
        } else {
            nameLabel.text = "Waiting for friend"
            daysLabel.text = ""
            layer.borderColor = UIColor.systemGray3.cgColor
        }
    }
}
