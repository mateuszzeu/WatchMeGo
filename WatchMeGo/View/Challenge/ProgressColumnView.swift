//
//  ProgressColumnVIew.swift
//  WatchMeGo
//
//  Created by MAT on 10/09/2025.
//
import SwiftUI

struct ProgressColumnView: View {
    let name: String
    let progress: Int
    let isWinning: Bool
    
    @State private var crownRotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    private var fillHeight: CGFloat { 200 * CGFloat(progress) / 2000 }
    private var color: Color { isWinning ? .yellow : .blue }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.s) {
            ZStack {
                if isWinning {
                    Circle().fill(color.opacity(0.3)).frame(width: 50, height: 50)
                        .scaleEffect(pulseScale)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseScale)
                }
                
                Circle().fill(LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 40, height: 40)
                    .shadow(color: color.opacity(0.3), radius: 6)
                
                if isWinning {
                    Image(systemName: "crown.fill").font(.system(size: 20, weight: .bold)).foregroundColor(.white)
                        .rotationEffect(.degrees(crownRotation))
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: crownRotation)
                }
            }.frame(height: 50)
            
            Text(name).font(.callout.weight(.bold)).foregroundColor(isWinning ? .yellow : DesignSystem.Colors.primary)
            
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.1)).frame(width: 70, height: 200)
                
                RoundedRectangle(cornerRadius: 12).fill(LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .bottom, endPoint: .top))
                    .frame(width: 70, height: fillHeight)
                    .animation(.spring(response: 1.2, dampingFraction: 0.8), value: fillHeight)
                    .shadow(color: color.opacity(0.4), radius: 4)
                
                Text("\(progress)").font(.caption.weight(.bold)).foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1)
                    .offset(y: -100 + fillHeight/2)
            }
        }
        .onAppear {
            if isWinning { crownRotation = 5; pulseScale = 1.1 }
        }
    }
}
