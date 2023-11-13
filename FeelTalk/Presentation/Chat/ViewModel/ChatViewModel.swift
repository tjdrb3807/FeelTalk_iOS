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
//    private let chatDataList:
    private let chatModelList = PublishRelay<[ChatModel]>()
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
        let chatModelList: PublishRelay<[ChatModel]>
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
                vm.userUseCase.getPartnerInfo()
                    .map { $0.nickname }
                    .bind(to: vm.partnerNickname)
                    .disposed(by: vm.disposeBag)
                vm.chatUseCase.getLatestChatPageNo()
                    .bind(to: vm.pageNo)
                    .disposed(by: vm.disposeBag)
                
                // MARK: TEST
                vm.chatModelList.accept([TextChatModel(index: 0,
                                                       type: .textChatting,
                                                       isMine: true,
                                                       isRead: true,
                                                       isSend: true,
                                                       createAt: "04:44",
                                                       chatLocation: .first,
                                                       message: "grapes vanilla carnival florence marshmallow cresent serendipity flutter like laptop way bijou lovable charming."),
                                         TextChatModel(index: 1,
                                                       type: .textChatting,
                                                       isMine: true,
                                                       isRead: true,
                                                       isSend: true,
                                                       createAt: "04:45",
                                                       chatLocation: .middle,
                                                       message: "안녕하세요"),
                                         TextChatModel(index: 2,
                                                       type: .textChatting,
                                                       isMine: true,
                                                       isRead: true,
                                                       isSend: true,
                                                       createAt: "04:45",
                                                       chatLocation: .last,
                                                       message: "제 이름은 전성규 입니다.")]
            )}.disposed(by: disposeBag)
        
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
        
        input.tapInputButton
            .withLatestFrom(inputMode)
            .filter { $0 == .inputMessage }
            .withLatestFrom(input.messageText)
            .withUnretained(self)
            .bind { vm, message in
                vm.chatUseCase.sendTextChat(message: message)
                    .bind(onNext: {
                        print($0)
                    }).disposed(by: vm.disposeBag)
                vm.inputMode.accept(.basics)
            }.disposed(by: disposeBag)
        
        input.tapFunctionButton
            .withLatestFrom(isFunctionActive)
            .scan(false) { lastState, newState in !lastState }
            .bind(to: isFunctionActive)
            .disposed(by: disposeBag)
            
        return Output(keyboardHeight: self.keyboardHeight,
                      inputMode: self.inputMode,
                      isFunctionActive: self.isFunctionActive,
                      partnerNickname: self.partnerNickname,
                      chatModelList: self.chatModelList)
    }
}
