//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Viktor on 07.11.2022.
//

import SwiftUI

@main
struct MemorizeApp: App {

    var body: some Scene {
        WindowGroup {
            //ContentView(viewModel: game)
            ThemeStoreView().environmentObject(ThemeStore(name: "Themes"))
           // ThemeEditorView(theme: .constant(EmojiTheme(themeName: "name", emojis: [""])))
        }
    }
}
