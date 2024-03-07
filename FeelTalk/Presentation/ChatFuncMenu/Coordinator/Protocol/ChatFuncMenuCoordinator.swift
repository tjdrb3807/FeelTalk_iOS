//
//  ChatFuncMenuCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/19.
//

import UIKit

protocol ChatFuncMenuCoordinator: Coordinator {
    var chatFuncMenuVC: ChatFuncMenuViewController { get set }
    
    func dismiss()
}
