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
            insertPalette(named: "Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜", color: RGBAColor(color: .black))
            insertPalette(named: "Sports", emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳", color: RGBAColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5))
            insertPalette(named: "Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻", color: RGBAColor(color: .yellow))
            insertPalette(named: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔",color: RGBAColor(color: .gray) )
            insertPalette(named: "Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲", color: RGBAColor(color: .green))
            insertPalette(named: "Flora", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻", color: RGBAColor(color: .purple))
            insertPalette(named: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪",  color: RGBAColor(color: .pink))
            insertPalette(named: "COVID", emojis: "💉🦠😷🤧🤒",color: RGBAColor(color: .blue))
            insertPalette(named: "Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠",color: RGBAColor(color: .cyan))
        }
        
    }

    func insertPalette(named name: String, emojis: String? = nil, at index: Int = 0, color: RGBAColor) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = EmojiTheme(themeName: name, emojis: emojis ?? "", numberOfPair: 1,color: color,id: unique)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
}


