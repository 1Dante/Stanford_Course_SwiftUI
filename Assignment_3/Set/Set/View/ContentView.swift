//
//  ContentView.swift
//  Set
//
//  Created by Viktor on 14.11.2022.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var game = SetGame()
    @State private var matchedAlert = false
    @State private var notMathedAlert = false

    init() {
        game.newGame()
    }

    var body: some View {
        VStack {
            HStack{
                Button {
                    game.newGame()
                } label: {
                    Text("New Game")
                }.padding(.leading,30)
                Spacer()
                Text("Score: \(game.score)").padding(.trailing,30)
            }
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { (card) in
                CardView(card: card).onTapGesture {
                    game.checkSelectedCards(card: card, isMatched: { isMathed in
                        if isMathed {
                            matchedAlert = true
                        } else {
                            notMathedAlert = true
                        }
                    })
                }
                .alert(Text("Matched"), isPresented: $matchedAlert) {
                    Button("OK",role: .cancel) {
                        game.cards.removeAll(where: { $0.isSelected == true })
                        game.dealMore3Cards()
                    }
                }
                .alert(Text("Wrong"), isPresented: $notMathedAlert) {
                    Button("OK",role: .cancel) {
                        for (index, _) in game.cards.enumerated() {
                            game.cards[index].isSelected = false
                            game.selectedCards.removeAll()
                        }
                    }
                }
            }
            Button {
                game.dealMore3Cards()
            } label: {
                Text("deal more 3 cards").font(.largeTitle).frame(minWidth: 0,maxWidth: .infinity )
            }.background(Color(red: 0.7, green: 0.8, blue: 0.9)).cornerRadius(15).disabled(game.cards.last?.attributesCard == game.attributesTitleOfCards.last)
        }
        .padding()
    }

}

struct CardView: View {
    var card: Card

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ForEach(1...card.attributesCard.qtyOfChar, id: \.self) { _ in
                    FigureView(size: geometry.size, card: card.attributesCard).aspectRatio(2/2, contentMode: .fit).frame(height: geometry.size.height/4)
                }
                HStack {
                    Spacer(minLength: 0)
                }
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }.background (card.isSelected ? .gray : .white)
            .padding(3)
    }
}

struct FigureView: View {

    let size: CGSize
    var game = SetGame()
    var card: AttributesOfCard

    @ViewBuilder
    var body: some View {

        GeometryReader { geometry in
            switch card.texture {
            case .hatchedFigure:
                switch card.figure {
                case .circle:
                    HatchedView(cgSize: geometry.size, color: getColor(color: card.color)).clipShape(CircleFigure())
                case .squiggle:
                    HatchedView(cgSize: geometry.size, color: getColor(color: card.color)).clipShape(SquiggleFigure())
                case .square:
                    HatchedView(cgSize: geometry.size, color: getColor(color: card.color)).clipShape(SquareFigure())
                }
            case .fillFigure:
                switch card.figure {
                case .circle:
                    CircleFigure().fill(getColor(color: card.color))
                case .squiggle:
                    SquiggleFigure().fill(getColor(color: card.color))
                case .square:
                    SquareFigure().fill(getColor(color: card.color))
                }
            case .emptyFigure:
                switch card.figure {
                case .circle:
                    CircleFigure().stroke(getColor(color: card.color), lineWidth: 5)
                case .squiggle:
                    SquiggleFigure().stroke(getColor(color: card.color), lineWidth: 5)
                case .square:
                    SquareFigure().stroke(getColor(color: card.color), lineWidth: 5)
                }
            }
        }
    }

    func getColor(color: CardColor) -> Color {
        switch color {
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
