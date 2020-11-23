//
//  SearchView.swift
//  donuts
//
//  Created by Rosa Sun on 2020-11-12.
//

import SwiftUI

struct SearchView: View {
    var winAction: (() -> Void)?
    private var rowsNum: Int = 12
    private var columnsNum: Int = 12

    private var chars: [[Character]]
    @Binding var words: [String]
    @Binding var foundWords: [String]

    @State private var clicked: [Bool] = Array.init(repeating: false, count: 100)

    @State private var gridColumns: [GridItem] = Array.init(repeating: GridItem(.flexible(minimum: 25, maximum: 25), spacing: 0), count: 12)

    @GestureState private var location: CGPoint = .zero

    @Binding var selected: [(Int, Int)]
    @Binding var correctSelections: [[(Int, Int)]]
    @State private var highlighted: (Int, Int)? = nil
    @State private var curWord: String = ""

    init(grid:[[Character]], words: Binding<[String]>, foundWords: Binding<[String]>, selected: Binding<[(Int, Int)]>, correctSelections: Binding<[[(Int, Int)]]>) {
        self.rowsNum = grid.count
        self.columnsNum = grid[0].count

        self.chars = grid

        self._words = words
        self._foundWords = foundWords
        self._selected = selected
        self._correctSelections = correctSelections

        self.gridColumns = Array.init(repeating: GridItem(.flexible(minimum: 25, maximum: 25), spacing: 0), count: columnsNum)
    }

    func reset() {
        self.selected = []
        self.correctSelections = []
        self.highlighted = nil
    }

    func rectReader(row: Int, column: Int) -> some View {
        return GeometryReader { (geometry) -> AnyView in
            if geometry.frame(in: .global).contains(self.location) {
                DispatchQueue.main.async {
                    self.selected.append((row, column))
                    straightenLine()
                }
            }

            let fillColor = Color.pink.opacity(0.5 * Double(self.correctSelections.flatMap { $0 }.filter{ $0 == (row, column) }.count))
            return AnyView(Rectangle().fill(fillColor))
        }
    }

    func straightenLine() -> Void {
        if selected.count > 1 {
            var dirX: Int = selected.last!.0 - selected.first!.0
            if dirX != 0 {
                dirX = dirX < 0 ? -1 : 1
            }

            var dirY = abs(selected.last!.1) - selected.first!.1
            if dirY != 0 {
                dirY = dirY < 0 ? -1 : 1
            }

            var (x, y) = selected.first!

            var newSelected: [(Int, Int)] = []
            for point in selected {
                if (x, y) == point {
                    newSelected.append((x, y))
                    x += dirX
                    y += dirY
                }
            }

            self.selected = newSelected
        }
    }

    func validateSelection() -> Void {
        var word = selected.map({
            String(chars[$0.0][$0.1])
        }).joined()

        let reversed = selected.reversed().map({
            String(chars[$0.0][$0.1])
        }).joined()

        var valid: String? = nil

        if words.contains(word) {
            valid = word
        } else if words.contains(reversed) {
            valid = reversed
        } else {
            return
        }

        self.correctSelections.append(self.selected)
        self.foundWords.append(valid!)

        if foundWords.count == words.count {
            winAction!()
            return
        }
    }

    func onWin(perform action: @escaping () -> Void) -> Self {
        var copy = self
        copy.winAction = action
        return copy
    }

    func updateDisplayWord() -> Void {
        self.curWord = selected.map({
            String(chars[$0.0][$0.1])
        }).joined()
    }

    var body: some View {
        let highlightingWord = DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($location) { (value, state, transaction) in
                    state = value.location
                }.onChanged { _ in
                    updateDisplayWord()
                }.onEnded {_ in
                    DispatchQueue.main.async {
                        validateSelection()
                        self.selected = []
                        self.highlighted = nil
                    }
                }
        VStack {
            HStack {
                Spacer()

                Text("Found " + String(foundWords.count) + "/" + String(words.count))
                    .bold()
                Spacer()

                if curWord.count > 0 {
                    Text(curWord.capitalized)
                    Spacer()
                }
            }
            .font(.title2)
            .foregroundColor(.white)
            .padding([.top, .bottom], 5)
            .background(Color.orange.opacity(0.5))

            LazyVGrid(columns: gridColumns, spacing: 2, content: {
                ForEach((0..<(rowsNum * columnsNum)), id: \.self) { i in
                    let coord: (Int, Int) = (i / columnsNum, i % columnsNum)
                    let backgroundColor = self.rectReader(row: coord.0, column: coord.1)
                    Text(String(chars[coord.0][coord.1]).uppercased())
                            .fontWeight(self.selected.contains(where: {$0 == coord}) ? .bold : .none)
                            .padding(4)
                            .frame(minWidth: 25, maxWidth: 25, minHeight: 0, maxHeight: 200)
                            .foregroundColor(.white)
                            .background(backgroundColor)
                            .cornerRadius(5)
                            .scaleEffect(self.selected.contains(where: {$0 == coord}) ? 1.5 : 1)
                }
            })
            .gesture(highlightingWord)
            .padding([.top, .bottom], 10)
            .background(Color.white.opacity(0.5))
            .cornerRadius(10.0)
            .padding([.trailing, .leading], 20)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static let words = ["hello", "hallelujah", "bottle", "rosa"]

    static var previews: some View {
        ZStack {
            Color.black
            SearchView(grid: GridBuilder.init(words: self.words, rows: 12, columns: 12).build(words: self.words), words: .constant(["Hat", "Hallo", "Jasmine"]), foundWords: .constant([]), selected: .constant([]), correctSelections: .constant([]))
        }
    }
}
