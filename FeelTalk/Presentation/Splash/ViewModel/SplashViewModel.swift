//
//  SplashViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/21.
//

import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel {
    private weak var coordinator: SplashCoordinator?
    private let userUseCase: UserUseCase
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
    }
    
    struct Output {
        
    }
    
    init(coordinator: SplashCoordinator, userUseCase: UserUseCase) {
        self.coordinator = coordinator
        self.userUseCase = userUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .withUnretained(self)
            .bind { vm, _ in
                
            }.disposed(by: disposeBag)
        
        return output
    }
}
