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
        VStack {
            Spacer()

            ForEach(Range(0...2)) { i in
                HStack {
                    Spacer()
                    ForEach(Range(0...2)) { j in
                        Button(action: {
                            self.isClicked.toggle()
                            
                            if isClicked {
                                self.count += 1
                            } else {
                                self.count -= 1
                            }
                        }) {
                            if isClicked {
                                Image("redcandy").resizable().frame(width: 50, height:50, alignment: .center)
                            } else {
                                Image("redcandy").resizable().frame(width: 50, height:50, alignment: .center)
                                    .background(Color.yellow)
                            }
                        }
//                        Button {
//                            self.isClicked.toggle()
//
//                            if isClicked {
//                                self.count += 1
//                            } else {
//                                self.count -= 1
//                            }
//                        } {
//                            if isClicked {
//                                Image("redcandy").resizable().frame(width: 50, height:50, alignment: .center)
//                                    .aspectRatio(contentMode: .fit)
//                            } else {
//                                Text(count)
//                            }
//                        }
                        Spacer()
                    }
                }
                Spacer()

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
