//
//  LockingPasswordCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol LockingPasswordCoordinator: Coordinator {
    var lockingPasswordViewController: LockingPasswordViewController { get set }
    
    var viewMode: PublishRelay<LockingPasswordViewMode> { get set }
}
