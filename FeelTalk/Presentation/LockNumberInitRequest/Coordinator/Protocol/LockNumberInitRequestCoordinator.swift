//
//  LockNumberInitRequestCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/16.
//

import UIKit

protocol LockNumberInitRequestCoordinator: Coordinator {
    var lockNumberInitRequestVC: LockNumberInitRequestViewController { get set }
    
    func dismiss()
}
