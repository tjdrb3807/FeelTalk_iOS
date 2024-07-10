//
//  SignalCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignalCoordinator: Coordinator {
    var signalViewController: SignalViewController { get set }
    
    func finish()
    
    func dismiss()
    
    func dismissAndShowChatFlow()
}
