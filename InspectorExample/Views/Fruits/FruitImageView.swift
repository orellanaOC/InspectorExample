//
//  FruitImageView.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 10/1/23.
//

import SwiftUI

struct FruitImageView: View {
var fruit: Fruit
var size: CGSize? = .init(width: 50, height: 50)
var scale: CGFloat = 1.0
var bordered = false

var body: some View {
    Text(fruit.detail) // Actual assets replaced with Color
//        .scaleEffect(scale)
        .scaledToFill()
        .frame(
            width: size?.width,
            height: size?.height
        )
        .background(Color(fruit.color).opacity(0.3))
        .mask { RoundedRectangle(cornerRadius: 4) }
        .overlay {
            if bordered {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        fruit.color,
                        lineWidth: 2
                    )
            }
        }
}
}
