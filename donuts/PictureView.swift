//
//  PictureView.swift
//  donuts
//
//  Created by Rosa Sun on 2020-11-10.
//

import SwiftUI

struct PictureView: View {
    var body: some View {
        ZStack {
            Image("cookies")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.top)
            VStack{
                HStack {
                    Text("Hardcore\nAvo Toast")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .font(.title)
                    Spacer()
                    Image("heart").resizable()
                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                }
                .padding(.horizontal, 38.0)
                
                Spacer()
                Text("Energize with this healthy and hearty breakfast")
                    .foregroundColor(.white)
                    .font(.system(size: 13))
                    .padding(.bottom)
            }
        }
    }
}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView()
            
            
    }
}
