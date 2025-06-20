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
    
    init(place: Int, name: String, days: Int) {
        super.init(frame: .zero)
        setupUI(place: place, name: name, days: days)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(place: Int, name: String, days: Int) {
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
        iconLabel.font = .systemFont(ofSize: 28)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textAlignment = .left
        nameLabel.textColor = AppStyle.Colors.textPrimary
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        daysLabel.text = "\(days) days 🔥"
        daysLabel.font = .systemFont(ofSize: 14)
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
}
