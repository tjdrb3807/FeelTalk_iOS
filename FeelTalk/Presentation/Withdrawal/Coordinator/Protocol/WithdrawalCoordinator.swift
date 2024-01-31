//
//  WithdrawalCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import UIKit

protocol WithdrawalCoordiantor: Coordinator {
    var withdrawalViewController: WithdrawalViewController { get set }
    
    var withdrawalNavigationController: UINavigationController { get set }
    
    func showWithdrawalDetailFlow()
    
    func dismiss()
}
