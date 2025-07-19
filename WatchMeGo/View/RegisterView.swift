//
//  RegisterView.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import SwiftUI

struct RegisterView: View {
    @Bindable var coordinator: Coordinator
    @Bindable private var viewModel = RegisterViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Register")
                .font(.largeTitle.bold())
                .padding(.bottom, 20)

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            SecureField("Password", text: $password)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            TextField("Username", text: $username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            Button(action: {
                Task {
                    await viewModel.register(
                        email: email,
                        password: password,
                        username: username,
                        coordinator: coordinator
                    )
                }
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.phthaloGreen)
            .disabled(email.isEmpty || password.isEmpty || username.isEmpty)

            Button("Already have an account? Sign In") {
                coordinator.showLogin()
            }
            .font(.footnote)
            .tint(.phthaloGreen)

            if let info = viewModel.infoMessage {
                Text(info)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    RegisterView(coordinator: Coordinator())
}

