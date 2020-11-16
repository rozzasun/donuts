//
//  ContentView.swift
//  donuts
//
//  Created by Rosa Sun on 2020-10-01.
//

import SwiftUI

struct ContentView: View {
    @State private var isClicked = true
    @State private var count = 0
    var body: some View {
        GameView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
