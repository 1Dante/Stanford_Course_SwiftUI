//
//  Circle Figure.swift
//  Set
//
//  Created by Viktor on 15.11.2022.
//

import SwiftUI

    struct CircleFigure: Shape {
        func path(in rect: CGRect) -> Path {
            let path = Path(roundedRect: rect, cornerRadius: 100)
            return path
        }
    }

