//
//  EmojiiMemoryGame.swift
//  Memorize
//
//  Created by Viktor on 09.11.2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {

    static var emojiChoises: [EmojisTheme] = [EmojisTheme(themeName: "animals", emojis: ["🐶", "🐹", "🐻", "🐮", "🦁", "🐵", "🐣", "🦆", "🐝", "🦄", "🐞", "🦕"], color: "red"),
                                              EmojisTheme(themeName: "smiles", emojis: ["😃", "😆", "😂", "😇", "😉", "😍", "😝", "🥸", "😭", "🥵", "🥶", "😱"], color: "yellow"),
                                              EmojisTheme(themeName: "food", emojis: ["🍐", "🍎", "🍇", "🍆", "🍌", "🍍", "🥝", "🌽", "🥨", "🧀", "🥚", "🥐"],color: "green"),
                                              EmojisTheme(themeName: "drinks", emojis: ["🍷", "☕️", "🫖", "🍺", "🥛", "🍸"],color: "blue"),
                                              EmojisTheme(themeName: "transport", emojis: ["🚝", "🚗", "🛥" ,"🚀", "🚎", "🚚","🚓", "🛴", "🚍", "🚆", "🚇", "🚑"], color: "orange"),
                                              EmojisTheme(themeName: "subject", emojis: ["⌚️", "📱", "💻", "🖥", "📷", "🎥", "☎️", "🎙", "⏰", "📺", "📠", "📟"],color: "purple")
    ]
    static private var chosenThemeIndex: Int = 0


    static func createMemoryGame() -> MemoryGame<String> {
        var cardPairs = Int.random(in: 4...14)
        chosenThemeIndex = emojiChoises.indices.randomElement() ?? 0
        return MemoryGame<String>(numberOfPairsOfCards: cardPairs) { pairIndex in
            if pairIndex < emojiChoises[chosenThemeIndex].emojis.count {
                return emojiChoises[chosenThemeIndex].emojis[pairIndex]
            } else {
                return nil
            }
        }
    }

    @Published private  var model = createMemoryGame()

    func newMemoryGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }

    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }

    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }

    var themeName: String {
        return EmojiMemoryGame.emojiChoises[EmojiMemoryGame.chosenThemeIndex].themeName
    }

    var color: Color {
        switch EmojiMemoryGame.emojiChoises[EmojiMemoryGame.chosenThemeIndex].color {
        case "orange": return .orange
        case "red": return .red
        case "yellow": return .yellow
        case "green": return .green
        case "purple": return .purple
        case "blue": return .blue
        default: return .black
        }
    }

    var score: Int {
        return model.score
    }
}
