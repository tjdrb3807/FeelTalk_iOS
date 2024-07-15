//
//  SignalChatItemView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/14.
//

import Foundation
import SwiftUI

struct SignalChatItemView: UIViewRepresentable {
    var signalType: SignalType
    
    func makeUIView(context: Context) -> some UIView {
        return SignalOpenGraph(type: signalType)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
