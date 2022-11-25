//
//  EmojiiMemoryGame.swift
//  Memorize
//
//  Created by Viktor on 09.11.2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    @Published var theme: EmojiTheme
    
    init(theme: EmojiTheme) {
        self.theme = theme
        newMemoryGame()
    }
    
    private var chosenThemeIndex: Int = 0
    
    func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPair) { pairIndex in
            let emojis = theme.emojis.map {String($0)}
            
            return emojis[pairIndex]
        }
    }
    
    @Published private  var model = MemoryGame<String>(numberOfPairsOfCards: 0) { _ in return ""}
    
    func newMemoryGame() {
        model = createMemoryGame()
    }
    
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    var score: Int {
        return model.score
    }
    
    var themeName: String {
        return theme.themeName
    }
    var themeColor: Color {
        return .init(rgbaColor: theme.color) 
    }
}
