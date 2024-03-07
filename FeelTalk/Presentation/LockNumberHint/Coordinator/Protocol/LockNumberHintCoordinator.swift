//
//  LockNumberHintCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/05.
//

import UIKit
import RxSwift
import RxCocoa

protocol LockNumberHintCoordinator: Coordinator {
    var lockNumberHintVC: LockNumberHintViewController { get set }
    
    var viewType: PublishRelay<LockNumberHintViewType> { get set }
    
    var initPWObserver: PublishRelay<String?> { get set }
    
    func showLockNumberFindFlow()
    
    func showLockNumberInitRequestFlow()
    
    func pop()
}

