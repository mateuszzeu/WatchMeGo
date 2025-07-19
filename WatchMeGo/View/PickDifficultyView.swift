//
//  PickDifficultyView.swift
//  WatchMeGo
//
//  Created by Liza on 19/07/2025.
//

import SwiftUI

struct PickDifficultyView: View {
    @Binding var selectedDifficulty: Difficulty

    var body: some View {
        Picker("Difficulty", selection: $selectedDifficulty) {
            ForEach(Difficulty.allCases) { level in
                Text(level.rawValue)
                    .tag(level)
            }
        }
        .pickerStyle(.segmented)
        .tint(Color("ButtonPrimary"))
        .padding(.bottom, 12)
    }
}

