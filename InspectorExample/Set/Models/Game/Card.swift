//
//  Card.swift
//  SetGame
//
//  Created by Concepcion Orellana on 4/25/22.
//

import Foundation

struct Card: Identifiable {
    var isFaceUp = false
    var isSelected = false
    var isNotSet = false
    var foregroundColorCard: ColorBackground = .white
    var content: SetCategory
    var id: Int
}
