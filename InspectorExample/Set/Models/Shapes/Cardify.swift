//
//  Cardify.swift
//  SetGame
//
//  Created by Concepcion Orellana on 4/28/22.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    let isNotSet: Bool
    var rotation: Double

    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    init(isFaceUp: Bool, isNotSet: Bool) {
        rotation = isFaceUp ? .zero : 180
        self.isNotSet = isNotSet
    }

    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius.rawValue)

            if rotation < 90 {
                shape
                    .fill()
                    .foregroundColor(isNotSet ? Color("red") : .blue)

                shape
                    .strokeBorder(lineWidth: DrawingConstants.lineWidth.rawValue)
            } else {
                ZStack {
                    shape
                        .fill(.blue)

                    shape
                        .strokeBorder(lineWidth: 3)
                        .foregroundColor(.gray)
                }
            }

            content
                .opacity(rotation < 90 ? 1 : .zero)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (.zero, 1, .zero))
    }

    private enum DrawingConstants: CGFloat {
        case cornerRadius = 5
        case lineWidth = 1
    }
}

extension View {
    func cardify(isFaceUp: Bool, isNotSet: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, isNotSet: isNotSet))
    }
}
