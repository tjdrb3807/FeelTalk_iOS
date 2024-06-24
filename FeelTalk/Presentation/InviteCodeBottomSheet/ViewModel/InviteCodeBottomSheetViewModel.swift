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

final class InviteCodeBottomSheetViewModel {
    private weak var coordinator: InviteCodeBottomSheetCoordinator?
    private let coupleUseCase: CoupleUseCase
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let inputInviteCode: ControlProperty<String>
        let tapConnectionButton: ControlEvent<Void>
    }
    
    struct Output {
        let keyboardHeight: BehaviorRelay<CGFloat> = BehaviorRelay<CGFloat>(value: 0.0)
        let connectionButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    }
    
    init(coordinator: InviteCodeBottomSheetCoordinator, coupleUseCase: CoupleUseCase) {
        self.coordinator = coordinator
        self.coupleUseCase = coupleUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        // 키보드 높이
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0 <= $0 }
            .withUnretained(self)
            .bind { vm, keyboardHeight in
                output.keyboardHeight.accept(keyboardHeight)
            }.disposed(by: disposeBag)
        
        // connectionButton 활성화
        input.inputInviteCode
            .map { text in text.count > 0 ? true : false }
            .bind(to: output.connectionButtonEnabled)
            .disposed(by: disposeBag)
        
        // 커플 등록
        input.tapConnectionButton
            .withLatestFrom(input.inputInviteCode)
            .withUnretained(self)
            .bind { vm, inviteCode in
                vm.coupleUseCase.registerInviteCode(inviteCode)
                    .subscribe(
                        onSuccess: { state in
                            if state {
                                KeychainRepository.addItem(value: UserState.couple.rawValue, key: "userState")
                                vm.coordinator?.finish()
                            }
                        },
                        onFailure: { error in print(error.localizedDescription) },
                        onDisposed: nil)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        return output
    }
}


