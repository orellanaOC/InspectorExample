//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }

    var emojis: [EmojiArtModel.Emoji] {
        emojiArt.emojis
    }
    var emojisToMove: [EmojiArtModel.Emoji] {
        emojiArt.emojisSelected
    }
    // Required task 6: move the entire selection of emojis selected
    var emojisSelected: [String] {
        emojiArt.emojis.filter { $0.isSelected }.compactMap { $0.text }
    }
    var background: EmojiArtModel.Background {
        emojiArt.background
    }
    var emojiToMove: EmojiArtModel.Emoji? {
        emojiArt.emojiToMove ?? nil
    }

    init() {
        emojiArt = EmojiArtModel()
    }

    // MARK: - Intent(s)

    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(
            emoji,
            at: location,
            size: Int(size)
        )
    }

    // Required Task 2: You can select an emojis.
    func selectEmoji(in position: Int) {
        emojiArt.selectEmoji(in: position)
    }

    // Required task 6: save the emoji selected to move
    func saveEmoji(_ emoji: EmojiArtModel.Emoji? = nil) {
        emojiArt.saveEmoji(emoji)
    }

    func saveindexOfEmoji(_ index: Int? = nil) {
        emojiArt.saveindexOfEmoji(index)
    }

    // Required Task 4: You can unselect an emojis.
    // Required Task 5: Unselect all emojis selected previously.
    func deselectEmojis() {
        emojiArt.deselectEmojis()
    }

    // Required task 6: remove the emoji selected to change its position
    func removeEmoji(in position: Int? = nil) {
        position != nil ? emojiArt.removeEmoji(in: position) : emojiArt.removeEmoji()
    }

    // Required Task 10: You can delete an emoji.
    func delete(_ emoji: EmojiArtModel.Emoji) {
        emojiArt.delete(emoji)
    }

    // Required task 6: move the entire selection of emojis selected
    func moveEmojisSelected(_ coordinates: (x: Int, y: Int), _ defaultEmojiFontSize: CGFloat, _ zoomScale: CGFloat) {
        var emoji = emojisSelected.isEmpty ? nil : emojisToMove[emojisSelected.count - 1]
        if let index = emojiArt.indexToMove {
            emoji = emojiArt.emojisSelected[index]
        }
        let displacementInX = coordinates.x - (emoji?.x ?? 0)
        let displacementInY = coordinates.y - (emoji?.y ?? 0)
        for emojiSelected in emojisToMove {
            if let index = emojis.firstIndex(where: { $0 == emojiSelected }) {
                addEmoji(
                    String(emojiSelected.text),
                    at: (emojis[index].x + displacementInX,
                         emojis[index].y + displacementInY),
                    size: defaultEmojiFontSize / zoomScale
                )
            }
        }
        removeEmoji()
    }

    func setBackground(_ background: EmojiArtModel.Background) {
        emojiArt.background = background
    }

    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }

    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            let size = Int(
                (CGFloat(emojiArt.emojis[index].size) * scale)
                    .rounded(
                    .toNearestOrAwayFromZero
                )
            )
            emojiArt.changeSize(of: emoji, to: size)
        }
    }

    // MARK: - Background

    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .url(let url):
            // fetch the url
            backgroundImageFetchStatus = .fetching
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = try? Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
                        self?.backgroundImageFetchStatus = .idle
                        if imageData != nil {
                            self?.backgroundImage = UIImage(data: imageData!)
                        }
                    }
                }
            }
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }

    enum BackgroundImageFetchStatus {
        case idle
        case fetching
    }
}
