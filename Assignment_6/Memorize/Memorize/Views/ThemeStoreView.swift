//
//  Theme Manager.swift
//  Memorize
//
//  Created by Viktor on 23.11.2022.
//

import SwiftUI

struct ThemeStoreView: View {
    @EnvironmentObject var themeStore: ThemeStore

    @State private var editMode: EditMode = .inactive
    @State private var emojiTheme: EmojiTheme?
    @State private var isPresented: Bool = true

    var body: some View {
        NavigationView {
            List {
                ForEach(themeStore.themes) { theme in
                    NavigationLink(destination: CardsGameView(viewModel: EmojiMemoryGame(theme: theme)) ) {
                        VStack(alignment: .leading ){
                            HStack {
                                Text("Cards: \(theme.emojis.count)")
                                Spacer()
                                Text(theme.themeName).bold()
                                Spacer()
                                Circle().foregroundColor(.init(rgbaColor: theme.color)).frame(width: 25,height: 25)
                            }
                            Text(theme.emojis).lineLimit(1)
                        }
                        .gesture(editMode == .active ? tap(theme: theme) : nil)
                    }
                }
                .onDelete { indexSet in
                    themeStore.themes.remove(atOffsets: indexSet)
                }
            }.sheet(item: $emojiTheme, content: { id in
                ThemeEditorView(theme: $themeStore.themes[id])
            })
            .navigationTitle("Themes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{ ToolbarItem { EditButton() }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Add") {
                        themeStore.insertPalette(named: "New", color: .init(color: .white))
                        emojiTheme = themeStore.themes.first
                    }
                }
            }

            .environment(\.editMode, $editMode)
        }
    }

    func tap(theme: EmojiTheme) -> some Gesture {
        TapGesture().onEnded { _ in
            emojiTheme = theme
        }
    }
}

struct ThemeManager_Previews: PreviewProvider {
    static var previews: some View {
        ThemeStoreView()
            .environmentObject(ThemeStore(name: "Preview"))
    }
}
