//
//  Squiggle.swift
//  Squiggle
//
//  Created by Matt Free on 8/23/21.
//

import SwiftUI


//struct Squiggle: Shape {
//
//    func path(in rect: CGRect)-> Path{
//
//        let width  = rect.maxX - rect.minX
//        let height = rect.maxY - rect.minY
//
//        let bottomLeft      = CGPoint(x:  rect.minX + width*indentFactor,       y: rect.maxY-yIndentFactor*height)
//        let topLeft         = CGPoint(x:  rect.minX + width*doubleIndentFactor, y: rect.minY+yIndentFactor*height)
//        let topRight        = CGPoint(x:  rect.maxX - width*indentFactor,       y: rect.minY+yIndentFactor*height)
//        let bottomRight     = CGPoint(x:  rect.maxX - width*doubleIndentFactor, y: rect.maxY-yIndentFactor*height)
//
//        let controlTopTop       = CGPoint(x: topLeft.x+(topRight.x-topLeft.x)/(2.6), y:topLeft.y-yControlOffset*height)
//        let controlTopBottom    = CGPoint(x: topLeft.x+(topRight.x-topLeft.x)/(2.6), y:topLeft.y+yControlOffset*height)
//
//        let controlBottomTop       = CGPoint(x: bottomLeft.x+(bottomRight.x-bottomLeft.x)/(1.6), y:bottomLeft.y-yControlOffset*height)
//        let controlBottomBottom    = CGPoint(x: bottomLeft.x+(bottomRight.x-bottomLeft.x)/(1.6), y:bottomLeft.y+yControlOffset*height)
//
//        var p = Path()
//        p.move(to: bottomLeft)
//        p.addLine(to: topLeft)
//        p.addCurve(to: topRight,control1: controlTopBottom,control2:controlTopTop )
//        p.addLine(to: bottomRight)
//        p.addCurve(to: bottomLeft,control1:controlBottomTop,control2:controlBottomBottom )
//
//        return p
//    }
//    private let indentFactor : CGFloat = 0.05
//    private let doubleIndentFactor : CGFloat = 0.2
//    private let yIndentFactor : CGFloat = 0.2
//    private let yControlOffset: CGFloat = 0.3
//}
struct Squiggle: InsettableShape {
    private var insetAmount = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let bottomLeft = CGPoint(
            x: rect.minX + rect.width * Constants.indentFactor + insetAmount,
            y: rect.maxY - Constants.yIndentFactor * rect.height
        )
        let topLeft = CGPoint(
            x: rect.minX + rect.width * Constants.doubleIndentFactor + insetAmount,
            y: rect.minY + Constants.yIndentFactor * rect.height
        )
        let topRight = CGPoint(
            x: rect.maxX - rect.width * Constants.indentFactor - insetAmount,
            y: rect.minY + Constants.yIndentFactor * rect.height
        )
        let bottomRight = CGPoint(
            x: rect.maxX - rect.width * Constants.doubleIndentFactor - insetAmount,
            y: rect.maxY - Constants.yIndentFactor * rect.height
        )

        let controlTopTop = CGPoint(
            x: topLeft.x + (topRight.x - topLeft.x) / 2.6,
            y: topLeft.y - Constants.yControlOffset * rect.height
        )
        let controlTopBottom = CGPoint(
            x: topLeft.x + (topRight.x - topLeft.x) / 2.6,
            y: topLeft.y + Constants.yControlOffset * rect.height
        )

        let controlBottomTop = CGPoint(
            x: bottomLeft.x + (bottomRight.x - bottomLeft.x) / 1.6,
            y: bottomLeft.y - Constants.yControlOffset * rect.height
        )
        let controlBottomBottom = CGPoint(
            x: bottomLeft.x + (bottomRight.x - bottomLeft.x) / 1.6,
            y:bottomLeft.y + Constants.yControlOffset * rect.height
        )

        path.move(to: bottomLeft)
        path.addLine(to: topLeft)
        path.addCurve(to: topRight, control1: controlTopBottom, control2: controlTopTop)
        path.addLine(to: bottomRight)
        path.addCurve(to: bottomLeft, control1: controlBottomTop, control2: controlBottomBottom)

        return path
    }

    func inset(by amount: CGFloat) -> Squiggle {
        var squiggle = self
        squiggle.insetAmount += amount
        return squiggle
    }

    struct Constants {
        static let indentFactor = 0.05
        static let doubleIndentFactor = 0.2
        static let yIndentFactor = 0.2
        static let yControlOffset = 0.3
    }
}
