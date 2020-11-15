//
//  SearchView.swift
//  donuts
//
//  Created by Rosa Sun on 2020-11-12.
//

import SwiftUI

struct SearchView: View {
    private var rowsNum:Int = 10
    private var columnsNum:Int = 10 // how do you use these in other var declarations??.....

    private var chars:[Character] = Array("hellohollohowareyouimjuopuythrekshfjdbwareyouimjuopuythrekshfjdbcnfjldkfjllohowareyouimjuopuythrekshfjdbsdkllohollohowllohowareyouimjuopuythrekshfjdbarellllollohowareyouimjuopuythrekshfjdbhowareyouimjuopuythrekshfjdbohowarellohowareyouimjuopuythrekshfjdbyouimjuopuythrekshfjdbyouimjuopuythrekshfjdbwareyouimjuopuythrekshfjdbfj")


    @State private var clicked:[Bool] = Array.init(repeating: false, count: 100)

    @State private var gridColumns:[GridItem] = Array.init(repeating: GridItem(.flexible(minimum: 25, maximum: 25), spacing: 0), count: 10)

    init(grid:[[Character]]) {
        self.rowsNum = grid.count
        self.columnsNum = grid[0].count

        self.gridColumns = Array.init(repeating: GridItem(.flexible(minimum: 25, maximum: 25), spacing: 0), count: 10)

        self.chars = grid.flatMap { $0 }
    }

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 2, content: {
            ForEach(0..<(rowsNum * columnsNum), id: \.self) { i in
                Button(action: {
                    self.clicked[i] = true
                }) {
                    let backgroundColor = self.clicked[i] ? Color.white : nil
                    Text(String(chars[i]).uppercased())
                        .padding(4)
                        .frame(minWidth: 25, maxWidth: 25, minHeight: 0, maxHeight: 200)
                        .foregroundColor(.purple)
                        .background(backgroundColor)
                        .cornerRadius(5)
                }
            }
        })
    }
}

struct SearchView_Previews: PreviewProvider {
    static let words = ["hello", "hallelujah", "bottle", "rosa"]

    static var previews: some View {
        SearchView(grid: GridBuilder.init(words: self.words, rows: 10, columns: 10).build())
    }
}
