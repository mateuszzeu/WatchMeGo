//
//  GoalInputView.swift
//  WatchMeGo
//
//  Created by Liza on 01/06/2025.
//

import UIKit

class GoalInputView: UIView {
    let textField = UITextField()
    
    init(placeholder: String) {
        super.init(frame: .zero)
        setupUI(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(placeholder: String) {
        addSubview(textField)
        
        backgroundColor = AppStyle.Colors.backgroundSecondary
        layer.cornerRadius = 12
        
        textField.placeholder = placeholder
        textField.backgroundColor = AppStyle.Colors.backgroundSecondary
        textField.keyboardType = .numberPad
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}
