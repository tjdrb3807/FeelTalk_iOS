//
//  PressForAnswerChatItemView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/14.
//

import Foundation
import UIKit
import SwiftUI

struct PressForAnswerChatItemView: UIViewRepresentable {
    var onClickButton: () -> Void
    
    func makeUIView(context: Context) -> some UIView {
        return PressForAnswerOpenGraph {
           onClickButton()
        }
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
