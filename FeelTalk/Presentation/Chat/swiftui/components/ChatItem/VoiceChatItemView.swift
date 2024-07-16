//
//  VoiceChatItemView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/15.
//

import SwiftUI
import AVFAudio

struct VoiceChatItemView: View {
    @State var chat: VoiceChat
    @State var isPlaying = false
    @State var playTime = 0
    @State var voicePlayer = VoicePlayer()
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Button {
                if isPlaying {
                    voicePlayer.pauseVoice()
                } else {
                    voicePlayer.playVoice()
                }
            } label: {
                HStack(alignment: .center, spacing: 0) {
                    if isPlaying {
                        Image("icon_voice_pause")
                            .frame(width: 24, height: 24)
                    } else {
                        Image("icon_voice_play")
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(8)
                .frame(width: 40, height: 40, alignment: .center)
            }
            
            Text(playTimeText)
              .font(
                Font.custom(CommonFontNameSpace.pretendardSemiBold, size: 14)
                  .weight(.semibold)
              )
              .foregroundColor(.black)
              .frame(minWidth: 50, alignment: .center)
        }
        .padding(.leading, 4)
        .padding(.trailing, 16)
        .padding(.vertical, 12)
        .background(Color("gray_100"))
        .cornerRadius(16)
        .onAppear {
            voicePlayer.bind(
                voiceData: chat.voiceFile,
                isPlaying: $isPlaying,
                playTime: $playTime
            )
        }
        .onDisappear {
            voicePlayer.stopVoice()
        }
    }
    
    var playTimeText: String {
        get {
            let minutes = playTime / 60
            let seconds = playTime % 60
            
            let minutesString: String
            if minutes < 10 {
                minutesString = "0\(minutes)"
            } else {
                minutesString = "\(minutes)"
            }
            
            let secondsString: String
            if seconds < 10 {
                secondsString = "0\(seconds)"
            } else {
                secondsString = "\(seconds)"
            }
            
            return "\(minutesString):\(secondsString)"
        }
    }
    
}

struct VoiceChatItemView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceChatItemView(
            chat: VoiceChat(
                index: 9,
                type: .voiceChatting,
                isRead: false,
                isMine: false,
                createAt: "2024-01-01T12:00:00",
                voiceURL: ""
            )
        )
    }
}
