//
//  WithdrawalDetailCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import UIKit

protocol WithdrawalDetailCoordinator: Coordinator {
    var withdrawalDetailViewController: WithdrawalDetailViewController { get set }
    
    func pop()
}
