//
//  InviteCodeCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import Foundation

protocol InviteCodeCoordinator: Coordinator {
    var inviteCodeViewController: InviteCodeViewController { get set }
    
    func showInviteCodeBottomSheetCoordinator()
}
