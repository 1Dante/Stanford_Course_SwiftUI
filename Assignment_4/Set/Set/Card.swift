//
//  Card.swift
//  Set
//
//  Created by Viktor on 15.11.2022.
//

import Foundation

struct Card: Identifiable {

    var isSelected: Bool
    var attributesCard: AttributesOfCard
    var id: Int

}

struct AttributesOfCard {
  var color: CardColor
  var figure: Figure
  var qtyOfChar: Int
  var texture: Texture
}

extension AttributesOfCard: Hashable {
  func hash(into hasher: inout Hasher) {
      hasher.combine(color)
      hasher.combine(figure)
    hasher.combine(texture)
  }
}


enum Figure: String, CaseIterable {

  case circle
  case squiggle
  case square
}

enum QtyOfFigure: Int, CaseIterable {

  case one = 1
  case two = 2
  case three = 3
}

enum Texture: CaseIterable {

  case fillFigure
  case emptyFigure
  case hatchedFigure
}

enum CardColor: CaseIterable {
    case red
    case green
    case purple
}
