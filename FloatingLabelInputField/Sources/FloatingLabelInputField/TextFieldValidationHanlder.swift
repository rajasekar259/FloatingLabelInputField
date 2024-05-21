//
//  TextFieldValidationHanlder.swift
//  FloatingLabelInputFieldApp
//
//  Created by rajasekar.r on 21/05/24.
//

import SwiftUI


public enum TextFieldValidationError: Error {
    case invalid(String)
    
    var message: String {
        switch self {
        case .invalid(let string):
            return string
        }
    }
}

public typealias TextFieldErrorHanlder = (String) -> Result<Bool, TextFieldValidationError>

private struct TextFieldValidationHanlder: EnvironmentKey {
    static var defaultValue: TextFieldErrorHanlder?
}

public extension EnvironmentValues {
    var textFieldValidationHanlder: TextFieldErrorHanlder? {
        get { self[TextFieldValidationHanlder.self] }
        set { self[TextFieldValidationHanlder.self] = newValue }
    }
}

public extension View {
    func onValidate(handler: @escaping TextFieldErrorHanlder) -> some View {
        environment(\.textFieldValidationHanlder, handler)
    }
}
