//
//  LockingSettingsCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/18.
//

import Foundation
import RxSwift
import RxCocoa

protocol LockingSettingsCoordinator: Coordinator {
    var lockingSettingViewController: LockingSettingViewController { get set }
    
    var lockTheScreenState: PublishRelay<Bool> { get set }
    
    var lockingPasswordViewMode: PublishRelay<LockingPasswordViewMode> { get set }
    
    func showLockingPasswordFlow()
}
