//
//  GameFactory.swift
//  SetGame
//
//  Created by Concepcion Orellana on 4/20/22.
//

import Foundation
import SwiftUI

struct GameFactory {
    static func newGame() -> SetGame {

        var cards: [Card] = []
        var cardsOnBoard: [Card] = []
        var id: Int = .zero

        NumberOfShapes.allCases.forEach { numberOfShapes in
            SetShape.allCases.forEach { shape in
                SetColor.allCases.forEach { setColor in
                    Shading.allCases.forEach { shading in
                        cards.append(Card(
                            content: SetCategory(
                                setColor: setColor,
                                numberOfShapes: numberOfShapes,
                                shading: shading,
                                shape: shape
                            ),
                            id: id
                        ))
                        id += 1
                    }
                }
            }
        }
        cards.shuffle()

        for index in 0..<12 {
            if let lastCard = cards.last {
                cardsOnBoard.append(lastCard)
                cardsOnBoard[index].isFaceUp = true
                cards = cards.dropLast()
            }
        }

        return SetGame(cards: cards, cardsOnBoard: cardsOnBoard)
    }
}
