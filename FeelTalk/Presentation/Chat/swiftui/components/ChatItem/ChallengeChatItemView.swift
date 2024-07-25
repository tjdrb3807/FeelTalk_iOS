//
//  ChallengeChatItemView.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/15.
//

import Foundation
import UIKit
import SwiftUI

struct ChallengeChatItemView: UIViewRepresentable {
    var chat: ChallengeChat
    var onClickButton: () -> Void
    
    func makeUIView(context: Context) -> some UIView {
        let v = ChallengeOpenGraph {
            onClickButton()
        }
        v.modelObserver.accept(
            ChallengeChat(
                index: chat.index,
                type: chat.type,
                isRead: chat.isRead,
                isMine: chat.isMine,
                createAt: chat.createAt,
                challengeIndex: chat.challengeIndex,
                challengeTitle: chat.challengeTitle,
                challengeDeadline: chat.challengeDeadline
            )
        )
        
        return v
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
