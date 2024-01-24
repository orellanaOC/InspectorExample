//
//  Binding+Extensions.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 10/1/23.
//

import SwiftUI

extension Binding where Value == AppState {
    func binding() -> Binding<Animal>? {
        self.projectedValue.animals.first {
            $0.wrappedValue.id == self.selection.wrappedValue
        }
    }
}
