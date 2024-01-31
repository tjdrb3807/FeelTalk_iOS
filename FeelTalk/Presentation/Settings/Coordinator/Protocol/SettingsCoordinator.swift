//
//  SettingsCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/29.
//

import Foundation

protocol SettingsCoordinator: Coordinator {
    var settingsViewController: SettingsViewController { get set }
    
    func showLockScreenSettingsFlow()
    
    func showAccountInfoSettingsFlow()
}
