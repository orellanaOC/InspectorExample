//
//  FruitList.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 6/23/23.
//

import SwiftUI

struct FruitList: View {
    @State private var selectedFruit: Fruit?
    @Binding var selectedFruits: [Fruit]
    var fruits: [Fruit]

    var body: some View {
        Section("Favorite Fruits") {
            ForEach(allFruits) { fruit in
                Toggle(isOn: .init(get: {
                    selectedFruits.contains(fruit)
                }, set: { newValue in
                    if newValue && !selectedFruits.contains(fruit) {
                        selectedFruits.append(fruit)
                    } else {
                        _ = selectedFruits.firstIndex(of: fruit).map {
                            selectedFruits.remove(at: $0)
                        }
                    }
                })) {
                    HStack {
                        FruitImageView(fruit: fruit, size: .init(width: 40, height: 40), bordered: true)
                            .onTapGesture {
                            selectedFruit = .flavorKing
                        }
//                            .sheet(item: $selectedFruit) { fruit in
//                                FruitNibbleBulletinView(fruit: fruit)
//                                    .presentationBackground(.thinMaterial)
//                                    .presentationDetents([.height(200), .medium, .large])
//                                    .presentationBackgroundInteraction(.enabled(upThrough: .height(200)))
//                            }
                        Text(fruit.name).font(.body)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func selectionBackground(isSelected: Bool) -> some View {
        if isSelected {
            RoundedRectangle(cornerRadius: 2).inset(by: -2)
                .fill(.selection)
        }
    }
}
