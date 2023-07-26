//
//  NicknameCoordiantor.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/16.
//

import UIKit

enum nickNameFlow {
    case invietCode
}

protocol NicknameCoordinatorDependencies: AnyObject {
    func makeCoupleCodeViewController(_ nicknameCoordinator: NicknameCoordiantor)
}

final class NicknameCoordiantor: BaseCoordinator {
    weak var dependencies: NicknameCoordinatorDependencies?
    private var signUpInfo: SignUp?
    
    init(navigationController: UINavigationController, dependencies: NicknameCoordinatorDependencies, signUpInfo: SignUp?) {
        self.signUpInfo = signUpInfo
        super.init(navigationController: navigationController)
        self.dependencies = dependencies
        
    }
    
    override func start() {
        let viewModel = NicknameViewModel(nicknameControllable: self,
                                          signUpUseCase: DefaultSignUpUseCase(signUpRepository: DefaultSignUpRepository()))
        let vc = NicknameViewController.create(with: viewModel)
        vc.signUpInfo = signUpInfo
        
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension NicknameCoordiantor: NicknameViewControllable {
    func performTransition(_ nicknameViewModel: NicknameViewModel, to transition: nickNameFlow) {
        switch transition {
        case .invietCode:
            dependencies?.makeCoupleCodeViewController(self)
        }
    }
}
