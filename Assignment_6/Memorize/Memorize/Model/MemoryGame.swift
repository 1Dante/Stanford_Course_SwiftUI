//
//  MemoryGame.swift
//  Memorize
//
//  Created by Viktor on 09.11.2022.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    var score = 0
    
    private var indexOfTheOnlyOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach {cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potencialMatchIndex = indexOfTheOnlyOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potencialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potencialMatchIndex].isMatched = true
                    score += 2
                } 
                cards[chosenIndex].isFaceUp = true
                if cards[chosenIndex].content != cards[potencialMatchIndex].content && !cards[chosenIndex].isMatched {
                    score -= 1
                }
            } else {
                indexOfTheOnlyOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent?) {
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            guard let content = content else { break }
            cards.append(Card(content: content,id: pairIndex * 2))
            cards.append(Card(content: content,id: pairIndex * 2 + 1))
        }
        cards = cards.shuffled()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
        var id: Int
    }
}

extension Array {
    var oneAndOnly: Element? {
        if self.count == 1 {
            return self.first
        } else {
            return nil
        }
    }
}
