//
//  AspectVGrid.swift
//  AspectVGrid
//
//  Created by Matt Free on 8/17/21.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: Double
    var content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: Double, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                let width = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) { item in
                        content(item)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private func adaptiveGridItem(width: Double) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: Double) -> Double {
        var columnCount = 1
        var rowCount = itemCount
        
        repeat {
            let itemWidth = size.width / Double(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if Double(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        
        if columnCount > itemCount {
            columnCount = itemCount
        }
        
        return floor(size.width / CGFloat(columnCount))
    }
}

struct AspectVGrid_Previews: PreviewProvider {
    static var previews: some View {
        let game = StandardSetGame()
        AspectVGrid(items: game.dealtCards, aspectRatio: 2/3) { card in 
            CardView(card: card)
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}
