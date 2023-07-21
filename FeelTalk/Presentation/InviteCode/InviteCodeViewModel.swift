//
//  InviteCodeViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import Foundation
import RxSwift
import RxCocoa

protocol InviteCodeViewControllable: AnyObject {
    func performTransition(_ inviteCodeViewModel: InviteCodeViewModel, to transition: InviteCodeFlow)
}

final class InviteCodeViewModel {
    private let coupleUseCase: CoupleUseCase
    weak var controllable: InviteCodeViewControllable?
    
    private let disposBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: ControlEvent<Bool>
    }
    
    struct Output {
        let inviteCode: PublishRelay<String> = PublishRelay<String>()
    }
    
    init(inviteCodeControllable: InviteCodeViewControllable, coupleUseCase: CoupleUseCase) {
        print("InviteCodeViewModel")
        self.controllable = inviteCodeControllable
        self.coupleUseCase = coupleUseCase
    }
    
    func transfer(input: Input) -> Output {
        print("transfer")
        let output = Output()
        
        input.viewDidLoad
            .withUnretained(self)
            .bind { vm, _ in
                print("hello")
                vm.coupleUseCase.getInviteCode()
                    .bind(to: output.inviteCode)
                    .disposed(by: vm.disposBag)
            }.disposed(by: disposBag)
        
        return output
    }
}


