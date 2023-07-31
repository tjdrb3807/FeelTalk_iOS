//
//  SignUpCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import Foundation

protocol SignUpCoordinator: Coordinator {
    func showNicknameFlow(with signUp: SignUp)
}
