//
//  SoundTest.swift
//  FRUKTS
//
//  Created by Brian Fedelin on 5/30/21.
//

import SwiftUI
import AVFoundation

struct SoundTest: View {
    @State var audioPlayer: AVAudioPlayer!
    @Binding var isAlarm: Bool
    
    var body: some View {
        
        VStack {
            if(isAlarm == true){
                Text("WAKE UP")
                    .onAppear(){
                        self.audioPlayer.numberOfLoops=3600
                        self.audioPlayer.play()
                    }
            }
            Spacer()
            Button(action: {
                self.audioPlayer.pause()
            }) {
                Image(systemName: "pause.circle.fill").resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
            }
            Spacer()
        }
            .onAppear {
                let sound = Bundle.main.path(forResource: "boingg", ofType: "wav")
                self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            }
    }
    
}
