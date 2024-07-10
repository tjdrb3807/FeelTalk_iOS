//
//  Coordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import UIKit

enum CoordinatorType {
    case app
    case splash, onboarding
    case login, tab
    case home, question, challenge, myPage
    case signUp, adultAuth, newsAgency, authConsent, nickname, inviteCode, inviteCodeBottomSheet
    case answer, answered
    case challengeDetail
    case settingList, inquiry, suggestions
    case partnerInfo, breakUp
    case lockScreen, lockScreenSettings, lockNumberPad, lockNumberHint, lockNumberFind, lockNumberInitRequest
    case accountInfoSettings, withdrawal, withdrawalDetail
    case chat, chatFuncMenu, chatFromBottomSheet
    case alert
    case signal
}

protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorType { get }
    
    func start()
    func finish()
    func findCoordinator(type: CoordinatorType) -> Coordinator?
    
    init(_ navigationController: UINavigationController)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func findCoordinator(type: CoordinatorType) -> Coordinator? {
        var stack: [Coordinator] = [self]
        
        while !stack.isEmpty {
            let currentCoordinator = stack.removeLast()
            if currentCoordinator.type == type {
                return currentCoordinator
            }
            currentCoordinator.childCoordinators.forEach({ child in
                stack.append(child)
            })
        }
        return nil
    }
}
