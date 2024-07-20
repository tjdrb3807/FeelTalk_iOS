//
//  ChatCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/10.
//

import UIKit

protocol ChatCoordinator: Coordinator {
    var chatViewController: ChatViewController { get set }
    
    var chatViewNC: UINavigationController { get set }
    
    func showChatFuncMenuFlow()
    
    func showAnswerSheetFlow(question: Question)
    
    func showChallengeDetailFlow(challenge: Challenge)
    
    func showImageDeatilFlow(chat: ImageChat, ownerNickname: String, ownerSignal: Signal)
    
    func showImageShareFlow(image: UIImage)
}
