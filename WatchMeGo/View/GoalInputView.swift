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
        
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
