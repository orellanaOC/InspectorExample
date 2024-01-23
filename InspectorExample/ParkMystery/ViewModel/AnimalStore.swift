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
    func callAsFunction<Result>(
        _ keyPath: WritableKeyPath<Animal.Storage, Result>,
        for animal: Animal
    ) -> Binding<Result> {
        Binding { [self] in
            storage[animal.id, default: .init()][keyPath: keyPath]
        } set: { [self] newValue in
            self.objectWillChange.send()
            var animalStore = storage[animal.id, default: .init()]
            animalStore[keyPath: keyPath] = newValue
            storage[animal.id] = animalStore
        }
    }

    func write<Value>(
        _ keyPath: WritableKeyPath<Animal.Storage, Value>,
        value: Value,
        for animal: Animal
    ) {
        objectWillChange.send()
        var animalStore = storage[animal.id, default: .init()]
        animalStore[keyPath: keyPath] = value
        storage[animal.id] = animalStore
    }

    func read<Value>(
        _ keyPath: WritableKeyPath<Animal.Storage, Value>,
        for animal: Animal
    ) -> Value {
        storage[animal.id, default: .init()][keyPath: keyPath]
    }
}
