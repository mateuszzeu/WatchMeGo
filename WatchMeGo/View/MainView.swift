//
//  MainView.swift
//  WatchMeGo
//
//  Created by Liza on 23/05/2025.
//
import UIKit

class MainView: UIView {
    
    let titleLabel = UILabel()
    let stepsLabel = UILabel()
    let setGoalButton = UIButton(type: .system)
    let progressView = UIProgressView()
    
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
        addSubview(stepsLabel)
        addSubview(setGoalButton)
        addSubview(progressView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "WatchMeGo"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        
        stepsLabel.translatesAutoresizingMaskIntoConstraints = false
        stepsLabel.font = UIFont.systemFont(ofSize: 18)
        stepsLabel.textColor = .secondaryLabel
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0
        progressView.progressTintColor = .systemGreen
        progressView.trackTintColor = .systemGray
        
        setGoalButton.translatesAutoresizingMaskIntoConstraints = false
        setGoalButton.setTitle("Set Goal", for: .normal)
        setGoalButton.tintColor = .systemGreen
        setGoalButton.backgroundColor = .secondarySystemBackground
        setGoalButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        setGoalButton.layer.cornerRadius = 12
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            stepsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stepsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            progressView.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 20),
            progressView.widthAnchor.constraint(equalToConstant: 200),
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            setGoalButton.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            setGoalButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
