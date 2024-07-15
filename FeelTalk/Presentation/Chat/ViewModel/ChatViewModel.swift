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
    private let signalUseCase: SignalUseCase
    private let disposeBag = DisposeBag()
    
    private let keyboardHeight = PublishRelay<CGFloat>()
    private let inputMode = BehaviorRelay<ChatInputMode>(value: .basics)
    private let isFunctionActive = BehaviorRelay<Bool>(value: false)
    
    private let chatCellHeightList = PublishSubject<[CGFloat]>()
    
    
    private let crtPageNoObserver = PublishRelay<Int>()
    private let pageNo = PublishSubject<Int>()
    
    private let partnerNickname = PublishRelay<String>()
    private let partnerSignal = BehaviorRelay<Signal>(value: .init(type: .sexy))
    private let chatList = BehaviorRelay<[Chat]>(value: [])
    private let scrollToBottomCount = BehaviorRelay<Int>(value: 0)
    
    var input: Input
    var output: Output
    
    struct Input {
        let viewWillAppearObserver: Observable<Bool>
        let tapInputButton: Observable<Void>
        let messageText: Observable<String>
        let tapFunctionButton: Observable<Void>
        let viewWillAppear: Observable<Bool>
        let tapDimmiedView: Observable<Void>
        let tapChatRoomButton: Observable<Void>
        let chatFuncMenuButtonTapObserver: Observable<Void>
    }
    
    struct Output {
        let keyboardHeight: PublishRelay<CGFloat>
        let inputMode: BehaviorRelay<ChatInputMode>
        let isFunctionActive: BehaviorRelay<Bool>
        let partnerNickname: PublishRelay<String>
        let partnerSignal: BehaviorRelay<Signal>
        let chatList: BehaviorRelay<[Chat]>
        let scrollToBottomCount: BehaviorRelay<Int>
    }
    
    init(
        coordinator: ChatCoordinator?,
        userUseCase: UserUseCase,
        chatUseCase: ChatUseCase,
        signalUseCase: SignalUseCase
    ) {
        self.coordinator = coordinator
        self.userUseCase = userUseCase
        self.chatUseCase = chatUseCase
        self.signalUseCase = signalUseCase
        self.input = Input(
            viewWillAppearObserver: Observable<Bool>.empty(),
            tapInputButton: Observable<Void>.empty(),
            messageText: Observable<String>.empty(),
            tapFunctionButton: Observable<Void>.empty(),
            viewWillAppear: Observable<Bool>.empty(),
            tapDimmiedView: Observable<Void>.empty(),
            tapChatRoomButton: Observable<Void>.empty(),
            chatFuncMenuButtonTapObserver: Observable<Void>.empty()
        )
        self.output = Output(
            keyboardHeight: self.keyboardHeight,
            inputMode: self.inputMode,
            isFunctionActive: self.isFunctionActive,
            partnerNickname: self.partnerNickname,
            partnerSignal: self.partnerSignal,
            chatList: self.chatList,
            scrollToBottomCount: self.scrollToBottomCount
        )
        
        // initialize output values
        initOutputs()
    }
    
    private func initOutputs() {
        chatList.accept(sampleChatList)
        
        userUseCase.getPartnerInfo()
            .bind(onNext: { partnerInfo in
                self.partnerNickname.accept(partnerInfo.nickname)
            }).disposed(by: self.disposeBag)
        
        signalUseCase.getPartnerSignal()
            .bind { partnerSignal in
                self.partnerSignal.accept(partnerSignal)
            }.disposed(by: self.disposeBag)
        
        chatUseCase.getLastPageNo()
            .bind(to: self.crtPageNoObserver)
            .disposed(by: self.disposeBag)
        
        crtPageNoObserver
            .withUnretained(self)
            .bind { vm, pageNo in
                vm.chatUseCase.getChatList(pageNo: 0)
                    .bind(onNext: {
                        print($0)
                    }).disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
    }
    
    func bind(input: Input) -> Output {
        self.input = input
        
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
//                vm.chatUseCase.getLastPageNo()
//                    .bind(to: vm.crtPageNoObserver)
//                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
//        crtPageNoObserver
//            .withUnretained(self)
//            .bind { vm, pageNo in
//                vm.chatUseCase.getChatList(pageNo: 0)
//                    .bind(onNext: {
//                        print($0)
//                    }).disposed(by: vm.disposeBag)
//            }.disposed(by: disposeBag)
        
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
        
        Observable
            .merge(input.tapDimmiedView,
                   input.tapChatRoomButton)
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.finish()
            }.disposed(by: disposeBag)
        
        input.chatFuncMenuButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showChatFuncMenuFlow()
            }.disposed(by: disposeBag)
        
        return self.output
    }

    
    func navigateToAnswer(questionIndex: Int) {
        print("미구현: navigateToAnswer()")
    }
    
    func navigateToChallenge(challengeIndex: Int) {
        print("미구현: navigateToChallenge()")
    }
    
    func resetPartnerPassword() {
        
    }
    
    func navigateToImage(chat: ImageChat) {
        
    }
    
    func scrollToBottom() {
        scrollToBottomCount.accept(
            scrollToBottomCount.value + 1
        )
    }
    
}

