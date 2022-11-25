//
//  ContentView.swift
//  Memorize
//
//  Created by Viktor on 07.11.2022.
//

import SwiftUI

struct CardsGameView: View {
    @ObservedObject  var viewModel: EmojiMemoryGame

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.themeName).font(Font.system(size: 20).bold()).padding(.leading, 20)
                Spacer()
                Text("Score: \(viewModel.score)").font(Font.system(size: 20).bold()).padding(.trailing, 40)
            }
            ScrollView {

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(Array(viewModel.cards.enumerated()),id: \.offset) { (_,card) in
                        CardView(card: card, color: viewModel.themeColor).aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
                .foregroundColor(.red)
            }
            .padding(.horizontal)
            Button {
                viewModel.newMemoryGame()
            } label: {
                Text("New Game").font(.largeTitle).foregroundColor(.black)
            }.padding(5).background(Color(red: 0.4627, green: 0.8392, blue: 1.0)).cornerRadius(12)
        }
        
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var color: Color

    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill().foregroundColor(color)
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var game = EmojiMemoryGame(theme: <#EmojiTheme#>)
//    static var previews: some View {
//        ContentView(viewModel: game)
//
//
//    }
//}
