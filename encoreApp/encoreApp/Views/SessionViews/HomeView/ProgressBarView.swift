//
//  ProgressBarView.swift
//  encoreApp
//
//  Created by Etienne Köhler on 01.07.20.
//  Copyright © 2020 NikolaiEtienne. All rights reserved.
//

import SwiftUI

struct ProgressBarView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var playerStateVM: PlayerStateVM
    var isWide: Bool
    var width: CGFloat { isWide ? UIScreen.main.bounds.width : UIScreen.main.bounds.width * 0.8 }
    var updateFrequency_ms: CGFloat = 100
    let timer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(self.colorScheme == .dark ? Color("darkgray") : Color.gray)
                .frame(width: width, height: 4.0)
                .cornerRadius(isWide ? 0 : 5)
            Rectangle()
                .foregroundColor(Color("purpleblue"))
                .frame(width: width * (playerStateVM.songTimestamp_ms / CGFloat(playerStateVM.song.duration_ms)), height: 4.0)
                .animation(.easeOut(duration: 0.6))
                .cornerRadius(isWide ? 0 : 5)
                .onReceive(timer) { _ in
                    //if song is playing, increment the progressBar
                    if self.playerStateVM.isPlaying {
                        self.playerStateVM.songTimestamp_ms += self.updateFrequency_ms
                    }
                }
        }.padding(.bottom)
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var duration_ms: Int = 50000
    static var previews: some View {
        ProgressBarView(playerStateVM: PlayerStateVM(userVM: UserVM()), isWide: false)
    }
}
