//
//  GameView.swift
//  donuts
//
//  Created by Rosa Sun on 2020-11-12.
//

import SwiftUI

enum Direction: CaseIterable {
    case UP, DOWN, LEFT, RIGHT, UPRIGHT, UPLEFT, DOWNRIGHT, DOWNLEFT

    var vecDir:(Int, Int) {
        switch self {
        case .UP: return (0, 1)
        case .DOWN: return (0, -1)
        case .LEFT: return (-1, 0)
        case .RIGHT: return (1, 0)
        case .UPRIGHT: return (1, 1)
        case .UPLEFT: return (-1, 1)
        case .DOWNRIGHT: return (1, -1)
        case .DOWNLEFT: return (-1, -1)
        }
    }
}

class WordsAPI {
    var words = ["jewel", "dozen", "witness", "slight", "polite", "curious", "defeat", "ambitious", "confidence", "sneaky", "laugh", "theory"]

    init() {
        getWords()
    }

    private func getWords() {
        guard let url = URL(string: "https://raw.githubusercontent.com/bevacqua/correcthorse/master/wordlist.json") else { return }

        let session = URLSession.shared

        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let jsonWords = try? JSONSerialization.jsonObject(with: data, options: []) {
                    DispatchQueue.main.async {
                        self.words = jsonWords as? [String] ?? self.words
                        print(self.words)
                    }
                    return
                }
            }
            print("Fetch failed")
        }.resume()
    }

    func nRandomWords(n: Int, minLength: Int = 4, maxLength: Int = 10) -> [String] {
        var randomWords: [String] = []

        for _ in 0...100 {
            let tmp: String = words.randomElement()!

            if minLength...maxLength ~= tmp.count && !randomWords.contains(tmp) {
                randomWords.append(tmp)
            }

            if randomWords.count >= n { return randomWords }
        }

        return randomWords
    }
}

class GridBuilder: ObservableObject {
    @Published var grid = [[Character]]()

    private var words:[String]
    private var totalRows:Int
    private var totalColumns:Int
    private var wordsAPI: WordsAPI

    init(words: [String], rows:Int, columns:Int) {
        self.wordsAPI = WordsAPI()
        self.words = words
        self.grid = Array.init(repeating: Array.init(repeating: "-", count: columns), count: rows)
        self.totalRows = rows
        self.totalColumns = columns
    }

    func build(words: [String]) -> [[Character]] {
        self.words = words
        print("building: \(words)")
        var generated = false
        trialLoop: for _ in (0...10) {
            self.grid = Array.init(repeating: Array.init(repeating: "*", count: self.totalColumns), count: self.totalRows)

            for word in words.shuffled() {
                if !insertWord(word: word) {
                    continue trialLoop
                }
            }
            generated = true
            break
        }

        if !generated {
            self.grid = Array.init(repeating: Array.init(repeating: "*", count: self.totalColumns), count: self.totalRows)
            return self.grid
        }

        let chars = "aaabcdeeefghiiijklllmnooopqrrssstttuuuvwxyz"

        for r in (0..<self.totalRows) {
            for c in (0..<self.totalColumns) {
                if self.grid[c][r] == "*" {
                    self.grid[c][r] = chars.randomElement() ?? "*"
                }
            }
        }

        return self.grid

    }

    func insertWordAt(word:String, rowNum:Int, columNum:Int, dir:Direction) -> Void {
        let (deltaX, deltaY) = dir.vecDir
        var curX = columNum, curY = rowNum

        for char in word {
            if char != self.grid[curY][curX] {
                self.grid[curY][curX] = char
            }
            curX += deltaX
            curY += deltaY
        }
    }

    func insertWord(word:String) -> Bool {
        for _ in (0...200) {
            let c = Int(arc4random_uniform(UInt32(self.totalColumns)))
            let r = Int(arc4random_uniform(UInt32(self.totalRows)))
            let d = Direction.allCases.randomElement()!

            if canInsertAt(rowNum: r, columnNum: c, word: word, dir: d) {
                insertWordAt(word: word, rowNum: r, columNum: c, dir: d)
                return true
            }
        }
        return false
    }

    func canInsertAt(rowNum:Int, columnNum:Int, word:String, dir:Direction) -> Bool {
        let (xDir, yDir) = dir.vecDir
        var curX = columnNum, curY = rowNum

        for char in word {
            if curX < 0 || curX > (self.totalColumns - 1) || curY < 0 || curY > (self.totalRows - 1) {
                return false
            }

            if self.grid[curY][curX] == "*" || self.grid[curY][curX] == char {
                curX += xDir
                curY += yDir
            } else {
                return false
            }
        }
        return true
    }
}

struct GameView: View {
    @State private var words: [String] = WordsAPI().nRandomWords(n: 10)

    @State private var foundWords: [String] = []

    @State var selected: [(Int, Int)] = []
    @State var correctSelections: [[(Int, Int)]] = []

    @ObservedObject private var gridBuilder:GridBuilder = GridBuilder.init(words: [], rows: 10, columns: 10)

    @State var searchView: SearchView? = nil

    private var wordsAPI: WordsAPI = WordsAPI()

    init() {
        self.gridBuilder = GridBuilder.init(words: words, rows: 10, columns: 10)
        _ = gridBuilder.build(words: self.words)

        self.words = wordsAPI.nRandomWords(n: 10)
    }

    func resetGame() -> Void {
        self.foundWords = []
        self.words = wordsAPI.nRandomWords(n: 10)
        _ = gridBuilder.build(words: self.words)
        self.searchView?.reset()
    }

    var body: some View {
        ZStack {
            Image("purplebackground")
            LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .topLeading, endPoint: .trailing)

            VStack {
                SearchView(grid: gridBuilder.grid, words: $words, foundWords: $foundWords, selected: $selected, correctSelections: $correctSelections)

                LazyVGrid(columns: [GridItem(.flexible(maximum: 100)), GridItem(.flexible(maximum: 100))], content: {
                    ForEach(words, id: \.self) { word in
                        Text(word)
                            .strikethrough(foundWords.contains(word))
                    }
                })

                Button(action: {
                    self.resetGame()
                }, label: {
                    Text("SHUFFLE")
                })
                .padding(10)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(5)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
