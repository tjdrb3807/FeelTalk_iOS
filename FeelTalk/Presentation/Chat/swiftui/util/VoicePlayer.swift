//
//  VoicePlayer.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/17.
//

import Foundation
import AVFAudio
import SwiftUI

class VoicePlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Binding var isPlaying: Bool
    @Binding var playTime: Int
    var audioPlayer: AVAudioPlayer? = nil
    var timer: Timer? = nil
    var voiceData: Data?
    var isBinded: Bool {
        get {
            voiceData != nil
        }
    }
    
    override init() {
        self._isPlaying = .constant(false)
        self._playTime = .constant(0)
    }
    
    func bind(voiceData: Data?, isPlaying: Binding<Bool>, playTime: Binding<Int>) {
        self.voiceData = voiceData
        self._isPlaying = isPlaying
        self._playTime = playTime
        
        if let audioPlayer = self.audioPlayer {
            self.isPlaying = audioPlayer.isPlaying
            self.playTime = Int(audioPlayer.currentTime)
        }
    }
    
    func startTimer() {
        cancelTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [self] timer in
            guard let audioPlayer = self.audioPlayer else {
                cancelTimer()
                return
            }
            
            if audioPlayer.isPlaying {
                playTime = Int(audioPlayer.currentTime)
            }
            
            let remainingTime = audioPlayer.duration - audioPlayer.currentTime
            if remainingTime <= 0 {
                cancelTimer()
                return
            }
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func playVoice() {
        guard let voiceData = self.voiceData else { return }
        do {
            if audioPlayer == nil {
                audioPlayer = try AVAudioPlayer(data: voiceData)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
            }
            audioPlayer?.play()
            startTimer()
            isPlaying = true
        } catch {
            stopVoice()
        }
    }
    
    func pauseVoice() {
        if isPlaying {
            audioPlayer?.pause()
            cancelTimer()
            isPlaying = false
        }
    }
    
    func stopVoice() {
        audioPlayer?.stop()
        audioPlayer = nil
        cancelTimer()
        playTime = 0
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playTime = 0
        isPlaying = false
    }
}
