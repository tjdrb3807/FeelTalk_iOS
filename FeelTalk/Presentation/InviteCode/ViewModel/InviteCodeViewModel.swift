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
        let tapPresentBottomSheetViewButton: ControlEvent<Void>
    }
    
    struct Output {
        let inviteCode: PublishRelay<String> = PublishRelay<String>()
    }
    
    init(inviteCodeControllable: InviteCodeViewControllable, coupleUseCase: CoupleUseCase) {
        self.controllable = inviteCodeControllable
        self.coupleUseCase = coupleUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .withUnretained(self)
            .bind { vm, _ in
                vm.coupleUseCase.getInviteCode()
                    .bind(to: output.inviteCode)
                    .disposed(by: vm.disposBag)
            }.disposed(by: disposBag)
        
        input.tapPresentBottomSheetViewButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.controllable?.performTransition(vm, to: .bottomSheet)
            }.disposed(by: disposBag)
        
        return output
    }
}


