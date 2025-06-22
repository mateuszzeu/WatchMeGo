//
//  InviteCell.swift
//  WatchMeGo
//
//  Created by Liza on 05/06/2025.
//

import UIKit

class InviteCell: UITableViewCell {
    let nicknameLabel = UILabel()
    let acceptButton = UIButton(type: .system)
    let rejectButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(acceptButton)
        contentView.addSubview(rejectButton)
        
        backgroundColor = .clear
        
        nicknameLabel.font = UIFont.systemFont(ofSize: 16)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        
        rejectButton.setTitle("Reject", for: .normal)
        rejectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nicknameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nicknameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rejectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rejectButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            acceptButton.trailingAnchor.constraint(equalTo: rejectButton.leadingAnchor, constant: -12),
            acceptButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with nickname: String, index: Int, target: Any?, acceptSelector: Selector, rejectSelector: Selector) {
        nicknameLabel.text = "From: \(nickname)"
        acceptButton.tag = index
        rejectButton.tag = index
        acceptButton.addTarget(target, action: acceptSelector, for: .touchUpInside)
        rejectButton.addTarget(target, action: rejectSelector, for: .touchUpInside)
    }
}

