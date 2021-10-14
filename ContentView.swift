//
//  ContentView.swift
//  Set
//
//  Created by Matt Free on 8/21/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: StandardSetGame
    
    @Namespace private var dealingNamespace
    
    @State private var dealt = Set<UUID>()
    @State private var matched = Set<UUID>()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack {
                    Text("SCORE: \(game.score)")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    gameBody.padding(.bottom, Constants.undealtHeight + 10)
                    
                    HStack {
                        Button("New Game") {
                            withAnimation {
                                dealt = []
                                game.newGame()
                            }
                        }
                        .frame(width: geometry.size.width / 3)
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color(uiColor: .systemGray5)))
                        
                        Spacer()
                        
                        Button("Cheat") {
                            withAnimation {
                                game.cheat()
                            }
                        }
                        .frame(width: geometry.size.width / 3)
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color(uiColor: .systemGray5)))
                    }
                    .foregroundColor(.purple)
                    .font(.title3)
                    .padding(.horizontal, 2)
                }
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: Constants.undealtWidth, height: Constants.undealtHeight)
                            .foregroundColor(.gray)
                        deckBody
                    }
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: Constants.undealtWidth, height: Constants.undealtHeight)
                            .foregroundColor(.gray)
                        discardBody
                    }
                }
                .padding(.bottom, 50)
                .padding(.horizontal)
            }
            .padding()
        }
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.dealtCards, aspectRatio: 2/3) { card in
            if isUndealt(card) || card.isMatched {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(2)
                    .transition(.asymmetric(insertion: .identity, removal: .scale).animation(.easeInOut))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                            game.matchedCards.forEach { match($0) }
                        }
                    }
            }
        }
        .foregroundColor(Constants.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .opacity, removal: .identity).animation(.easeInOut))
            }
        }
        .frame(width: Constants.undealtWidth, height: Constants.undealtHeight)
        .foregroundColor(Constants.color)
        .onTapGesture {
            if dealt.isEmpty {
                for card in game.dealtCards {
                    withAnimation(dealAnimation(for: card)) {
                        deal(card)
                    }
                }
            } else if !game.allCardsDealt {
                withAnimation {
                    game.dealCards()
                    game.matchedCards.forEach { match($0) }
                }
                
                for card in game.dealtCards {
                    if !dealt.contains(card.id) {
                        withAnimation(dealAnimation(for: card)) {
                            deal(card)
                        }
                    }
                }
            }
        }
    }
    
    var discardBody: some View {
        ZStack {
            ForEach(game.cards.filter(isMatched)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .opacity, removal: .identity).animation(.easeInOut))
            }
        }
        .frame(width: Constants.undealtWidth, height: Constants.undealtHeight)
        .foregroundColor(Constants.color)
    }
    
    private func deal(_ card: StandardSetGame.Card) {
        dealt.insert(card.id)
    }
    
    private func match(_ card: StandardSetGame.Card) {
        matched.insert(card.id)
        dealt.remove(card.id)
    }
    
    private func isUndealt(_ card: StandardSetGame.Card) -> Bool {
        !dealt.contains(card.id) && !matched.contains(card.id)
    }
    
    private func isMatched(_ card: StandardSetGame.Card) -> Bool {
        matched.contains(card.id)
    }
    
    private func zIndex(of card: StandardSetGame.Card) -> Double {
        -Double(game.dealtCards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    private func dealAnimation(for card: StandardSetGame.Card) -> Animation {
        var delay = 0.0
        
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index - game.startDealIndex) * Constants.totalDealDuration / Double(game.dealtCards.count)
        }
        
        return .easeInOut(duration: Constants.dealDuration).delay(delay)
    }
    
    private enum Constants {
        static let color: Color = .black
        static let aspectRatio = 2.0 / 3.0
        static let undealtHeight = 90.0
        static let undealtWidth = undealtHeight * aspectRatio
        static let dealDuration = 0.5
        static let totalDealDuration = 2.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: StandardSetGame())
    }
}
