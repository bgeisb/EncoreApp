//
//  CurrentSongView.swift
//  encoreApp
//
//  Created by Etienne Köhler on 30.06.20.
//  Copyright © 2020 NikolaiEtienne. All rights reserved.
//

import SwiftUI

struct CurrentSongView: View {
    @ObservedObject var playerStateVM: PlayerStateVM
    
    var albumWidth: CGFloat
//    var uiColorTopLeft: UIColor
//    var uiColorBottomRight: UIColor
//    var uiColorBottomLeft: UIColor
//    var uiColorTopRight: UIColor
    
    init(playerStateVM: PlayerStateVM) {
        self.playerStateVM = playerStateVM
        self.albumWidth = playerStateVM.albumCover.size.width
//        self.uiColorTopLeft = playerStateVM.albumCover.getPixelColor(pos: CGPoint(x: albumWidth * 0.2, y: albumWidth * 0.2))
//        self.uiColorBottomRight = playerStateVM.albumCover.getPixelColor(pos: CGPoint(x: albumWidth * 0.8, y: albumWidth * 0.8))
//        self.uiColorBottomLeft = playerStateVM.albumCover.getPixelColor(pos: CGPoint(x: albumWidth * 0.2,y: albumWidth * 0.8))
//        self.uiColorTopRight = playerStateVM.albumCover.getPixelColor(pos: CGPoint(x: albumWidth * 0.8, y: albumWidth * 0.2))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if playerStateVM.song.name != "" && playerStateVM.isPlaying {
                Text("Now playing")
                    .font(.caption2.bold())
                    .foregroundColor(Color("Gray01"))
                                     
                 Spacer()
                       
                
                    LottieView(lottieFile: "Sound_Visualizer", isPlaying: $playerStateVM.isPlaying)
                        .frame(width: 20, height: 20)
                }
            }
            HStack(spacing: 15) {
                // Cover
                ZStack {
                    Image(uiImage: self.playerStateVM.albumCover)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65, height: 65)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)
                    )

                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color("Gray06"), lineWidth: 3)
                }
                .compositingGroup()
                .frame(width: 65, height: 65)
                .shadow(color: Color(#colorLiteral(red: 0, green: 0.47843137383461, blue: 1, alpha: 0.25)), radius:25, x:0, y:4)
                
                VStack(alignment: .leading) {
                    // Artist
                    Text("\(self.playerStateVM.song.artists[0])")
                        .font(.caption.bold())
                        .foregroundColor(Color("Gray03"))
                    
                    // Title
                    Text("\(self.playerStateVM.song.name)")
                        .font(.headline.bold())
                }
                
                Spacer()
            }
            
            
//            Text("suggested by \(self.playerStateVM.song.suggested_by)")
//                .font(.system(size: 14, weight: .semibold))
//                .foregroundColor(Color("purpleblue"))
//                .padding(.top, 1)
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(
                    color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)),
                    radius:25, x:0, y:4
                )
        )
    }
}

struct CurrentSongView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSongView(playerStateVM: PlayerStateVM(userVM: UserVM()))
            .padding(.horizontal, 30)
    }
}
