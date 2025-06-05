//
//  GoalButtonView.swift
//  WatchMeGo
//
//  Created by Liza on 01/06/2025.
//

import UIKit

class PrimaryButtonView: UIView {
    let button = UIButton(type: .system)
    
    init(title: String) {
        super.init(frame: .zero)
        setupUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(title: String) {
        addSubview(button)
        
        backgroundColor = AppStyle.Colors.backgroundSecondary
        layer.cornerRadius = 12
        clipsToBounds = true
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(AppStyle.Colors.buttonText, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}
