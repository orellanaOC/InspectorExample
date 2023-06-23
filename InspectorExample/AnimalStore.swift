//
//  AnimalStore.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 6/23/23.
//

import SwiftUI

final class AnimalStore: ObservableObject {

    var storage: [Animal.ID: Animal.Storage] = [:]

    /// Getter for properties of an animal stored in self
    func callAsFunction<Result>(_ keyPath: WritableKeyPath<Animal.Storage, Result>, for animal: Animal) -> Binding<Result> {
        Binding { [self] in
            storage[animal.id, default: .init()][keyPath: keyPath]
        } set: { [self] newValue in
            self.objectWillChange.send()
            var animalStore = storage[animal.id, default: .init()]
            animalStore[keyPath: keyPath] = newValue
            storage[animal.id] = animalStore
        }
    }

    func write<Value>(_ keyPath: WritableKeyPath<Animal.Storage, Value>, value: Value, for animal: Animal) {
        objectWillChange.send()
        var animalStore = storage[animal.id, default: .init()]
        animalStore[keyPath: keyPath] = value
        storage[animal.id] = animalStore
    }

    func read<Value>(_ keyPath: WritableKeyPath<Animal.Storage, Value>, for animal: Animal) -> Value {
        storage[animal.id, default: .init()][keyPath: keyPath]
    }
}

@available(iOS 17.0, *)
struct AnimalTable: View {
    @Binding var state: AppState
    @EnvironmentObject private var animalStore: AnimalStore
    @Environment(\.horizontalSizeClass) private var sizeClass: UserInterfaceSizeClass?


    var fruitWidth: CGFloat {
#if os(iOS)
        40.0
#else
        25.0
#endif
    }

    var body: some View {
        Table(state.animals, selection: $state.selection) {
            TableColumn("Name") { animal in
                HStack {
                    Text(animal.emoji).font(.title)
                        .padding(2)
                        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 3))
                    Text(animal.name + " " + animal.species).font(.title3)
                        .onTapGesture {
                            state.inspectorPresented.toggle()
                        }
                }
            }
            TableColumn("Favorite Fruits") { animal in
                HStack {
                    ForEach(animal.favoriteFruits.prefix(3)) { fruit in
                        FruitImage(fruit: fruit, size: .init(width: fruitWidth, height: fruitWidth), scale: 2.0, bordered: state.selection == animal.id)
                    }
                }
                .padding(3.5)
            }
            TableColumn("Suspicion Level") { animal in
                SuspicionTableCell(animal: animal)
            }
        }
#if os(macOS)
        .alternatingRowBackgrounds(.disabled)
#endif
        .tableStyle(.inset)
    }
}

@available(iOS 17.0, *)
private struct SuspicionTableCell: View {
    var animal: Animal
    @Environment(\.backgroundProminence) private var backgroundProminence
    @EnvironmentObject private var animalStore: AnimalStore

    var body: some View {
        let color = SuspiciousText.model(for: animalStore.read(\.suspiciousLevel, for: animal)).1
        HStack {
            Image(
                systemName: "cellularbars",
                variableValue: animalStore.read(\.suspiciousLevel, for: animal)
            )
            .symbolRenderingMode(.hierarchical)
            SuspiciousText(
                suspiciousLevel:
                    animalStore.read(\.suspiciousLevel, for: animal),
                selected: backgroundProminence == .increased)
        }
        .foregroundStyle(backgroundProminence == .increased ? AnyShapeStyle(.white) : AnyShapeStyle(color))
    }
}

private struct SuspiciousText: View {
    var suspiciousLevel: Double
    var selected: Bool

    static fileprivate func model(for level: Double) -> (String, Color) {
        switch level {
            case 0..<0.2:
                return ("Unlikely", .green)
            case 0.2..<0.5:
                return ("Fishy", .mint)
            case 0.5..<0.9:
                return ("Very suspicious", .orange)
            case 0.9...1:
                return ("Extremely suspicious!", .red)
            default:
                return ("Suspiciously Unsuspicious", .blue)
        }
    }

    var body: some View {
        let model = Self.model(for: suspiciousLevel)
        Text(model.0)
            .font(.callout)
    }
}

