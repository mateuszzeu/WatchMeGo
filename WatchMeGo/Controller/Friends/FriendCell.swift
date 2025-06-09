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
    
    var onCompeteTapped: (() -> Void)?
    
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
        
        nicknameLabel.font = .systemFont(ofSize: 16)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        competeButton.setImage(UIImage(systemName: "flame"), for: .normal)
        competeButton.tintColor = .gray
        competeButton.addTarget(self, action: #selector(competeTapped), for: .touchUpInside)
        competeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nicknameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nicknameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            competeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            competeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc private func competeTapped() {
        onCompeteTapped?()
    }
    
    func configure(with nickname: String, isRival: Bool) {
        nicknameLabel.text = nickname
        competeButton.tintColor = isRival ? .red : .gray
    }
}
