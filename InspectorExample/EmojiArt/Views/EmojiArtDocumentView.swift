//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @State private var steadyStateZoomScale: CGFloat = 1
    @State private var steadyStatePanOffset: CGSize = .zero
    @State private var moveEmojisSelected = false
    @GestureState private var gesturePanOffset: CGSize = .zero
    @GestureState private var gestureZoomScale: CGFloat = 1
    @ObservedObject var document: EmojiArtDocument

    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }

    let defaultEmojiFontSize: CGFloat = 40

    var body: some View {
        VStack(spacing: .zero) {
            documentBody
        }
    }

    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color
                    .white
                    .overlay(
                        OptionalImage(uiImage: document.backgroundImage)
                            .scaleEffect(zoomScale)
                            .position(
                                convertFromEmojiCoordinates(
                                    (.zero, .zero),
                                    in: geometry
                                )
                            )
                    )
                    .gesture(doubleTapToZoom(in: geometry.size))

                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView()
                        .scaleEffect(2)
                } else {
                    ForEach(document.emojis) { emoji in
                        Text(emoji.text)
                            .background(emoji.isSelected ? Color.red : Color.clear) // Required Task 2: You can show which emojis are selected in any way you’d like.
                            .contentShape(Rectangle())
                            .font(
                                .system(
                                    size: fontSize(for: emoji)
                                )
                            )
                            .scaleEffect(zoomScale)
                            .position(
                                position(
                                    for: emoji,
                                    in: geometry
                                )
                            )
                            .gesture(
                                panGesture()
                                    .simultaneously(
                                        with: zoomGesture()
                                    )
                            )
                            .gesture(doubleTapToDelete(emoji)) // Required Task 10: You can delete an emoji.
                            .onTapGesture { // Required Task 2 & Required Task 3: You can select an emojis.
                                withAnimation {
                                    if let index = document.emojis.firstIndex(where: { $0 == emoji }) {
                                        document.selectEmoji(in: index)
                                    }
                                }
                            }
                            .onDrag {
                                withAnimation {
                                    moveEmojisSelected = true
                                    if !document.emojisSelected.isEmpty { // Required task 6: move the entire selection of emojis selected
                                        if document.emojisToMove.firstIndex(where: { $0.text == emoji.text }) == nil {
                                            let itemProvider = NSItemProvider(object: String(emoji.text) as NSString)
                                            document.saveEmoji(emoji)
                                            if let position = document.emojis.firstIndex(where: { $0 == emoji }) {
                                                document.removeEmoji(in: position)
                                            }

                                            return itemProvider
                                        }
                                        // save the index to move the emojis with the distance respect the last emoji selected
                                        if let index = document.emojisToMove.firstIndex(where: { $0.text == emoji.text }) {
                                            document.saveindexOfEmoji(index)
                                        }

                                        for emojiSelected in document.emojisSelected {

                                            return NSItemProvider(object: String(emojiSelected) as NSString)
                                        }
                                    } else { // Extra credit 1: move an emoji without selection previously
                                        if document.emojisToMove.firstIndex(where: { $0.text == emoji.text }) == nil {
                                            let itemProvider = NSItemProvider(object: String(emoji.text) as NSString)
                                            document.saveEmoji(emoji)
                                            if let position = document.emojis.firstIndex(where: { $0 == emoji }) {
                                                document.removeEmoji(in: position)
                                            }

                                            return itemProvider
                                        }
                                    }

                                    return NSItemProvider(object: String(" ") as NSString)
                                }
                            }
                    }
                }
            }
            .clipped()
            .onDrop(
                of: [.plainText, .url, .image],
                isTargeted: nil
            ) { providers, location in
                drop(
                    providers: providers,
                    at: location,
                    in: geometry
                )
            }
            .gesture(
                panGesture() // Required task 7: pan the entire document
                    .simultaneously(
                        with: zoomGesture()
                    )
            )
            .onTapGesture { // Required Task 4: You can unselect an emojis. // Required Task 5: You can unselect all emojis selected previously.
                withAnimation {
                    document.deselectEmojis()
                }
            }
        }
    }

    // MARK: - Drag and Drop

    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            document.setBackground(.url(url.imageURL))
        }

        if !found {
            found = providers.loadObjects(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackground(.imageData(data))
                }
            }
        }

        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {

                    if document.emojisSelected.isEmpty {
                        add(emoji, location: location, in: geometry)
                        document.removeEmoji()
                        document.saveEmoji(nil)
                    } else if moveEmojisSelected {
                        dropEmojisSelected(location: location, in: geometry)
                    } else if document.emojiToMove != nil { // Extra credit 1: move an emoji without selection previously
                        add(document.emojiToMove?.text.first ?? "🥲", location: location, in: geometry)
                        document.saveEmoji(nil)
                    } else {
                        add(emoji, location: location, in: geometry)
                    }
                }
            }
        }

        return found
    }
    
    private func dropEmojisSelected(location: CGPoint, in geometry: GeometryProxy) {
        if document.emojiToMove != nil { // Extra credit 1: move an emoji without selection previously
            add(document.emojiToMove?.text.first ?? "🥲", location: location, in: geometry)
            document.saveEmoji(nil)
        } else { // Required task 6: move the entire selection of emojis selected
            let emojiCoordinates = convertToEmojiCoordinates(location, in: geometry)
            document.moveEmojisSelected(emojiCoordinates, defaultEmojiFontSize, zoomScale)
            document.saveEmoji(nil)
        }
        moveEmojisSelected = false
    }

    private func add(_ emoji: Character, location: CGPoint, in geometry: GeometryProxy) {
        document.addEmoji(
            String(emoji),
            at: convertToEmojiCoordinates(location, in: geometry),
            size: defaultEmojiFontSize / zoomScale
        )
    }

    // MARK: - Delete emoji

    // Required Task 10: You can delete an emoji.
    private func doubleTapToDelete(_ emoji: EmojiArtModel.Emoji) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    document.delete(emoji)
                }
            }
    }

    // MARK: - Positioning/Sizing Emoji

    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }

    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }

    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (location.x - panOffset.width - center.x) / zoomScale,
            y: (location.y - panOffset.height - center.y) / zoomScale
        )

        return (Int(location.x), Int(location.y))
    }

    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center

        return CGPoint(
            x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
            y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
        )
    }

    // MARK: - Zooming

    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                if document.emojisSelected.isEmpty {
                    gestureZoomScale = latestGestureScale
                }
            }
            .onEnded { gestureScaleAtEnd in
                if document.emojisSelected.isEmpty { // Required task 9: entire document will be scaled
                    steadyStateZoomScale *= gestureScaleAtEnd
                } else { // Required task 8: only all the emojis in the selection will be scaled
                    document.emojisToMove.forEach { emoji in
                        document.scaleEmoji(emoji, by: gestureScaleAtEnd)
                    }
                }
            }
    }

    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(
                        document.backgroundImage,
                        in: size
                    )
                }
            }
    }

    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > .zero, image.size.height > .zero,
           size.width > .zero, size.height > .zero  {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }

    // MARK: - Panning

    // Required task 7: pan the entire document
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset +
                (finalDragGestureValue.translation / zoomScale)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
