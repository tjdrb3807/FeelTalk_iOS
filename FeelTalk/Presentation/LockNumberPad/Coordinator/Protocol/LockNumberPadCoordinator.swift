//
//  LockNumberPadCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import UIKit
import RxSwift
import RxCocoa

protocol LockNumberPadCoordinator: Coordinator {
    var lockNumberPadVC: LockNumberPadViewController { get set }
    
    var lockNumberNV: UINavigationController { get set }
    
    var viewType: PublishRelay<LockNumberPadViewType> { get set }
    
    func showLockNumberHintFlow(type: LockNumberHintViewType, with password: String?)
    
    func dismiss()
}
