//
//  NavigationSplitView.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 6/23/23.
//

import SwiftUI

@available(iOS 17.0, *)
struct InspectorView: View {

    @State private var selectedMenuIndex: Int? = 0
    @State private var state = AppState()

    var body: some View {

        NavigationSplitView {
            SideBarView(selectedMenuIndex: $selectedMenuIndex)
                .navigationTitle("Menu")
        } detail: {

            Text("Currently selected \(selectedMenuIndex ?? 0)")

            AnimalTable(state: $state)
//            MARK: - Inside navigation structure
//                .inspector(isPresented: $state.inspectorPresented) {
//                    AnimalInspectorForm(animal: $state.binding())
//                        .presentationDetents([.height(200), .medium, .large])
//                        .presentationBackgroundInteraction(.enabled(upThrough: .height(200)))
//                }
//            MARK: - Toolbar content outside inspector
                .toolbar {
                    Button {
                        state.inspectorPresented.toggle()
                    } label: {
                        Label("Toggle Inspector", systemImage: "info.circle")
                    }
                }
        }
//            MARK: - Outside navigation structure
                .inspector(isPresented: $state.inspectorPresented) {
                    AnimalInspectorForm(animal: $state.binding())
//            MARK: - Toolbar content inside inspector
//                        .toolbar {
//                            Button {
//                                state.inspectorPresented.toggle()
//                            } label: {
//                                Label("Toggle Inspector", systemImage: "info.circle")
//                            }
//                        }
                }
    }
}

#Preview {
    InspectorView()
}
