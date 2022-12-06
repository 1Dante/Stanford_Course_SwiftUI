//
//  ContentView.swift
//  Set
//
//  Created by Viktor on 14.11.2022.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var game = SetGame()
    @State private var isFirstTime = true
    @Namespace private var dealingNameSpace
    @Namespace private var mathedNameSpace
    @State private var color = Color.clear
    @State private var isMathedCard = false

    var body: some View {

        VStack {
            HStack{
                Button {
                    isFirstTime = true
                    withAnimation {
                        dealt = []
                        isMathedCard = false
                        matchedCards = []
                        game.newGame()
                    }

                } label: {
                    Text("Restart")
                }.padding(.leading,30)
                Spacer()
                Text("Score: \(game.score)").padding(.trailing,30)
            }
            ZStack{

                AspectVGrid(items: game.cards, aspectRatio: 2/3) { (card) in
                    ZStack {
                        CardView(card: card)
                            .matchedGeometryEffect(id: card.id, in: isMathedCard ? mathedNameSpace : dealingNameSpace)
                            .transition(isMathedCard ?
                                        AnyTransition.asymmetric(insertion: .opacity, removal: .identity) :
                                            AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                            .zIndex(zIndex(of: card))
                            .onTapGesture {
                                game.checkSelectedCards(card: card, isMatched: { isMathed in
                                    if isMathed {
                                        withAnimation(.easeInOut(duration: 2)) {
                                            self.color = Color.green.opacity(0.8)
                                            withAnimation(
                                                Animation.easeInOut(duration: 2)
                                                    .delay(3)
                                            ) {

                                                self.color = Color.clear
                                                isMathedCard = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                    for (index, card) in game.cards.enumerated() {
                                                        if game.cards[index].isSelected {
                                                            withAnimation(.easeInOut(duration: 2)) {
                                                                matched(card)
                                                            }
                                                        }
                                                    }
                                                    game.cards.removeAll(where: {$0.isSelected})
                                                    isMathedCard = false
                                                    game.dealMore3Cards()
                                                    for card in game.cards {
                                                        withAnimation(dealAnimation(for: card)) {
                                                            deal(card)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        withAnimation(.easeInOut(duration: 2)) {
                                            self.color = Color.red.opacity(0.8)
                                        }
                                        withAnimation(
                                            Animation.easeInOut(duration: 2)
                                                .delay(2)
                                        ) {
                                            self.color = Color.clear
                                            for (index, _) in game.cards.enumerated() {
                                                game.cards[index].isSelected = false
                                                game.selectedCards.removeAll()
                                            }
                                        }
                                    }
                                })
                            }
                        color
                    }
                }
            }

            HStack {
                ZStack {
                    ForEach(game.cards.filter {isUndealt($0)}) { card in
                        CardView(card: card)
                            .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                            .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                            .zIndex(zIndex(of: card))
                    }
                    Color.red
                }.frame(width: 90, height: 90 * 4/3)
                    .onTapGesture {
                        if isFirstTime {
                            game.newGame()
                        } else {
                            game.dealMore3Cards()

                        }
                        for (index, card) in game.cards.enumerated() {
                            if isFirstTime {
                                withAnimation(dealAnimation(for: card)) {
                                    deal(card)
                                }
                                if index == game.cards.count - 1 {
                                    isFirstTime = false
                                }

                            } else if !isFirstTime && index >= game.cards.count - 3 {
                                withAnimation(dealAnimation(for: card)) {
                                    deal(card)
                                }
                            }
                        }
                    }
                Spacer()
                ZStack {
                    Rectangle().stroke(.black, lineWidth: 3)

                    ForEach(matchedCards) { card in
                        CardView(card: card)
                            .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                            .matchedGeometryEffect(id: card.id, in: mathedNameSpace)
                            .zIndex(zIndex(of: card))

                    }
                }.frame(width: 90, height: 90 * 4/3)
            }.padding()
        }
        .padding()
    }


    @State private var dealt = Set<Int>()

    private func deal(_ card: Card) {
        dealt.insert(card.id)
    }

    private func isUndealt(_ card: Card) -> Bool {
        return !dealt.contains(card.id)
    }

    @State private var matchedCards: [Card] = []
    private func matched(_ card: Card) {
        var _card = card
        _card.isSelected = false
        matchedCards.append(_card)
    }



    private func zIndex(of card: Card) -> Double {
        -Double( game.cards.firstIndex(where: {$0.id == card .id} ) ?? 0)
    }

    private func dealAnimation(for card: Card) -> Animation {
        var delay = 0.0
        var indexForDealMoreCards = game.cards.count - 3
        if var index = game.cards.firstIndex(where: {$0.id == card.id} ) {
            if isFirstTime {
                delay = Double(index) * 2 / Double(game.cards.count)
            } else {
                indexForDealMoreCards = index - indexForDealMoreCards
                delay = Double(indexForDealMoreCards) * 2 / Double(game.cards.count)
            }
        }
        return Animation.easeInOut(duration: 0.5).delay(delay)
    }
}


struct CardView: View {
    var card: Card

    @State var size: CGSize = CGSize.zero

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
