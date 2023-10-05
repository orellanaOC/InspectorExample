//
//  Fruit.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 6/23/23.
//

import SwiftUI

struct Fruit: Identifiable, Hashable {
    var name: String
    var color: Color
    var id: String { name }
}

extension Fruit {
    static let goldenGem = Fruit(name: "Golden Gem Apple", color: .yellow)
    static let flavorKing = Fruit(name: "Flavor King Plum", color: .purple)
    static let mariposa = Fruit(name: "Mariposa Plum", color: .red)
    static let tompkinsKing = Fruit(name: "Tompkins King Apple", color: .yellow)
    static let greenGage = Fruit(name: "Green Gage Plum", color: .green)
    static let lapins = Fruit(name: "Lapins Sweet Cherry", color: .purple)
    static let hauerPippin = Fruit(name: "Hauer Pippin Apple", color: .red)
    static let belleDeBoskoop = Fruit(name: "Belle De Boskoop Apple", color: .red)
    static let elstar = Fruit(name: "Elstar Apple", color: .yellow)
    static let goldenDeliciousApple = Fruit(name: "Golden Delicious Apple", color: .yellow)
    static let creepingSnowberry = Fruit(name: "Creeping Snowberry", color: .white)
    static let quercusTomentella = Fruit(name: "Channel Island Oak Acorn", color: .brown)
    static let elephantHeart = Fruit(name: "Elephant Heart Plum", color: .red)
    static let goldenNectar = Fruit(name: "Golden Nectar Plum", color: .yellow)
    static let pinkPearlApple = Fruit(name: "Pink Pearl Apple", color: .pink)
    static let christmasBerry = Fruit(name: "Christmas Berry", color: .red)
    static let kakiFuyu = Fruit(name: "Kaki Fuyu Persimmon", color: .orange)
    static let bigBerry = Fruit(name: "Big Berry Manzanita", color: .red)
    static let arbutusUnedo = Fruit(name: "Strawberry Tree", color: .red)
}

var allFruits: [Fruit] = [
    .goldenGem,
    .flavorKing,
    .mariposa,
    .tompkinsKing,
    .greenGage,
    .lapins,
    .hauerPippin,
    .belleDeBoskoop,
    .elstar,
    .goldenDeliciousApple,
    .creepingSnowberry,
    .quercusTomentella,
    .elephantHeart,
    .goldenNectar,
    .kakiFuyu,
    .bigBerry,
    .arbutusUnedo,
    .pinkPearlApple,
]
