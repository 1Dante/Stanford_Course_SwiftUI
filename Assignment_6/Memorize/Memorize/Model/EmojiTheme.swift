//
//  EmojiTheme.swift
//  Memorize
//
//  Created by Viktor on 22.11.2022.
//

import Foundation

struct EmojiTheme: Identifiable, Codable, Hashable {
    var themeName: String
    var emojis: String
    var numberOfPair: Int
    var color: RGBAColor
    var id: Int
}

struct RGBAColor: Codable, Equatable, Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}

class ThemeStore: ObservableObject {

    @Published var themes: [EmojiTheme] = [] {
        didSet {
            saveInUserDefaults()
            print("saved")
        }
    }

    let name: String

    private var userDefaultsKey: String {
        return "ThemeStore" + name
    }

    private func saveInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }

    private func getThemesFromUserDefaults() {
        if let jsonData =  UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode([EmojiTheme].self, from: jsonData) {
            themes = decodedThemes
        }
    }

    init(name: String) {
        self.name = name
        getThemesFromUserDefaults()
        if themes.isEmpty {
            insertPalette(named: "Vehicles", emojis: "ððððððððŧðððððððâïļðŦðŽðĐððļðēððķâĩïļðĪðĨðģâīðĒððððððððšð", color: RGBAColor(color: .black))
            insertPalette(named: "Sports", emojis: "ðâūïļðâ―ïļðūððĨðâģïļðĨðĨðâ·ðģ", color: RGBAColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5))
            insertPalette(named: "Music", emojis: "ðžðĪðđðŠðĨðšðŠðŠðŧ", color: RGBAColor(color: .yellow))
            insertPalette(named: "Animals", emojis: "ðĨðĢðððððððĶððððððĶðĶðĶðĶðĒððĶðĶðĶðððĶðĶðĶ§ðĶĢððĶðĶðŠðŦðĶðĶðĶŽððĶððĶððĐðĶŪððĶĪðĶĒðĶĐððĶðĶĻðĶĄðĶŦðĶĶðĶĨðŋðĶ",color: RGBAColor(color: .gray) )
            insertPalette(named: "Animal Faces", emojis: "ðĩððððķðąð­ðđð°ðĶðŧðžðŧââïļðĻðŊðĶðŪð·ðļðē", color: RGBAColor(color: .green))
            insertPalette(named: "Flora", emojis: "ðēðīðŋâïļððððūðð·ðđðĨðšðļðžðŧ", color: RGBAColor(color: .purple))
            insertPalette(named: "Weather", emojis: "âïļðĪâïļðĨâïļðĶð§âðĐðĻâïļðĻâïļð§ðĶðâïļðŦðŠ",  color: RGBAColor(color: .pink))
            insertPalette(named: "COVID", emojis: "ððĶ ð·ðĪ§ðĪ",color: RGBAColor(color: .blue))
            insertPalette(named: "Faces", emojis: "ððððððððĪĢðĨēâšïļððððððððĨ°ðððððððððĪŠðĪĻð§ðĪððĨļðĪĐðĨģððððððâđïļðĢððŦðĐðĨšðĒð­ðĪð ðĄðĪŊðģðĨķðĨððĪðĪðĪ­ðĪŦðĪĨðŽððŊð§ðĨąðīðĪŪð·ðĪ§ðĪðĪ ",color: RGBAColor(color: .cyan))
        }
        
    }

    func insertPalette(named name: String, emojis: String? = nil, at index: Int = 0, color: RGBAColor) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = EmojiTheme(themeName: name, emojis: emojis ?? "", numberOfPair: 1,color: color,id: unique)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
}


