//
//  ConfigurationSettingsCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import Foundation

protocol ConfigurationSettingsCoordinator: Coordinator {
    var configurationSettingsViewController: ConfigurationSettingsViewController { get set }
    
    func finish()
}
