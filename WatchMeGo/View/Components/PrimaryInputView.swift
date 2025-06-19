//
//  GoalInputView.swift
//  WatchMeGo
//
//  Created by Liza on 01/06/2025.
//

import UIKit

class PrimaryInputView: UIView {
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
        
        backgroundColor = .clear
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = AppStyle.Colors.border.cgColor
        
        textField.placeholder = placeholder
        textField.backgroundColor = .clear
        textField.keyboardType = .numberPad
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = AppStyle.Colors.textPrimary
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14)
        ])
    }
}
