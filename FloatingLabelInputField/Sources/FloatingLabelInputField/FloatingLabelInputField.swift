//
//  FloatingLabelInputField.swift
//  FloatingLabelInputFieldApp
//
//  Created by rajasekar.r on 20/05/24.
//

import SwiftUI

public struct FloatingLabelInputField: View {
    var label: String
    
    @State var text: String
    @State var invalidMessage: String?
    @State var isValidBinding: Bool?

    @Environment(\.isMandatoryField) var isMandatory
    @Environment(\.textFieldValidationHanlder) var validationHandler
    
    public init(label: String, text: String, invalidMessage: String? = nil, isValidBinding: Bool? = nil) {
        self.label = label
        self.text = text
        self.invalidMessage = invalidMessage
        self.isValidBinding = isValidBinding
    }
    
    @ViewBuilder
    var clearButton: some View {
        if text.isEmpty { EmptyView() }
        else {
            HStack {
                Spacer()
                Button(action: { text = "" }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                })
            }
        }
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            Text(invalidMessage ?? label)
                .offset(y: text.isEmpty ? 0 : -30)
                .scaleEffect(text.isEmpty ? 1 : 0.8, anchor: .leading)
                .foregroundStyle(invalidMessage != nil ? .red : text.isEmpty ? .secondary : .primary)
            TextField("", text: $text)
                .padding(.trailing, 20) //Clear Button padding
                .overlay(clearButton)
        }
        .padding(.top, 25)
        .animation(.easeInOut, value: text)
        .onAppear(perform: {
            validate(text)
        })
        .onChange(of: text, perform: { validate($0) })
    }
    
    private func validate(_ text: String) {
        if isMandatory, text.isEmpty {
            invalidMessage = "This is mandatory field"
            isValidBinding = false
            return
        }
        
        guard let validationHandler else {
            invalidMessage = nil
            isValidBinding = true
            return
        }
        
        let result = validationHandler(text)
        switch result {
        case .success:
            isValidBinding = true
            invalidMessage = nil
        case .failure(let error):
            invalidMessage = error.message
            isValidBinding = false
        }
    }
}

#Preview {
    FloatingLabelInputField(label: "Enter your input", text: "")
        .setMandatory(true)
        .onValidate { text in
            if text.count >= 3 { return .success(true) }
            else { return .failure(.invalid("Text should be more than 2 char"))}
        }
}

#Preview {
    FloatingLabelInputField(label: "Enter your input", text: "")
        .onValidate { text in
            if text.isEmpty || text.count >= 3 { return .success(true) }
            else { return .failure(.invalid("Text should be more than 2 char"))}
        }
}

#Preview {
    FloatingLabelInputField(label: "Enter your email", text: "")
        .onValidate { text in
            let emailRegex = try! Regex("^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$")
            let isValidEmail = text.wholeMatch(of: emailRegex) != nil
            
            if text.isEmpty { return .success(false) }
            
            return if isValidEmail { .success(true) }
            else { .failure(.invalid("Invalid email")) }
        }
}
