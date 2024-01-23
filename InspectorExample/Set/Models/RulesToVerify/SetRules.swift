//
//  SetRules.swift
//  SetGame
//
//  Created by Concepcion Orellana on 4/25/22.
//

import Foundation

struct SetRules {
    func verifySet(from cards: [Card]) -> Result {
        var result = Result()

        if isSet(category: \.numberOfShapes, cards: cards) {
            result.isSetOfNumberOfShapes = true
        }

        if isSet(category: \.shape, cards: cards) {
            result.isSetOfShapes = true
        }

        if isSet(category: \.shading, cards: cards) {
            result.isSetOfShadings = true
        }

        if isSet(category: \.setColor, cards: cards) {
            result.isSetOfColors = true
        }

        return result
    }

    func isSet<Category: Equatable>(category keyPath: KeyPath<SetCategory, Category>, cards: [Card]) -> Bool {
        let cardZero = cards[0].content[keyPath: keyPath]
        let cardOne = cards[1].content[keyPath: keyPath]
        let cardTwo = cards[2].content[keyPath: keyPath]
        let allEquals = (cardZero == cardOne && cardOne == cardTwo && cardZero == cardTwo)
        let allDifferents = (cardZero != cardOne && cardOne != cardTwo && cardZero != cardTwo)

        return allEquals || allDifferents
    }
}
