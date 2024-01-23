//
//  NavigationSplitView.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 6/23/23.
//

import SwiftUI

struct InspectorView: View {
    @State private var selectedMenuIndex: Int? = .zero
    @State private var state = AppState()

    var title: some View {
        Text(SideBarView.menuOptions[selectedMenuIndex ?? .zero].topic)
            .headerProminence(.standard)
    }

    var sideBar: some View {
        SideBarView(selectedMenuIndex: $selectedMenuIndex)
            .navigationTitle("Menu")
    }

    var body: some View {
        switch selectedMenuIndex {
        case 0:
//          MARK: - Inside navigation structure - Toolbar content inside inspector
            NavigationSplitView {
                sideBar
            } detail: {
                title

                DrawingView(showInspector: $state.inspectorPresented)
            }
        case 1:
//          MARK: - Inside navigation structure - Toolbar content outside inspector
            NavigationSplitView {
                sideBar
            } detail: {
                title

                
                EmojiArtDocumentView(document: EmojiArtDocument(), showInspector: $state.inspectorPresented)
            }
        case 2:
//          MARK: - Outside navigation structure - Toolbar content inside inspector
            NavigationSplitView {
                sideBar
            } detail: {
                title

                AnimalTable(state: $state)
            }
            .inspector(isPresented: $state.inspectorPresented) {
                AnimalInspectorForm(animal: $state.binding())
                    .presentationDetents([.height(200), .medium, .large])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(200)))
                    .toolbar {
                        Button {
                            state.inspectorPresented.toggle()
                        } label: {
                            Label("Toggle Inspector", systemImage: "info.circle")
                        }
                    }
            }
        case 3:
//          MARK: - Outside navigation structure - Toolbar content outside inspector
            NavigationSplitView {
                sideBar
            } detail: {
                title

                AnimalTable(state: $state)
                    .toolbar {
                        Button {
                            state.inspectorPresented.toggle()
                        } label: {
                            Label("Toggle Inspector", systemImage: "info.circle")
                        }
                    }
            }
            .inspector(isPresented: $state.inspectorPresented) {
                AnimalInspectorForm(animal: $state.binding())
                    .presentationDetents([.height(200), .medium, .large])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(200)))
            }

        case .some, .none:
            NavigationSplitView {
                sideBar
            } detail: {
                Text(SideBarView.menuOptions[selectedMenuIndex ?? .zero].topic).headerProminence(.standard)

                AnimalTable(state: $state)
            }
        }
    }
}

#Preview {
    InspectorView()
}
