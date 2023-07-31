//
//  NicknameCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import Foundation

protocol NicknameCoordinator: Coordinator {
    func pushNicknameViewController(with data: SignUp)
    func showInviteCodeFlow()
    func popViewController()
}
