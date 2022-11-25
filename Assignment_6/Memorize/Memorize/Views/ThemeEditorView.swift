//
//  ThemeEditorView.swift
//  Memorize
//
//  Created by Viktor on 22.11.2022.
//

import SwiftUI

struct ThemeEditorView: View {

    @Binding var theme: EmojiTheme

    var body: some View {
        Form{
            nameSection
            addEmoji
            removeEmoji
            cardsPairCount
            colorPicker
        }
        .frame(minWidth: 300,minHeight: 350)
    }

    var nameSection: some View {
        Section("Name") {
            TextField("Name", text: $theme.themeName) {
            }
        }
    }

    @State private var emojiToAdd = ""

    var addEmoji: some View {
        Section("Add Emoji") {
            TextField("", text: $emojiToAdd).onChange(of: emojiToAdd) { emoji in
                addEmoji(emoji)
            }
        }
    }

    private func addEmoji(_ emojis: String) {
        theme.emojis = (emojis + theme.emojis).filter{$0.isEmoji}.removingDuplicateCharacters
    }

    var removeEmoji: some View {
        Section("Remove Emoji") {
            let emojis = theme.emojis.map {String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji).onTapGesture {
                        withAnimation {
                            theme.emojis.removeAll(where: {String($0) == emoji})
                        }
                    }.padding(4)
                }
            }
        }
    }

    var cardsPairCount: some View {
        Section("Card Pair Count") {
            Stepper(value: $theme.numberOfPair, in: 0...theme.emojis.count,step: 1) {
                Text("Pairs: \(theme.numberOfPair)")
            }
        }
    }

    private func convertColor() -> Binding<Color> {
        return Binding<Color>(get: { Color.init(rgbaColor: theme.color) },
                              set: { $theme.wrappedValue.color = .init(color: $0)})
    }

    var colorPicker: some View {
        Section("Color Card") {
            ColorPicker("Color Card", selection: convertColor())
        }
    }
}



//struct ThemeEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//      //  ThemeEditorView(theme: .constant(EmojiTheme(themeName: "", emojis: [""], color: .init(color: .black))))
//    }
//}
