//
//  NavigationSplitView.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 6/23/23.
//

import SwiftUI

@available(iOS 17.0, *)
struct NavigationSplitView_Example: View {

    @State private var selectedMenuIndex: Int? = 0
    @State private var state = AppState()

    var body: some View {

        NavigationSplitView {
            NavigationSplitView_Example_MenuBar(selectedMenuIndex: $selectedMenuIndex)
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
//                .toolbar {
//                    Button {
//                        state.inspectorPresented.toggle()
//                    } label: {
//                        Label("Toggle Inspector", systemImage: "info.circle")
//                    }
//                }
        }
//            MARK: - Outside navigation structure
                .inspector(isPresented: $state.inspectorPresented) {
                    AnimalInspectorForm(animal: $state.binding())
                        .toolbar {
                            Button {
                                state.inspectorPresented.toggle()
                            } label: {
                                Label("Toggle Inspector", systemImage: "info.circle")
                            }
                        }
                        .presentationDetents([.height(200), .medium, .large])
                        .presentationBackgroundInteraction(.enabled(upThrough: .height(200)))
//            MARK: - Toolbar content inside inspector
//                .toolbar {
//                    Button {
//                        state.inspectorPresented.toggle()
//                    } label: {
//                        Label("Toggle Inspector", systemImage: "info.circle")
//                    }
//                }
                }
    }
}
struct MenuOption: Identifiable {
    var id: String {
        return menuTitle
    }
    var menuIndex: Int
    var menuTitle: String
}

struct NavigationSplitView_Example_MenuBar: View {

    @Binding var selectedMenuIndex: Int?

    static let menuOptions: [MenuOption] = [
        .init(menuIndex: 0, menuTitle: "Menu 0"),
        .init(menuIndex: 1, menuTitle: "Menu 1"),
        .init(menuIndex: 2, menuTitle: "Menu 2"),
        .init(menuIndex: 3, menuTitle: "Menu 3")
    ]

    var body: some View {
        List(NavigationSplitView_Example_MenuBar.menuOptions, selection: $selectedMenuIndex) { option in
            Text(option.menuTitle)
                .tag(option.menuIndex)
        }
    }
}

#Preview {
    NavigationSplitView_Example()
}
