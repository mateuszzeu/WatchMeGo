//
//  FriendCell.swift
//  WatchMeGo
//
//  Created by Liza on 08/06/2025.
//

import UIKit

class FriendCell: UITableViewCell {
    
    let nicknameLabel = UILabel()
    let competeButton = UIButton(type: .system)
    let deleteButton = UIButton(type: .system)

    var onCompeteTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(competeButton)
        contentView.addSubview(deleteButton)
        
        backgroundColor = .clear
        
        nicknameLabel.font = .systemFont(ofSize: 16)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        competeButton.setImage(UIImage(systemName: "flame"), for: .normal)
        competeButton.tintColor = .gray
        competeButton.addTarget(self, action: #selector(competeTapped), for: .touchUpInside)
        competeButton.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .gray 
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nicknameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nicknameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            competeButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -16),
            competeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    @objc private func competeTapped() {
        onCompeteTapped?()
    }

    @objc private func deleteTapped() {
        onDeleteTapped?()
    }

    func configure(with nickname: String, isAlly: Bool) {
        nicknameLabel.text = nickname
        competeButton.tintColor = isAlly ? AppStyle.Colors.accent : .gray
    }
}
