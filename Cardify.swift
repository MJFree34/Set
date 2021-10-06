//
//  Cardify.swift
//  Set
//
//  Created by Matt Free on 10/6/21.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    @Environment(\.colorScheme) var colorScheme
    
    var rotation: Double
    var card: StandardSetGame.Card
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    init(card: StandardSetGame.Card) {
        rotation = card.isFaceUp ? 0 : 180
        self.card = card
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
            if rotation < 90 {
                shape
                    .fill()
                    .foregroundColor(colorScheme == .light ? .white : .black)
                
                shape
                    .strokeBorder(cardBorderColor, lineWidth: DrawingConstants.lineWidth)
            } else {
                shape
                    .fill()
                    .foregroundColor(colorScheme == .light ? .black : .white)
            }
            
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
    }
    
    private var cardBorderColor: Color {
        if card.willBeInSet == true {
            return .green
        } else if card.willBeInSet == false {
            return .red
        } else if card.isSelected {
            return .orange
        } else if card.isInMatch {
            return .yellow
        } else {
            return colorScheme == .light ? .black : .white
        }
    }
    
    enum DrawingConstants {
        static let lineWidth = 4.0
        static let cornerRadius = 10.0
    }
}

extension View {
    func cardify(card: StandardSetGame.Card) -> some View {
        self.modifier(Cardify(card: card))
    }
}
