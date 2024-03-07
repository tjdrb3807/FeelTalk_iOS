//
//  LockScreenCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/03.
//

import UIKit
import RxSwift
import RxCocoa

protocol LockScreenCoordinator: Coordinator {
    var lockScreenVC: LockScreenViewController { get set }
    
    var lockScreenNV: UINavigationController { get set }
    
    func showLockNumberPadFlow() 
}
