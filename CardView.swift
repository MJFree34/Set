//
//  CardView.swift
//  CardView
//
//  Created by Matt Free on 8/21/21.
//

import SwiftUI

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let card: StandardSetGame.Card
    
    var body: some View {
        let cardBack = RoundedRectangle(cornerRadius: 10)
        
        ZStack {
            if card.isMatched {
                cardBack
                    .opacity(0)
            } else if card.isFaceUp {
                cardBack
                    .strokeBorder(cardBorderColor, lineWidth: 3)
                
                shapes
            } else {
                cardBack.strokeBorder(lineWidth: 4)
            }
        }
    }
    
    @ViewBuilder
    private func shape(noBorder: Bool = false) -> some View {
        switch card.shapeType {
        case .diamond:
            if card.shading != .solid && !noBorder {
                Diamond()
                    .strokeBorder(lineWidth: 1)
            } else {
                Diamond()
            }
        case .oval:
            if card.shading != .solid && !noBorder {
                Capsule()
                    .strokeBorder(lineWidth: 1)
            } else {
                Capsule()
            }
        case .rectangle:
            if card.shading != .solid && !noBorder {
                Squiggle()
                    .strokeBorder(lineWidth: 1)
            } else {
                Squiggle()
            }
        }
    }
    
    private var shapes: some View {
        VStack {
            ForEach(0..<card.numberOfShapes, id: \.self) { _ in
                if card.shading == .transparent {
                    ZStack {
                        Stripes()
                            .stroke(lineWidth: 0.5)
                            .mask(shape(noBorder: true))
                        
                        shape()
                    }
                    .aspectRatio(2/1, contentMode: .fit)
                } else {
                    shape()
                        .aspectRatio(2/1, contentMode: .fit)
                }
            }
        }
        .foregroundColor(card.shapeColor.color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
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
            return colorScheme == .dark ? .white : .black
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: .init(numberOfShapes: 3, shapeColor: .blue, shapeType: .diamond, shading: .solid))
    }
}
