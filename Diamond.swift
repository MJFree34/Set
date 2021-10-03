//
//  Diamond.swift
//  Diamond
//
//  Created by Matt Free on 8/22/21.
//

import SwiftUI

struct Diamond: InsettableShape {
    private var insetAmount = 0.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + insetAmount))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - insetAmount))
        path.addLine(to: CGPoint(x: rect.minX + insetAmount, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + insetAmount))
        
        return path
    }
    
    func inset(by amount: CGFloat) -> Diamond {
        var diamond = self
        diamond.insetAmount += amount
        return diamond
    }
}
