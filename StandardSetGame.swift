//
//  StandardSetGame.swift
//  StandardSetGame
//
//  Created by Matt Free on 8/21/21.
//

import SwiftUI

class StandardSetGame: ObservableObject {
    typealias Card = SetGame<ShapeColor, ShapeType, Shading>.Card
    
    @Published private var model = SetGame<ShapeColor, ShapeType, Shading>(shapeColors: ShapeColor.allCases, shapeTypes: ShapeType.allCases, shadings: Shading.allCases)
    
    var allCardsDealt: Bool {
        model.allCardsDealt
    }
    
    var dealtCards: [Card] {
        model.dealtCards
    }
    
    var cards: [Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)

    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func dealCards() {
        model.dealCards()
    }
    
    func newGame() {
        model.newGame(shapeColors: ShapeColor.allCases, shapeTypes: ShapeType.allCases, shadings: Shading.allCases)
    }
    
    func cheat() {
        model.cheat()
    }
    
    // MARK: - Types
    
    enum ShapeColor: CaseIterable {
        case green
        case blue
        case red
        
        var color: Color {
            switch self {
            case .green:
                return .green
            case .blue:
                return .blue
            case .red:
                return .red
            }
        }
    }
    
    enum ShapeType: CaseIterable {
        case diamond
        case oval
        case rectangle
    }
    
    enum Shading: CaseIterable {
        case solid
        case transparent
        case open
    }
}
