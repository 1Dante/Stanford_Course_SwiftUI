//
//  HatchedView.swift
//  Set
//
//  Created by Viktor on 15.11.2022.
//

import SwiftUI


struct HatchedView: View , ShapeStyle {

    var cgSize: CGSize
    var color: Color

    var body: some View {
        ForEach(minXPositions,id: \.self) { minX in
            LinePath(maxY: cgSize.height, minX: CGFloat(minX)).stroke(color,lineWidth: 5)
        }
    }

    private var minXPositions: [CGFloat] {
        var minXRange: [CGFloat] = []
        for item in stride(from: 0, to: Int(cgSize.width), by: 10) {
            minXRange.append(CGFloat(item))
        }
        return minXRange
    }

    struct LinePath: Shape {
        var maxY: CGFloat
        var minX: CGFloat
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: minX, y: 0))
            path.addLine(to: CGPoint(x: minX + 10, y: maxY))
            return path
        }
    }
}
