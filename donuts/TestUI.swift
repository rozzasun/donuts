//
//  TestUI.swift
//  donuts
//
//  Created by Rosa Sun on 2020-11-15.
//

import SwiftUI

struct TestUI: View {

    @State var isActive:Bool = false
    @State var points: [CGPoint] = []


    var body: some View {
        ZStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.horizontal, 48)
                .padding(.vertical, 16)
                .background(Color.white)
                .cornerRadius(100)
                .shadow(color: Color.black, radius: 20, x: 0, y: 5)
                .offset(x: 0, y: isActive ? 10 : 0)
                .animation(.easeOut(duration: 0.2))
                .gesture(DragGesture(minimumDistance: 0)
                            .onChanged({ _ in
                                self.isActive = true
                            })
                            .onEnded({ _ in
                                self.isActive = false
                            }))

            Rectangle() // replace it with what you need
                            .foregroundColor(.red)
                            .edgesIgnoringSafeArea(.all)
                            .gesture(DragGesture().onChanged( { value in
                                self.addNewPoint(value)
                            })
                            .onEnded( { value in
                                // here you perform what you need at the end
                            }))


            DrawShape(points: points)
                .stroke(lineWidth: 5) // here you put width of lines
                .foregroundColor(.blue)
        }
    }

    private func addNewPoint(_ value: DragGesture.Value) {
            // here you can make some calculations based on previous points
            points.append(value.location)
        }
}

struct DrawShape: Shape {

    var points: [CGPoint]

    // drawing is happening here
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let firstPoint = points.first else { return path }

        path.move(to: firstPoint)
        for pointIndex in 1..<points.count {
            path.addLine(to: points[pointIndex])

        }
        return path
    }
}

struct TestUI_Previews: PreviewProvider {
    static var previews: some View {
        TestUI()
    }
}
