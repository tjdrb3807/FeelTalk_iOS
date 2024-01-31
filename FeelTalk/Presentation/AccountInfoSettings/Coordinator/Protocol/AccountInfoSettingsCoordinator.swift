//
//  AccountInfoSettingsCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import UIKit

protocol AccountInfoSettingsCoordinator: Coordinator {
    var accountInfoSettingsViewController: AccountInfoSettingsViewController { get set }
    
    func showWithdrawalFlow()
    
    func pop()
}
