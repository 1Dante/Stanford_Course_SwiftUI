//
//  ColorExtention.swift
//  Memorize
//
//  Created by Viktor on 22.11.2022.
//

import SwiftUI

extension Color {
    init(rgbaColor rgba: RGBAColor) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
}


extension RGBAColor {
    init(color: Color) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        let cgColor = UIColor(color).cgColor
        UIColor(cgColor: cgColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//        if let cgColor = color.cgColor {
//            print(cgColor)
//            print("here is color")
//            UIColor(cgColor: cgColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//        } else {
//            print("not found")
//        }
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}

extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
}

extension RangeReplaceableCollection where Element: Identifiable {
    mutating func remove(_ element: Element) {
        if let index = index(matching: element) {
            remove(at: index)
        }
    }

    subscript(_ element: Element) -> Element {
        get {
            if let index = index(matching: element) {
                return self[index]
            } else {
                return element
            }
        }
        set {
            if let index = index(matching: element) {
                replaceSubrange(index...index, with: [newValue])
            }
        }
    }
}


extension String {
    var removingDuplicateCharacters: String {
        reduce(into: "") { sofar, element in
            if !sofar.contains(element) {
                sofar.append(element)
            }
        }
    }
}

extension Character {
    var isEmoji: Bool {
        if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji {
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        } else {
            return false
        }
    }
}


