//
//  SwiftUIView.swift
//  EmojiArt
//
//  Created by Concepcion Orellana on 5/3/22.
//

import SwiftUI

// MARK: - Palette

struct ScrollingEmojisView: View {
    let emojis: String
    let columns = [
        GridItem(.adaptive(minimum: 40))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(emojis.map { String($0) }, id: \.self) { item in
                    Text(item)
                        .onDrag {
                            NSItemProvider(object: item as NSString)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}
