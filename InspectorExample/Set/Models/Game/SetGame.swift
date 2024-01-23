//
//  SetGame.swift
//  SetGame
//
//  Created by Concepcion Orellana on 4/20/22.
//

import Foundation
import SwiftUI

struct SetGame {
    private(set) var cards: [Card]
    private(set) var cardsOnBoard: [Card]
    private(set) var cardsSelected: [Card]
    private(set) var cardsAlreadyMatched: [Card]
    private(set) var counterOfCardSelected: Int = .zero
    private(set) var restartSelection = false

    init(cards: [Card], cardsOnBoard: [Card]) {
        self.cards = cards
        self.cardsOnBoard = cardsOnBoard
        cardsSelected = []
        cardsAlreadyMatched = []
    }

    mutating func moreCards() {
        for _ in 0...2 {
            if let lastCard = cards.last {
                cardsOnBoard.append(lastCard)
                let cardSize = cardsOnBoard.count - 1
                cardsOnBoard[cardSize].isFaceUp = true
                cards.removeAll(where: { $0.id == lastCard.id })
            }
        }
    }

    mutating func choose(_ card: Card) {
        if restartSelection {
            restartSelectionAgain()
        }
        selectionOfCard(card)

        if counterOfCardSelected == 3 {
            let result = verifyCardSelected()
            if result.isCompleteSet {
                removeCardAlreadyMatched()
                cardsSelected.removeAll()
                counterOfCardSelected = .zero
            } else {
                for card in cardsSelected.enumerated() {
                    if let choosenIndex = cardsOnBoard.firstIndex(where: { $0.id == card.element.id }) {
                        cardsOnBoard[choosenIndex].foregroundColorCard = .errorRed
                        cardsOnBoard[choosenIndex].isNotSet = true
                    }
                }
                restartSelection.toggle()
            }
        }
    }

    mutating func restartSelectionAgain() {
        for cardToRemove in cardsSelected.enumerated() {
            if let choosenIndex = cardsOnBoard.firstIndex(where: { $0.content == cardToRemove.element.content }) {
                cardsOnBoard[choosenIndex].isSelected = false
                cardsOnBoard[choosenIndex].foregroundColorCard = .white
                cardsOnBoard[choosenIndex].isNotSet = false
            }
        }
        cardsSelected.removeAll()
        counterOfCardSelected = .zero
        restartSelection.toggle()
    }

    mutating func selectionOfCard(_ card: Card) {
        if let choosenIndex = cardsOnBoard.firstIndex(where: { $0.content == card.content }),
           counterOfCardSelected < 3 {
            if !cardsOnBoard[choosenIndex].isSelected {
                cardsOnBoard[choosenIndex].foregroundColorCard = .blue
                cardsSelected.append(cardsOnBoard[choosenIndex])
                counterOfCardSelected += 1
            } else if let cardSelectedIndex = cardsSelected.firstIndex(where: { $0.content == card.content }),
                      counterOfCardSelected != 3 {
                cardsOnBoard[choosenIndex].foregroundColorCard = .white
                cardsSelected.remove(at: cardSelectedIndex)
                counterOfCardSelected -= 1
            }
            cardsOnBoard[choosenIndex].isSelected.toggle()
        }
    }

    mutating func verifyCardSelected() -> Result {
        let rules = SetRules()
        if cardsSelected.count > 2 {
            return rules.verifySet(from: cardsSelected)
        }
        return Result()
    }

    mutating func removeCardAlreadyMatched() {
        for cardToRemove in cardsSelected.enumerated() {
            if let choosenIndex = cardsOnBoard.firstIndex(where: { $0.id == cardToRemove.element.id }) {
                cardsAlreadyMatched.append(cardToRemove.element)
                if !cardsAlreadyMatched.isEmpty {
                    cardsAlreadyMatched[cardsAlreadyMatched.count - 1].isSelected = false
                    cardsAlreadyMatched[cardsAlreadyMatched.count - 1].foregroundColorCard = .white
                }
                cardsOnBoard.removeAll(where: { $0.id == cardToRemove.element.id })
                if let lastCard = cards.last {
                    cardsOnBoard.insert(lastCard, at: choosenIndex)
                    cardsOnBoard[choosenIndex].isFaceUp = true
                    cards.removeAll(where: { $0.id == lastCard.id })
                }
            }
        }
    }
}
