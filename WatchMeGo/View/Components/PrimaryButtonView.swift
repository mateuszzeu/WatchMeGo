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
        
        backgroundColor = .clear
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppStyle.Colors.buttonText
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.titleLabel?.font = AppStyle.Fonts.smallButton
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
