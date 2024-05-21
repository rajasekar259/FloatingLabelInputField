//
//  TextFieldMandatory.swift
//  FloatingLabelInputFieldApp
//
//  Created by rajasekar.r on 21/05/24.
//

import SwiftUI


private struct TextFieldMandatory: EnvironmentKey {
    static var defaultValue: Bool = false
}

public extension EnvironmentValues {
    var isMandatoryField: Bool {
        get { self[TextFieldMandatory.self] }
        set { self[TextFieldMandatory.self] = newValue }
    }
}

public extension View {
    func setMandatory(_ isMandatory: Bool = true) -> some View {
        environment(\.isMandatoryField, isMandatory)
    }
}
