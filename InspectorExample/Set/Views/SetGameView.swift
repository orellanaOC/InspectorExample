//
//  SetGameView.swift
//  SetGame
//
//  Created by Concepcion Orellana on 4/20/22.
//

import SwiftUI

struct SetGameView: View {
    @State private var dealt = Set<Int>()
    @State private var showCard = false

    @Namespace private var dealingNamespace

    @ObservedObject var viewModel: SetGameViewModel

    var showInspector: Binding<Bool>

    var body: some View {
        VStack {
            if showCard {
                cardsBody
            }

            if viewModel.cardsOnBoard.isEmpty,
               viewModel.allCards.isEmpty {
                Text("Finished!🥳")
                    .font(.largeTitle)
                    .padding()
            }

            Spacer()
        }
        .padding(5)
        .foregroundColor(.blue)
        .inspector(isPresented: showInspector) {
            footer
                .padding(.top)
                .presentationDetents([.height(200), .medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(200)))
        }
//    MARK: - Inside navigation structure - Toolbar content outside inspector
        .toolbar {
            Button {
                showInspector.wrappedValue.toggle()
            } label: {
                Label("Toggle Inspector", systemImage: "info.circle")
            }
        }
    }

    var cardsBody: some View {
        AspectVGrid(
            items: viewModel.cardsOnBoard,
            aspectRatio: Constants.aspectRatio,
            content: { card in
                CardView(
                    onSelected: viewModel.chooseCard(_:),
                    card: card
                )
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .zIndex(zIndex(of: card))
                .transition(
                    AnyTransition
                        .asymmetric(
                            insertion: .scale,
                            removal: .scale
                        )
                )
            }
        )
    }

    var footer: some View {
        VStack(spacing: 8) {
            HStack(spacing: 16) {
                Text("Set Game!")
                    .font(.title)

                if showCard {
                    Button("New Game!") {
                        withAnimation {
                            dealt = []
                            viewModel.newGame()
                            showCard = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()

            HStack(spacing: 16) {
                ZStack(alignment: .bottomTrailing) {
                    deckBody
                        .padding(.trailing)
                }

                deckAlreadyMatched
            }

            Spacer()
        }
    }

    var deckAlreadyMatched: some View {
        ZStack {
            ForEach(viewModel.cardsAlreadyMatched.filter(isUndealt)) { card in
                CardView(
                    onSelected: viewModel.chooseCard(_:),
                    card: card
                )
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .zIndex(zIndex(of: card))
                .transition(
                    AnyTransition
                        .asymmetric(
                            insertion: .scale,
                            removal: .scale
                        )
                )
            }
        }
        .frame(width: Constants.undealWidth, height: Constants.undealHeight)
        .foregroundColor(.blue)
    }

    var deckBody: some View {
        ZStack {
            ForEach(viewModel.allCards.filter(isUndealt)) { card in
                CardView(
                    onSelected: viewModel.chooseCard(_:),
                    card: card
                )
                .padding(.init(top: 0, leading: 0, bottom: -10, trailing: -10))
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .zIndex(zIndex(of: card))
                .transition(
                    AnyTransition
                        .asymmetric(
                            insertion: .scale,
                            removal: .scale
                        )
                )
            }

            if !viewModel.allCards.isEmpty {
                ZStack {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .padding(.init(top: -5, leading: -5, bottom: 0, trailing: 0))
                        .onTapGesture {
                            withAnimation {
                                viewModel.moreCards()
                            }
                        }

                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .strokeBorder(lineWidth: 3)
                        .foregroundColor(.gray)
                        .padding(.init(top: -5, leading: -5, bottom: 0, trailing: 0))
                }
            }

            if !showCard {
                ZStack {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .padding(.init(top: -10, leading: -10, bottom: 5, trailing: 5))
                        .foregroundColor(.blue)
                        .onTapGesture {
                            withAnimation {
                                dealt = []
                                viewModel.newGame()
                                showCard = true
                            }
                        }

                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .strokeBorder(lineWidth: 3)
                        .foregroundColor(.gray)
                        .padding(.init(top: -10, leading: -10, bottom: 5, trailing: 5))
                }
            }
        }
        .frame(width: Constants.undealWidth, height: Constants.undealHeight)
        .foregroundColor(.blue)
    }

    private func isUndealt(_ card: Card) -> Bool {
        !dealt.contains(card.id)
    }

    private func zIndex(of card: Card) -> Double {
        -Double(viewModel.cardsOnBoard.firstIndex(where: { $0.id == card.id }) ?? .zero)
    }

    private struct Constants {
        static let cornerRadius: CGFloat = 5
        static let lineWidth: CGFloat = 1
        static let aspectRatio: CGFloat = 2 / 3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealHeight: CGFloat = 90
        static let undealWidth = undealHeight * aspectRatio
    }
}

struct GameSetView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(viewModel: SetGameViewModel(), showInspector: .constant(true))
    }
}
