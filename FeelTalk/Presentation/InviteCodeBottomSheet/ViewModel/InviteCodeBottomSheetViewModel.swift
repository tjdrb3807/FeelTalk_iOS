//
//  BottomSheetViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/22.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard

protocol InviteCodeBottomSheetViewControllable: AnyObject {
    func performTransition(_ bottomSheetViewModel: InviteCodeBottomSheetViewModel, to transition: InviteCodeBottomSheetFlow)
}

final class InviteCodeBottomSheetViewModel {
    private let coupleUseCase: CoupleUseCase
    weak var controllable: InviteCodeBottomSheetViewControllable?
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let inputInviteCode: ControlProperty<String>
        let tapConnectionButton: ControlEvent<Void>
    }
    
    struct Output {
        let keyboardHeight: BehaviorRelay<CGFloat> = BehaviorRelay<CGFloat>(value: 0.0)
        let connectionButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    }
    
    init(bottomSheetControllable: InviteCodeBottomSheetViewControllable, coupleUseCase: CoupleUseCase) {
        self.controllable = bottomSheetControllable
        self.coupleUseCase = coupleUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0 <= $0 }
            .withUnretained(self)
            .bind { vm, keyboardHeight in
                output.keyboardHeight.accept(keyboardHeight)
            }.disposed(by: disposeBag)
        
        input.inputInviteCode
            .map { text in text.count > 0 ? true : false }
            .bind(to: output.connectionButtonEnabled)
            .disposed(by: disposeBag)
        
        input.tapConnectionButton
            .withLatestFrom(input.inputInviteCode)
            .withUnretained(self)
            .bind { vm, inviteCode in
                vm.coupleUseCase.registerInviteCode(inviteCode)
            }.disposed(by: disposeBag)
        
        CoupleRegistrationObserver.shared.registerCompletedListener { [self] in
            controllable?.performTransition(self, to: .main)
        }
        
        return output
    }
}


