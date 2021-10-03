//
//  Stripes.swift
//  Stripes
//
//  Created by Matt Free on 8/23/21.
//

import SwiftUI

struct Stripes: Shape {
    let stripeWidth = 1.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let count = Int(rect.maxX / stripeWidth)
        for index in 0..<count {
            let x = Double(index) * (stripeWidth * 2)
            let start = CGPoint(x: x, y: 0)
            let end = CGPoint(x: CGFloat(x), y: rect.maxY)
            
            path.move(to: start)
            path.addLine(to: end)
        }
        
        return path
    }
}
