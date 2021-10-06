//
//  SetGame.swift
//  SetGame
//
//  Created by Matt Free on 8/21/21.
//

import SwiftUI

struct SetGame<ShapeColor, ShapeType, Shading> where ShapeColor: Equatable, ShapeType: Equatable, Shading: Equatable {
    var allCardsDealt = false
    var score = 0
    
    var dealtCards: [Card] {
        Array(cards.filter({ !$0.isMatched })[0..<numberOfDealtCards])
    }
    
    private(set) var cards: [Card]
    
    private var numberOfDealtCards = 12 {
        didSet {
            setIsFaceUp()
        }
    }
    private var lastSetTappedTime: Date?
    private var isCheating = false {
        didSet {
            if isMatchAvailable && isCheating {
                matchAvailableIndexes.forEach { cards[$0].isInMatch = true }
            } else {
                cards.indices.forEach { cards[$0].isInMatch = false }
            }
        }
    }
    
    private var isMatchAvailable: Bool {
        return matchAvailableIndexes.count == 3
    }
    
    private var matchAvailableIndexes: [Int] {
        for i in 0..<dealtCards.count {
            for j in i + 1..<dealtCards.count {
                for k in j + 1..<dealtCards.count {
                    if checkAllFeatures(card1: dealtCards[i], card2: dealtCards[j], card3: dealtCards[k]) {
                        return [
                            cards.firstIndex(where: { dealtCards[i].id == $0.id })!,
                            cards.firstIndex(where: { dealtCards[j].id == $0.id })!,
                            cards.firstIndex(where: { dealtCards[k].id == $0.id })!
                        ]
                    }
                }
            }
        }
        
        return []
    }
    
    private var selectedIndexes: [Int] {
        get {
            cards.indices.filter { cards[$0].isSelected }
        }
        
        set {
            cards.indices.forEach { cards[$0].isSelected = newValue.contains($0) }
        }
    }
    
    init(shapeColors: [ShapeColor], shapeTypes: [ShapeType], shadings: [Shading]) {
        assert(shapeColors.count == 3 && shapeTypes.count == 3 && shadings.count == 3)
        
        cards = []
        
        newGame(shapeColors: shapeColors, shapeTypes: shapeTypes, shadings: shadings)
    }
    
    mutating func newGame(shapeColors: [ShapeColor], shapeTypes: [ShapeType], shadings: [Shading]) {
        cards.removeAll()
        
        for shapeColor in shapeColors {
            for shapeType in shapeTypes {
                for shading in shadings {
                    for numberOfShapes in 1...3 {
                        let card = Card(numberOfShapes: numberOfShapes, shapeColor: shapeColor, shapeType: shapeType, shading: shading)
                        cards.append(card)
                    }
                }
            }
        }
        
        cards.shuffle()
        
        numberOfDealtCards = 12
        selectedIndexes = []
        allCardsDealt = false
        score = 0
        lastSetTappedTime = Date()
        isCheating = false
    }
    
    mutating func choose(_ card: Card) {
        isCheating = false
        
        if selectedIndexes.count == 3 {
            if checkAllFeaturesOfSelectedCards() {
                selectedIndexes.forEach { cards[$0].isMatched = true }
                
                numberOfDealtCards -= 3
                
                if let selectedIndex = cards.firstIndex(where: { card.id == $0.id }), selectedIndexes.contains(selectedIndex) {
                    selectedIndexes.removeAll()
                    setWillBeInSet(setTime: true)
                    return
                }
            }
            
            selectedIndexes.forEach { cards[$0].willBeInSet = nil }
            selectedIndexes.removeAll()
        }
        
        if let selectedIndex = cards.firstIndex(where: { card.id == $0.id }) {
            if let containingIndex: Int = selectedIndexes.firstIndex(of: selectedIndex) {
                selectedIndexes.remove(at: containingIndex)
            } else {
                selectedIndexes.append(selectedIndex)
            }
        }
        
        setWillBeInSet(setTime: true)
    }
    
    mutating func dealCards() {
        isCheating = false
        
        let dealableCardsCount = cards.filter({ !$0.isMatched }).count
        
        if checkAllFeaturesOfSelectedCards() {
            selectedIndexes.forEach { cards[$0].isMatched = true }
            
            numberOfDealtCards -= 3
            
            selectedIndexes.forEach { cards[$0].willBeInSet = nil }
            selectedIndexes.removeAll()
        } else if dealableCardsCount <= numberOfDealtCards + 3 {
            numberOfDealtCards = dealableCardsCount
            allCardsDealt = true
        } else {
            if isMatchAvailable {
                setScore(match: false)
            }
            numberOfDealtCards += 3
        }
    }
    
    mutating func cheat() {
        isCheating.toggle()
    }
    
    private func allSame<T: Equatable>(card1Feature: T, card2Feature: T, card3Feature: T) -> Bool {
        card1Feature == card2Feature && card2Feature == card3Feature
    }
    
    private func allDifferent<T: Equatable>(card1Feature: T, card2Feature: T, card3Feature: T) -> Bool {
        card1Feature != card2Feature && card2Feature != card3Feature && card3Feature != card1Feature
    }
    
    private func checkOneFeature<T: Equatable>(card1Feature: T, card2Feature: T, card3Feature: T) -> Bool {
        allSame(card1Feature: card1Feature, card2Feature: card2Feature, card3Feature: card3Feature) ||
        allDifferent(card1Feature: card1Feature, card2Feature: card2Feature, card3Feature: card3Feature)
    }
    
    private func checkAllFeatures(card1: Card, card2: Card, card3: Card) -> Bool {
        checkOneFeature(card1Feature: card1.numberOfShapes, card2Feature: card2.numberOfShapes, card3Feature: card3.numberOfShapes) &&
        checkOneFeature(card1Feature: card1.shapeColor, card2Feature: card2.shapeColor, card3Feature: card3.shapeColor) &&
        checkOneFeature(card1Feature: card1.shapeType, card2Feature: card2.shapeType, card3Feature: card3.shapeType) &&
        checkOneFeature(card1Feature: card1.shading, card2Feature: card2.shading, card3Feature: card3.shading)
    }
    
    private func checkAllFeaturesOfSelectedCards() -> Bool {
        guard selectedIndexes.count == 3 else { return false }
        return checkAllFeatures(card1: cards[selectedIndexes[0]], card2: cards[selectedIndexes[1]], card3: cards[selectedIndexes[2]])
    }
    
    private mutating func setWillBeInSet(setTime: Bool = false) {
        if selectedIndexes.count == 3 {
            let willBeInSet = checkAllFeaturesOfSelectedCards()
            selectedIndexes.forEach { cards[$0].willBeInSet = willBeInSet }
            setScore(match: willBeInSet)
        }
    }
    
    private mutating func setScore(match: Bool) {
        if let tappedTime = lastSetTappedTime, match {
            let difference = Int(abs(tappedTime.timeIntervalSinceNow))
            let max = max(20 - difference, 1)
            score += max
            lastSetTappedTime = Date()
        } else {
            score -= 1
        }
    }
    
    private mutating func setIsFaceUp() {
        cards.filter({ !$0.isMatched })[0..<numberOfDealtCards].forEach { dealtCard in cards[cards.firstIndex(where: { $0.id == dealtCard.id })!].isFaceUp = true }
    }
    
    struct Card: Identifiable {
        let id = UUID()
        var isMatched = false
        var isSelected = false
        var isInMatch = false
        var isFaceUp = false
        var willBeInSet: Bool? = nil
        let numberOfShapes: Int
        let shapeColor: ShapeColor
        let shapeType: ShapeType
        let shading: Shading
    }
}
