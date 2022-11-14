//
//  ContentView.swift
//  Memorize
//
//  Created by Viktor on 07.11.2022.
//

import SwiftUI

struct ContentView: View {
    var vehicleEmojis = ["🚝", "🚗", "🛥" ,"🚀", "🚎", "🚚","🚓", "🛴", "🚍", "🚆", "🚇", "🚑", "🛩", "🚁", "🚲" ,"🛵" , "🏍", "🛺"]
    var smilesEmojis = ["😃", "😆", "😂", "😇", "😉", "😍", "😝", "🥸", "😭", "🥵", "🥶", "😱", "🫡", "🫥", "🥱", "🫠", "😈"]
    var animalsEmojis = ["🐶", "🐹", "🐻", "🐮", "🦁", "🐵", "🐣", "🦆", "🐝", "🦄", "🐞", "🦕"]
    @State var emojis: [String] = [""]
    @State var emojisCount = 0

    var body: some View {
        VStack{
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(emojis[0..<emojisCount], id: \.self) { emoji in
                        CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                    }
                }
                .foregroundColor(.red)
            }
            HStack {
                Spacer()
                ButtonView(emojis: vehicleEmojis, image: Image(systemName: "car"), text: "Vehicles", completion: { emojis, emojisCount in
                    self.emojis = emojis
                    self.emojisCount = emojisCount
                })
                Spacer()
                ButtonView(emojis: smilesEmojis, image: Image(systemName: "face.smiling"), text: "Smiles", completion: { emojis, emojisCount in
                    self.emojis = emojis
                    self.emojisCount = emojisCount
                })
                Spacer()
                ButtonView(emojis: animalsEmojis, image: Image(systemName: "hare"), text: "Animals", completion: { emojis, emojisCount in
                    self.emojis = emojis
                    self.emojisCount = emojisCount
                })
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 20.0)
    }
}

struct ButtonView: View {
    @State var emojis: [String]
    var image: Image
    var text: String
    var completion: ([String],Int) -> Void

    var body: some View {
        Button  {
            completion(emojis, Int.random(in: 4...emojis.count))
        } label: {
            VStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40.0, height: 40.0)
                Text(text).font(.footnote).padding(.top, -8.0)
            }
        }
    }
}

struct CardView: View {
    var content: String
    @State var isFaceUp = true
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
