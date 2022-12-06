//
//  SetGame.swift
//  Set
//
//  Created by Viktor on 15.11.2022.
//

import SwiftUI

class SetGame: ObservableObject {

    var numberOfCards = 12
    var score = 0
    @Published var cards: [Card] = []
    private (set) var attributesTitleOfCards: [AttributesOfCard] = []
    var selectedCards: [AttributesOfCard] = []
    var tappedCount = 0 

    func newGame() {
        attributesTitleOfCards = []
        cards = []
        numberOfCards = 12
        score = 0
        tappedCount = 0
        setupSets()
        for (index, item) in attributesTitleOfCards.enumerated() {
            cards.append(Card(isSelected: false, attributesCard: item, id: index))
            if index == numberOfCards - 1 {
                break
            }
        }
    }

    func dealMore3Cards() {
        for (index, _) in cards.enumerated() {
            cards[index].isSelected = false
        }
        numberOfCards += 3
        for (index, item) in attributesTitleOfCards.enumerated() {
            if index >= numberOfCards - 3 {
                cards.append(Card(isSelected: false, attributesCard: item, id: index))
            }
            if index == numberOfCards - 1 {
                break
            }
        }
    }

    func checkSelectedCards(card: Card, isMatched: (Bool) -> Void) {
        for (index, item) in cards.enumerated() {
            if card.id == item.id && !cards[index].isSelected {
                cards[index].isSelected = true
                selectedCards.append(card.attributesCard)
                tappedCount += 1
            } else if card.id == item.id && cards[index].isSelected && tappedCount < 3 {
                cards[index].isSelected = false
                selectedCards.removeAll(where: { $0 == card.attributesCard })
                tappedCount -= 1
            }
        }
        if tappedCount == 3 {
            if checkMatchingCard() {
               isMatched(true)
            } else {
               isMatched(false)
            }
            tappedCount = 0
        }
    }

    func checkMatchingCard() -> Bool {
      cards.forEach {
        if $0.isSelected == true {
          selectedCards.append($0.attributesCard)
        }
      }

      var qtyOfChar: [Int] = []
      var color: [CardColor] = []
      var figure: [Figure] = []
      var texture: [Texture] = []
      selectedCards.forEach { attribute in
        qtyOfChar.append(attribute.qtyOfChar)
        color.append(attribute.color)
        figure.append(attribute.figure)
        texture.append(attribute.texture)
      }

      let compareElements = [Set(qtyOfChar).count,Set(color).count,Set(figure).count,Set(texture).count]
      if !compareElements.contains(2) {
       score += 5
        return true
      } else {
       score -= 3
        return false
      }
    }

  private func setupSets() {
      var itemsOfSet = 0
      while itemsOfSet < 81 {
          let attributesOfCard = AttributesOfCard(color: CardColor.allCases.randomElement()!, figure: Figure.allCases.randomElement()!, qtyOfChar: Int.random(in: 1...3), texture: Texture.allCases.randomElement()!)
        if !attributesTitleOfCards.contains(where: {$0 == attributesOfCard} ) {
          attributesTitleOfCards.append(attributesOfCard)
          itemsOfSet += 1
        }
      }
    }
}
