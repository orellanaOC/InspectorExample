//
//  SideBarView.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 10/1/23.
//

import SwiftUI

struct SideBarView: View {
    struct MenuOption: Identifiable {
        var id: String {
            return menuTitle
        }
        var menuIndex: Int
        var menuTitle: String
        var topic: String
    }

    @Binding var selectedMenuIndex: Int?

    static let menuOptions: [MenuOption] = [
        .init(menuIndex: 0, menuTitle: "InsideNavigationInsideInspector", topic: "Inside Navigation Inside Inspector"),
        .init(menuIndex: 1, menuTitle: "InsideNavigationOutsideInspector", topic: "Inside Navigation Outside Inspector"),
        .init(menuIndex: 2, menuTitle: "OutsideNavigationInsideInspector", topic: "Outside Navigation Inside Inspector"),
        .init(menuIndex: 3, menuTitle: "OutsideNavigationOutsideInspector", topic: "Outside Navigation Outside Inspector")
    ]

    var body: some View {
        List(SideBarView.menuOptions, selection: $selectedMenuIndex) { option in
            Text(option.menuTitle)
                .tag(option.menuIndex)
        }
    }
}
