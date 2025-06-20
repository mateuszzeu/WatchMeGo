//
//  ProgressCardView.swift
//  WatchMeGo
//
//  Created by Liza on 28/05/2025.
//

import UIKit

class ProgressCardView: UIView {
    var titleLabel = UILabel()
    
    let stepsRow = ProgressBarRowView(icon: UIImage(systemName: "figure.walk"), title: "Steps", progressColor: .systemBlue)
    let standRow = ProgressBarRowView(icon: UIImage(systemName: "figure.stand"), title: "Stand Hours", progressColor: .systemGreen)
    let caloriesRow = ProgressBarRowView(icon: UIImage(systemName: "flame.fill"), title: "Calories", progressColor: .systemOrange)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init (coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = AppStyle.Colors.backgroundSecondary
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 5
        
        addSubview(titleLabel)
        addSubview(stepsRow)
        addSubview(standRow)
        addSubview(caloriesRow)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Today's Progress"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor = AppStyle.Colors.textPrimary
        
        stepsRow.translatesAutoresizingMaskIntoConstraints = false
        
        standRow.translatesAutoresizingMaskIntoConstraints = false
        
        caloriesRow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            stepsRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            stepsRow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stepsRow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stepsRow.heightAnchor.constraint(equalToConstant: 48),
            
            standRow.topAnchor.constraint(equalTo: stepsRow.bottomAnchor, constant: 12),
            standRow.leadingAnchor.constraint(equalTo: stepsRow.leadingAnchor),
            standRow.trailingAnchor.constraint(equalTo: stepsRow.trailingAnchor),
            standRow.heightAnchor.constraint(equalTo: stepsRow.heightAnchor),
            
            caloriesRow.topAnchor.constraint(equalTo: standRow.bottomAnchor, constant: 12),
            caloriesRow.leadingAnchor.constraint(equalTo: stepsRow.leadingAnchor),
            caloriesRow.trailingAnchor.constraint(equalTo: stepsRow.trailingAnchor),
            caloriesRow.heightAnchor.constraint(equalTo: stepsRow.heightAnchor),
        ])
    }
    
    func setSteps(current: Int, goal: Int) {
        stepsRow.setProgress(current: current, goal: goal)
    }
    
    func setStandHours(current: Int, goal: Int) {
        standRow.setProgress(current: current, goal: goal)
    }
    
    func setCalories(current: Int, goal: Int) {
        caloriesRow.setProgress(current: current, goal: goal)
    }
}
