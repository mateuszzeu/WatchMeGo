//
//  MainView.swift
//  WatchMeGo
//
//  Created by Liza on 23/05/2025.
//
import UIKit

class MainView: UIView {
    
    let titleLabel = UILabel()
    
    let progressCard = ProgressCardView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(progressCard)
        
        titleLabel.text = "WatchMeGo"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        progressCard.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            progressCard.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            progressCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            progressCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
}
