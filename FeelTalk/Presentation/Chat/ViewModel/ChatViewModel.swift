//
//  ChatViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/10.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard

final class ChatViewModel {
    weak var coordinator: ChatCoordinator?
    private let userUseCase: UserUseCase
    private let chatUseCase: ChatUseCase
    private let disposeBag = DisposeBag()
    
    private let partnerNickname = PublishRelay<String>()
    private let keyboardHeight = PublishRelay<CGFloat>()
    private let inputMode = BehaviorRelay<ChatInputMode>(value: .basics)
    private let isFunctionActive = BehaviorRelay<Bool>(value: false)
    private let pageNo = PublishSubject<Int>()

    private let chatCellHeightList = PublishSubject<[CGFloat]>()
    
    struct Input {
        let tapInputButton: Observable<Void>
        let messageText: Observable<String>
        let tapFunctionButton: Observable<Void>
        let viewWillAppear: ControlEvent<Bool>
    }
    
    struct Output {
        let keyboardHeight: PublishRelay<CGFloat>
        let inputMode: BehaviorRelay<ChatInputMode>
        let isFunctionActive: BehaviorRelay<Bool>
        let partnerNickname: PublishRelay<String>
    }
    
    init(coordinator: ChatCoordinator, userUseCase: UserUseCase, chatUseCase: ChatUseCase) {
        self.coordinator = coordinator
        self.userUseCase = userUseCase
        self.chatUseCase = chatUseCase
    }
    
    func transfer(input: Input) -> Output {
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { $0 >= 0 }
            .withUnretained(self)
            .bind { vm, keyboardHeight in
                vm.keyboardHeight.accept(keyboardHeight)
            }.disposed(by: disposeBag)
        
        input.viewWillAppear
            .withUnretained(self)
            .bind { vm, _ in
                vm.chatUseCase.getLastPageNo()
                    .bind(onNext: {
                        print($0)
                    }).disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.tapInputButton
            .withLatestFrom(inputMode)
            .withUnretained(self)
            .bind { vm, mode in
                switch mode {
                case .basics:
                    vm.inputMode.accept(.recordingDescription)
                    vm.isFunctionActive.accept(true)
                case .recordingDescription:
                    vm.inputMode.accept(.recording)
                    vm.isFunctionActive.accept(true)
                case .recording:
                    vm.inputMode.accept(.recorded)
                    vm.isFunctionActive.accept(true)
                case .recorded:
                    vm.inputMode.accept(.basics)
                    vm.isFunctionActive.accept(false)
                case .inputMessage:
                    break
                }
            }.disposed(by: disposeBag)
        
        input.messageText
            .map { $0.isEmpty }
            .map { $0 ? ChatInputMode.basics : ChatInputMode.inputMessage }
            .distinctUntilChanged()
            .bind(to: inputMode)
            .disposed(by: disposeBag)
        
        input.tapFunctionButton
            .withLatestFrom(isFunctionActive)
            .scan(false) { lastState, newState in !lastState }
            .bind(to: isFunctionActive)
            .disposed(by: disposeBag)
            
        return Output(keyboardHeight: self.keyboardHeight,
                      inputMode: self.inputMode,
                      isFunctionActive: self.isFunctionActive,
                      partnerNickname: self.partnerNickname)
    }
}
