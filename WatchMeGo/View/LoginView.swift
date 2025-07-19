//
//  LoginView.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import SwiftUI

struct LoginView: View {
    @Bindable var coordinator: Coordinator
    @Bindable private var viewModel = LoginViewModel()
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Sign In")
                .font(.largeTitle.bold())
                .padding(.bottom, 20)

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(12)
                .background(Color("BackgroundPrimary"))
                .cornerRadius(10)

            SecureField("Password", text: $password)
                .padding(12)
                .background(Color("BackgroundPrimary"))
                .cornerRadius(10)

            Button(action: {
                Task { await viewModel.login(email: email, password: password, coordinator: coordinator) }
            }) {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("ButtonPrimary"))
            .disabled(email.isEmpty || password.isEmpty)

            Button("No account? Register") {
                coordinator.showRegister()
            }
            .font(.footnote)
            .tint(Color("ButtonPrimary"))

            if let info = viewModel.infoMessage {
                Text(info)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    LoginView(coordinator: Coordinator())
}

