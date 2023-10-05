//
//  Animal.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 6/23/23.
//

import SwiftUI

struct Animal: Identifiable {
    var name: String
    var species: String
    var pawSize: PawSize
    var favoriteFruits: [Fruit]
    var emoji: String

    var id: String { species }
}

extension Animal {
    struct Storage: Codable {
        var alibi: String = ""
        var sleepSchedule: SleepSchedule? = nil

        /// Value between 0 and 1 representing how suspicious the animal is.
        /// 1 is guilty.
        var suspiciousLevel: Double = 0.0

        struct SleepSchedule: Codable {
            var sleepTime: DateComponents
            var wakeTime: DateComponents
        }

        static let newSleepSchedule: SleepSchedule = {
            // Asleep at 10:30, awake at 6:30
            .init(
                sleepTime: DateComponents(hour: 22, minute: 30),
                wakeTime: DateComponents(hour: 6, minute: 30))
        }()
    }
}

var allAnimals: [Animal] = [
    .init(name: "Fabrizio", species: "Fish", pawSize: .small, favoriteFruits: [.arbutusUnedo, .bigBerry, .elstar], emoji: "🐟"),
    .init(name: "Soloman", species: "Snail", pawSize: .small, favoriteFruits: [.elstar, .flavorKing], emoji: "🐌"),
    .init(name: "Ding", species: "Dove", pawSize: .small, favoriteFruits: [.quercusTomentella, .pinkPearlApple, .lapins], emoji: "🕊️"),
    .init(name: "Catie", species: "Crow", pawSize: .small, favoriteFruits: [.pinkPearlApple, .goldenNectar, .hauerPippin], emoji: "🐦‍⬛"),
    .init(name: "Miko", species: "Cat", pawSize: .small, favoriteFruits: [.belleDeBoskoop, .tompkinsKing, .lapins], emoji: "🐈"),
    .init(name: "Ricardo", species: "Rabbit", pawSize: .small, favoriteFruits: [.mariposa, .elephantHeart], emoji: "🐰"),
    .init(name: "Cornelius", species: "Duck", pawSize: .medium, favoriteFruits: [.greenGage, .goldenNectar], emoji: "🦆"),
    .init(name: "Maria", species: "Mouse", pawSize: .small, favoriteFruits: [.arbutusUnedo, .elephantHeart], emoji: "🐹"),
    .init(name: "Haku", species: "Hedgehog", pawSize: .small, favoriteFruits: [.christmasBerry, .creepingSnowberry, .goldenGem], emoji: "🦔"),
    .init(name: "Rénard", species: "Raccoon", pawSize: .medium, favoriteFruits: [.belleDeBoskoop, .bigBerry, .christmasBerry, .kakiFuyu], emoji: "🦝")
]

enum PawSize: Hashable {
    case small
    case medium
    case large
}
