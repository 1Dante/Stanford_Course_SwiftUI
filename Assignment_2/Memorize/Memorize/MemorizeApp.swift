//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Viktor on 07.11.2022.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame() 
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
