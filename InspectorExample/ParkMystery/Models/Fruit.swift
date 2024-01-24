//
//  Fruit.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 6/23/23.
//

import SwiftUI

struct Fruit: Identifiable, Hashable {
    var name: String
    var detail: String
    var color: Color
    var id: String { name }
}

extension Fruit {
    static let goldenGem = Fruit(name: "Golden Delicious Apple", detail: "🍏", color: .cyan)
    static let flavorKing = Fruit(name: "Flavor King Plum", detail: "🍑", color: .purple)
    static let mariposa = Fruit(name: "Mariposa Plum", detail: "🍐", color: .indigo)
    static let tompkinsKing = Fruit(name: "Tompkins King Apple", detail: "🍎", color: .pink)
    static let greenGage = Fruit(name: "Green Gage Plum", detail: "🍉", color: .green)
    static let lapins = Fruit(name: "Lapins Sweet Cherry", detail: "🍒", color: .purple)
    static let quercusTomentella = Fruit(name: "Channel Island Oak Acorn", detail: "🌰", color: .brown)
    static let elstar = Fruit(name: "Elstar Apple", detail: "🍌", color: .yellow)
    static let elephantHeart = Fruit(name: "Elephant Heart Plum", detail: "🍇", color: .red)
    static let kakiFuyu = Fruit(name: "Kaki Fuyu Persimmon", detail: "🍅", color: .orange)
    static let pinkPearlApple = Fruit(name: "Pink Pearl Apple", detail: "🍋", color: .mint)
    static let arbutusUnedo = Fruit(name: "Strawberry Tree", detail: "🍓", color: .green)

}

var allFruits: [Fruit] = [
    .goldenGem,
    .flavorKing,
    .mariposa,
    .tompkinsKing,
    .greenGage,
    .lapins,
    .elstar,
    .quercusTomentella,
    .elephantHeart,
    .kakiFuyu,
    .arbutusUnedo,
    .pinkPearlApple,
]
