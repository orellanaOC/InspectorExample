//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Concepcion Orellana on 4/20/22.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published var game: SetGame

    var allCards: [Card] {
        game.cards
    }
    var cardsAlreadyMatched: [Card] {
        game.cardsAlreadyMatched
    }
    var cardsOnBoard: [Card] {
        game.cardsOnBoard
    }

    init() {
        game = GameFactory.newGame()
    }

    // MARK: - New Game

    func newGame() {
        game = GameFactory.newGame()
    }

    // MARK: - Deal 3 More Cards

    func moreCards() {
        game.moreCards()
    }

    // MARK: - Intent(s)

    func chooseCard(_ card: Card) {
        game.choose(card)
    }
}
