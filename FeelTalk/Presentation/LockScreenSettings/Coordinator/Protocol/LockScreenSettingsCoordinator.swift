//
//  LockScreenSettingsCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import UIKit

protocol LockScreenSettingsCoordinator: Coordinator {
    var lockScreenSettingsViewController: LockScreenSettingsViewController { get set }
    
    func showLockNumberPadFlow(with type: LockNumberPadViewType)
    
    func pop()
}
