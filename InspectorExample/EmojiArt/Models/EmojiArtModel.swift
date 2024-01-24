//
//  EmojiArtModel.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import Foundation
import SwiftUI

struct EmojiArtModel {
    struct Emoji: Identifiable, Hashable {
        let id: Int
        let text: String
        var x: Int // offset from the center
        var y: Int // offset from the center
        var size: Int
        var isSelected = false
        
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.id = id
            self.text = text
            self.x = x
            self.y = y
            self.size = size
        }
    }

    private var uniqueEmojiId: Int = .zero
    var emojisSelected = [Emoji]()
    var emojiToMove: Emoji?
    var indexToMove: Int?
    var background = Background.blank
    var emojis = [Emoji]()

    init() { }

    mutating func saveindexOfEmoji(_ index: Int? = nil) {
        indexToMove = index
    }

    mutating func saveEmoji(_ emoji: Emoji? = nil) {
        emojiToMove = emoji
    }

    // Required Task 2: You can select an emojis.
    mutating func selectEmoji(in position: Int) {
        emojis[position].isSelected = true
        emojisSelected.append(emojis[position])
    }

    // Required Task 10: You can delete an emoji.
    mutating func delete(_ emoji: Emoji) {
        emojis.removeAll(where: { $0 == emoji })
        emojisSelected.removeAll(where: { $0 == emoji })
    }

    // Required Task 4: You can unselect an emoji selected previously
    // Required Task 5: You can unselect all emojis selected previously.
    mutating func deselectEmojis() {
        emojisSelected
            .compactMap { emojis.firstIndex(of: $0) }
            .forEach { emojis[$0].isSelected = false }
        emojisSelected.removeAll()
    }

    mutating func removeEmoji(in position: Int? = nil) {
        if !emojisSelected.isEmpty || emojiToMove != nil {
            if let position = position {
                emojis.remove(at: position)
            } else {
                emojisSelected.forEach { emoji in
                    emojis.removeAll(where: {$0 == emoji})
                }
                emojisSelected.removeAll()
            }
        }
    }

    mutating func changeSize(of emoji: Emoji, to size: Int) {
        if let index = emojis.index(matching: emoji) {
            emojis[index].size = size
        }
    }

    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(
            Emoji(
                text: text,
                x: location.x,
                y: location.y,
                size: size,
                id: uniqueEmojiId
            )
        )
    }
}
