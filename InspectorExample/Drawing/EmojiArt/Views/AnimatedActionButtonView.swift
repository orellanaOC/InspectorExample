//
//  AnimatedActionButton.swift
//  EmojiArt
//
//  Created by Concepcion Orellana on 5/3/22.
//

import SwiftUI

// syntactic sugar
// lots of times we want a simple button
// with just text or a label or a systemImage
// but we want the action it performs to be animated
// (i.e. withAnimation)
// this just makes it easy to create such a button
// and thus cleans up our code

struct AnimatedActionButton: View {
    let action: () -> Void
    var title: String? = nil
    var systemImage: String? = nil

    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            if title != nil,
                systemImage != nil {
                Label(title!, systemImage: systemImage!)

            } else if title != nil {
                Text(title!)

            } else if systemImage != nil {
                Image(systemName: systemImage!)
            }
        }
    }
}
