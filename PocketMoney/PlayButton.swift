//
//  PlayButton.swift
//  PocketMoney
//
//  Created by Euan Macfarlane on 12/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct PlayButton: View {
    @State var isPlaying: Bool
    
    var body: some View {
        Button(action: {
            withAnimation { self.isPlaying.toggle()}
        }) {
            Image(systemName: isPlaying ? "pause.circle" : "play.circle")
        }
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        //PlayButton(isPlaying: .constant(true))
        PlayButton(isPlaying: true)
    }
}
