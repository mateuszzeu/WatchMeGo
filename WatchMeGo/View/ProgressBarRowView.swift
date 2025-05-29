//
//  ProgressBarRowView.swift
//  WatchMeGo
//
//  Created by Liza on 28/05/2025.
//

import UIKit

class ProgressBarRowView: UIView {
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let progressView = UIProgressView()
    private let valueLabel = UILabel()
    
    init(icon: UIImage?, title: String, progressColor: UIColor) {
        super.init(frame: .zero)
        setupUI(icon: icon, title: title, progressColor: progressColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init (coder:) has not been implemented")
    }
    
    func setProgress(current: Int, goal: Int, animated: Bool = true) {
        valueLabel.text = "\(current)/\(goal)"
        let percent = goal == 0 ? 0 : min(Float(current) / Float(goal), 1.0)
        progressView.setProgress(percent, animated: animated)
    }
    
    private func setupUI(icon: UIImage?, title: String, progressColor: UIColor) {
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(progressView)
        addSubview(valueLabel)
        
        iconView.image = icon
        iconView.tintColor = progressColor
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.progressTintColor = progressColor
        progressView.trackTintColor = .systemGray5
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        valueLabel.text = "0/0"
        valueLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .medium)
        valueLabel.textColor = .secondaryLabel
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: 80),
            
            progressView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -12),
            progressView.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
}
