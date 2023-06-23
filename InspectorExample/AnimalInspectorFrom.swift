//
//  AnimalInspectorFrom.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 6/23/23.
//

import SwiftUI

@available(iOS 17.0, *)
struct AnimalInspectorForm: View {
    var animal: Binding<Animal>?
    @EnvironmentObject private var animalStore: AnimalStore

    var body: some View {
        Form {
            if let animal = animal {
                SelectedAnimalInspector(animal: animal, animalStore: animalStore)
            } else {
                ContentUnavailableView {
                    Image(systemName: "magnifyingglass.circle")
                } description: {
                    Text("Select a suspect to inspect")
                } actions: {
                    Text("Fill out details from the interview")
                }
            }
        }
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
}

struct SelectedAnimalInspector: View {
    @Binding var animal: Animal
    @ObservedObject var animalStore: AnimalStore

    var body: some View {
        Section("Identity") {
            TextField("Name", text: $animal.name)
            Picker("Paw Size", selection: $animal.pawSize) {
                Text("Small").tag(PawSize.small)
                Text("Medium").tag(PawSize.medium)
                Text("Large").tag(PawSize.large)
            }
            FruitList(selectedFruits: $animal.favoriteFruits, fruits: allFruits)
        }

        Section {
            TextField(text: animalStore(\.alibi, for: animal), prompt: Text("What was \(animal.name) doing at the time of nibbling?"), axis: .vertical) {
                Text("Alibi")
            }
            .lineLimit(4, reservesSpace: true)
            if let schedule = Binding(animalStore(\.sleepSchedule, for: animal)) {
                SleepScheduleView(schedule: schedule)
            } else {
                Button("Add Sleep Schedule") {
                    animalStore.write(\.sleepSchedule, value: Animal.Storage.newSleepSchedule, for: animal)
                }
            }
            Slider(
                value: animalStore(\.suspiciousLevel, for: animal), in: 0...1) {
                    Text("Suspicion Level")
                } minimumValueLabel: {
                    Image(systemName: "questionmark")
                } maximumValueLabel: {
                    Image(systemName: "exclamationmark.3")
                }
        } header: {
            Text("Interview")
        }
        .presentationDetents([.medium, .large])
    }
}


private struct SleepScheduleView: View {
    @Binding var schedule: Animal.Storage.SleepSchedule
    var body: some View {
        DatePicker(selection: .init(get: {
            Calendar.current.date(from: schedule.sleepTime) ?? Date()
        }, set: { newDate in
            schedule.sleepTime = Calendar.current.dateComponents([.hour, .minute], from: newDate)
        }), displayedComponents: [.hourAndMinute]) {
            Text("Sleep at: ")
        }

        DatePicker(selection: .init(get: {
            Calendar.current.date(from: schedule.wakeTime) ?? Date()
        }, set: { newDate in
            schedule.wakeTime = Calendar.current.dateComponents([.hour, .minute], from: newDate)
        }), displayedComponents: [.hourAndMinute]) {
            Text("Awake at: ")
        }
    }
}

struct AppState {
    var selection: String? = "Snail"
    var animals: [Animal] = allAnimals
    var inspectorPresented: Bool = true
    var inspectorWidth: CGFloat = 270
    var cornerRadius: CGFloat? = nil
}
