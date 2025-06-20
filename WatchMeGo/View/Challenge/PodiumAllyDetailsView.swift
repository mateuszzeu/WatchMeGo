//
//  PodiumAllyDetailsView.swift
//  WatchMeGo
//
//  Created by Liza on 20/06/2025.
//

import UIKit

class PodiumAllyDetailsView: UIView {
    
    let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = AppStyle.Colors.background
        
        addSubview(statusLabel)
        
        statusLabel.text = "Work in progress 🚧"
        statusLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        statusLabel.textAlignment = .center
        statusLabel.textColor = AppStyle.Colors.textPrimary
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
