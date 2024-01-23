//
//  InspectorExampleApp.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 6/23/23.
//

import SwiftUI

@available(iOS 17.0, *)
@main
struct InspectorExampleApp: App {
    var body: some Scene {
        WindowGroup {
            InspectorView()
                .environmentObject(AnimalStore())
        }
    }
}