let sampleChatList: [any Chat] = [
    // text chat
    TextChat(
        index: 0,
        type: .textChatting,
        isRead: false,
        isMine: true,
        createAt: "2024-01-01T12:00:00",
        text: "텍스트 채팅"
    ),
    TextChat(
        index: 1,
        type: .textChatting,
        isRead: false,
        isMine: false,
        createAt: "2024-01-01T12:00:00",
        text: "텍스트 채팅"
    ),
    
    // signal chat
    SignalChat(
        index: 2,
        type: .signalChatting,
        isRead: false,
        isMine: true,
        createAt: "2024-01-01T12:00:00",
        signal: .sexy
    ),
    SignalChat(
        index: 3,
        type: .signalChatting,
        isRead: false,
        isMine: false,
        createAt: "2024-01-01T12:00:00",
        signal: .tired
    ),
    
    // press for answer chat
    PressForAnswerOpenGraphChat(
        index: 4,
        type: .pressForAnswerChatting,
        isRead: false,
        isMine: true,
        questionIndex: 0,
        createAt: "2024-01-01T12:00:00"
    ),
    PressForAnswerOpenGraphChat(
        index: 5,
        type: .pressForAnswerChatting,
        isRead: false,
        isMine: false,
        questionIndex: 0,
        createAt: "2024-01-01T12:00:00"
    ),
    
    // press for answer chat
    ResetPartenrPasswordChat(
        index: 6,
        type: .resetPartnerPasswordChatting,
        isRead: false,
        isMine: true,
        createAt: "2024-01-01T12:00:00"
    ),
    ResetPartenrPasswordChat(
        index: 7,
        type: .resetPartnerPasswordChatting,
        isRead: false,
        isMine: false,
        createAt: "2024-01-01T12:00:00"
    ),
    
    // voice chat
    VoiceChat(
        index: 8,
        type: .voiceChatting,
        isRead: false,
        isMine: true,
        createAt: "2024-01-01T12:00:00",
        voiceURL: ""
    ),
    VoiceChat(
        index: 9,
        type: .voiceChatting,
        isRead: false,
        isMine: false,
        createAt: "2024-01-01T12:00:00",
        voiceURL: ""
    ),
    
    // image chat
    ImageChat(
        index: 10,
        type: .imageChatting,
        isRead: false,
        isMine: true,
        createAt: "2024-01-01T12:00:00",
        imageURL: "",
        uiImage: UIImage(named: "test1")
    ),
    ImageChat(
        index: 11,
        type: .imageChatting,
        isRead: false,
        isMine: false,
        createAt: "2024-01-01T12:00:00",
        imageURL: "",
        uiImage: UIImage(named: "test2")
    ),
    
    // challenge chat
    ChallengeChat(
        index: 12,
        type: .challengeChatting,
        isRead: false,
        isMine: true,
        createAt: "2024-01-01T12:00:00",
        challengeIndex: 0,
        challengeTitle: "challenge title",
        challengeDeadline:"2024-01-01T12:00:00",
        challenge: Challenge(
            index: 0,
            pageNo: 0,
            title: "테스트 제목입니다.",
            deadline: "2024-01-23T10:00:00",
            content: "Hello",
            creator: "KakaoSG",
            isCompleted: false
        )
    ),
    ChallengeChat(
        index: 13,
        type: .challengeChatting,
        isRead: false,
        isMine: false,
        createAt: "2024-01-01T12:00:00",
        challengeIndex: 0,
        challengeTitle: "challenge title",
        challengeDeadline:"2024-01-01T12:00:00",
        challenge: Challenge(
            index: 0,
            pageNo: 0,
            title: "테스트 제목입니다.",
            deadline: "2024-01-23T10:00:00",
            content: "Hello",
            creator: "KakaoSG",
            isCompleted: false
        )
    ),
    
    // add challenge chat
    ChallengeChat(
        index: 14,
        type: .addChallengeChatting,
        isRead: false,
        isMine: true,
        createAt: "2024-01-01T12:00:00",
        challengeIndex: 0,
        challengeTitle: "challenge title",
        challengeDeadline:"2024-01-01T12:00:00",
        challenge: Challenge(
            index: 0,
            pageNo: 0,
            title: "테스트 제목입니다.",
            deadline: "2024-01-23T10:00:00",
            content: "Hello",
            creator: "KakaoSG",
            isCompleted: false
        )
    ),
    ChallengeChat(
        index: 15,
        type: .addChallengeChatting,
        isRead: false,
        isMine: false,
        createAt: "2024-01-01T12:00:00",
        challengeIndex: 0,
        challengeTitle: "challenge title",
        challengeDeadline:"2024-01-01T12:00:00",
        challenge: Challenge(
            index: 0,
            pageNo: 0,
            title: "테스트 제목입니다.",
            deadline: "2024-01-23T10:00:00",
            content: "Hello",
            creator: "KakaoSG",
            isCompleted: false
        )
    ),
    
    // complete challenge chat
    ChallengeChat(
        index: 16,
        type: .completeChallengeChatting,
        isRead: false,
        isMine: true,
        createAt: "2024-01-01T12:00:00",
        challengeIndex: 0,
        challengeTitle: "challenge title",
        challengeDeadline:"2024-01-01T12:00:00",
        challenge: Challenge(
            index: 0,
            pageNo: 0,
            title: "테스트 제목입니다.",
            deadline: "2024-01-23T10:00:00",
            content: "Hello",
            creator: "KakaoSG",
            isCompleted: false
        )
    ),
    ChallengeChat(
        index: 17,
        type: .completeChallengeChatting,
        isRead: false,
        isMine: false,
        createAt: "2024-01-01T12:00:00",
        challengeIndex: 0,
        challengeTitle: "challenge title",
        challengeDeadline:"2024-01-01T12:00:00",
        challenge: Challenge(
            index: 0,
            pageNo: 0,
            title: "테스트 제목입니다.",
            deadline: "2024-01-23T10:00:00",
            content: "Hello",
            creator: "KakaoSG",
            isCompleted: false
        )
    ),
    
    // question chat
    QuestionChat(
        index: 18,
        type: .questionChatting,
        isRead: false,
        isMine: true,
        createAt: "2024-01-01T12:00:00",
        questionIndex: 10,
        question: Question(
            index: 10,
            pageNo: 0,
            title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?",
            header: "난 이게 가장 좋더라!",
            body: "당신이 가장 좋아하는 스킨십은?",
            highlight: [0],
            myAnser: nil,
            partnerAnser: nil,
            isMyAnswer: false,
            isPartnerAnswer: false,
            createAt: "2024-01-01T12:00:00"
        )
    ),
    QuestionChat(
        index: 19,
        type: .questionChatting,
        isRead: false,
        isMine: false,
        createAt: "2024-01-01T12:00:00",
        questionIndex: 10,
        question: Question(
            index: 10,
            pageNo: 0,
            title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?",
            header: "난 이게 가장 좋더라!",
            body: "당신이 가장 좋아하는 스킨십은?",
            highlight: [0],
            myAnser: nil,
            partnerAnser: nil,
            isMyAnswer: false,
            isPartnerAnswer: false,
            createAt: "2024-01-01T12:00:00"
        )
    ),
    
    // answer chat
    QuestionChat(
        index: 20,
        type: .answerChatting,
        isRead: false,
        isMine: true,
        createAt: "2024-01-01T12:00:00",
        questionIndex: 10,
        question: Question(
            index: 10,
            pageNo: 0,
            title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?",
            header: "난 이게 가장 좋더라!",
            body: "당신이 가장 좋아하는 스킨십은?",
            highlight: [0],
            myAnser: nil,
            partnerAnser: nil,
            isMyAnswer: false,
            isPartnerAnswer: false,
            createAt: "2024-01-01T12:00:00"
        )
    ),
    QuestionChat(
        index: 21,
        type: .answerChatting,
        isRead: false,
        isMine: false,
        createAt: "2024-01-01T12:00:00",
        questionIndex: 10,
        question: Question(
            index: 10,
            pageNo: 0,
            title: "난 이게 가장 좋더라! 당신이 가장 좋아하는 스킨십은?",
            header: "난 이게 가장 좋더라!",
            body: "당신이 가장 좋아하는 스킨십은?",
            highlight: [0],
            myAnser: nil,
            partnerAnser: nil,
            isMyAnswer: false,
            isPartnerAnswer: false,
            createAt: "2024-01-01T12:00:00"
        )
    )
]
