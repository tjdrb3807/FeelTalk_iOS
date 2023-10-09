//
//  BreakUpCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import Foundation

protocol BreakUpCoordinator: Coordinator {
    var breakUpViewController: BreakUpViewController { get set }
    
    func dismiss()
}
