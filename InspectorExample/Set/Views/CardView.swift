//
//  CardView.swift
//  SetGame
//
//  Created by Concepcion Orellana on 4/20/22.
//

import SwiftUI

struct CardView: View {
    @State private var dealt = Set<Int>()

    let onSelected: (Card) -> Void
    let lineWidth = Constants.lineWidth
    var card: Card

    var body: some View {
        GeometryReader { _ in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)

                shape
                    .fill()
                    .foregroundColor(Color(card.foregroundColorCard.rawValue))

                shape
                    .strokeBorder(lineWidth: lineWidth)

                shapesOnCards(for: card)
            }
            .scaleEffect(card.isNotSet ? 0.8 : 1.0)
            .cardify(isFaceUp: card.isFaceUp, isNotSet: card.isNotSet)
            .transition(
                AnyTransition
                    .asymmetric(
                        insertion: .scale,
                        removal: .scale
                    )
            )
            .padding(4)
            .onTapGesture {
                withAnimation {
                    deal(card)
                    onSelected(card)
                }
            }
        }
        .foregroundColor(card.isNotSet ? Color("red") : .blue)
    }

    @ViewBuilder
    private func shapesOnCards(for card: Card) -> some View {
        let shapeColor = Color(card.content.setColor.rawValue)
        VStack(alignment: .center, spacing: 0) {
            Group {
                switch card.content.numberOfShapes {
                case .one:
                    ForEach(0..<1) { _ in
                        shapeByShape(for: card, with: shapeColor)
                    }
                case .two:
                    ForEach(0..<2) { _ in
                        shapeByShape(for: card, with: shapeColor)
                    }
                case .three:
                    ForEach(0..<3) { _ in
                        shapeByShape(for: card, with: shapeColor)
                    }
                }
            }
        }
        .padding(3)
    }

    @ViewBuilder
    private func shapeByShape(for card: Card, with shapeColor: Color) -> some View {
        Group {
            switch card.content.shape {
            case .diamond:
                diamond(for: card, with: shapeColor)
            case .squiggle:
                squiggle(for: card, with: shapeColor)
            case .oval:
                oval(for: card, with: shapeColor)
            }
        }
        .padding(2)
        .foregroundColor(shapeColor)
    }

    @ViewBuilder
    private func diamond(for card: Card, with shapeColor: Color) -> some View {
        Group {
            switch card.content.shading {
            case .open:
                Diamond()
                    .stroke(lineWidth: lineWidth)
            case .striped:
                ZStack {
                    Diamond()
                        .foregroundColor(shapeColor)
                        .opacity(shadingShape(for: card))

                    Diamond()
                        .stroke(lineWidth: lineWidth)
                }
            case .solid:
                Diamond()
            }
        }
        .aspectRatio(1/1, contentMode: .fit)
    }

    @ViewBuilder
    private func squiggle(for card: Card, with shapeColor: Color) -> some View {
        Group {
            switch card.content.shading {
            case .open:
                Rectangle()
                    .stroke(lineWidth: lineWidth)
            case .striped:
                ZStack {
                    Rectangle()
                        .foregroundColor(shapeColor)
                        .opacity(shadingShape(for: card))

                    Rectangle()
                        .stroke(lineWidth: lineWidth)
                }
            case .solid:
                Rectangle()
            }
        }
        .aspectRatio(3/1, contentMode: .fit)
    }

    @ViewBuilder
    private func oval(for card: Card, with shapeColor: Color) -> some View {
        Group {
            switch card.content.shading {
            case .open:
                Capsule()
                    .stroke(lineWidth: lineWidth)
            case .striped:
                ZStack {
                    Capsule()
                        .foregroundColor(shapeColor)
                        .opacity(shadingShape(for: card))

                    Capsule()
                        .stroke(lineWidth: lineWidth)
                }
            case .solid:
                Capsule()
            }
        }
        .aspectRatio(3/1, contentMode: .fit)
    }

    private func shadingShape(for card: Card) -> Double {
        card.content.shading == .striped ? 0.3 : 1
    }

    private func deal(_ card: Card) {
        dealt.insert(card.id)
    }

    private struct Constants {
        static let cornerRadius: CGFloat = 5
        static let lineWidth: CGFloat = 1
        static let aspectRatio: CGFloat = 2 / 3
    }
}
