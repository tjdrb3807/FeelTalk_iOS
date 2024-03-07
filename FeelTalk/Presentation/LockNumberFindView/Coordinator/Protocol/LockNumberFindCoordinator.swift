//
//  LockNumberFindCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/15.
//

import UIKit

protocol LockNumberFindCoordinator: Coordinator {
    var lockNumberFindVC: LockNumberFindViewController { get set }
    
    func dismiss()
}
