//
//  FruitNibbleBulletinView.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 6/23/23.
//

import SwiftUI

@available(iOS 17.0, *)
struct FruitNibbleBulletinView: View {
    var fruit: Fruit = .pinkPearlApple
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Grid(horizontalSpacing: 12, verticalSpacing: 2) {
                        GridRow {
                            FruitImageView(fruit: fruit, size: .init(width: 60, height: 60), bordered: false)

                            Text("""
                            A \(fruit.name.lowercased()) was nibbled! The bite \
                            happened at 9:41 AM. The nibbler left behind only \
                            a few seeds.
                            """
                            )
                        }
                        GridRow {
                            Text("""
                            The Fruit Inspectors were on \
                            the scene moments after it happened. \
                            Unfortunately, their efforts to catch the nibbler \
                            were fruitless.
                            """).gridCellColumns(2)
                        }
                    }
                    GroupBox("Clues") {
                        LabeledContent("Paw Size") {
                            Text("Large")
                        }
                        LabeledContent("Favorite Fruit") {
                            Text("\(fruit.name.capitalized(with: .current))")
                        }
                        LabeledContent("Alibi") {
                            Text("None")
                        }
                    }
                    HStack {
                        VStack {
                            fruit.color
                                .aspectRatio(contentMode: ContentMode.fit)
                                .shadow(radius: 2.5)
                            Text("The pink pearls left behind").font(.caption)
                                .frame(alignment: .leading)
                        }
                        AppleParkMapView()
                            .mask(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))

                    }
                    Text("The Fruit Inspection team was on the scene minutes after the incident. However, their attempts to discover any meaningful clues around the identity of the nibbler were fruitless.")
                }
                .scenePadding(.horizontal)
                .toolbar {
                    ToolbarItem {
                        Button(role: .cancel) {
                            dismiss()
                        } label: {
                            Label("Close", systemImage: "xmark.circle.fill")
                        }
                        .symbolRenderingMode(.monochrome)
                        .tint(.secondary)
                    }
                }
            }
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .navigationTitle("Fruit Nibble Bulletin")
        }
    }
}

#Preview {
    FruitNibbleBulletinView()
}
