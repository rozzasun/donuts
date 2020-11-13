//
//  SearchView.swift
//  donuts
//
//  Created by Rosa Sun on 2020-11-12.
//

import SwiftUI

struct SearchView: View {
    private let rowsNum:Int = 10
    private let columnsNum:Int = 10 // how do you use these.....

    private var gridColumns:[GridItem] = Array.init(repeating: GridItem(.flexible(minimum: 30, maximum: 40), spacing: 0), count: self.columnsNum)
    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 1, content: {
            ForEach(0...rowsNum * columnsNum, id: \.self) { i in
                Text("H")
            }
        })
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
