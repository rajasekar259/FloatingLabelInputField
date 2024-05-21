//
//  ContentView.swift
//  FloatingLabelInputFieldApp
//
//  Created by rajasekar.r on 20/05/24.
//

import SwiftUI
import FloatingLabelInputField

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            FloatingLabelInputField(label: "Enter your email", text: "")
                .onValidate { text in
                    let emailRegex = try! Regex("^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$")
                    let isValidEmail = text.wholeMatch(of: emailRegex) != nil
                    
                    if text.isEmpty { return .success(false) }
                    
                    return if isValidEmail { .success(true) }
                    else { .failure(.invalid("Invalid email")) }
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
