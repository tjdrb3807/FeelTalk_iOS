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
import Alamofire

final class ChatViewModel {
    weak var coordinator: ChatCoordinator?
    private let userUseCase: UserUseCase
    private let chatUseCase: ChatUseCase
    private let signalUseCase: SignalUseCase
    private let questionUseCase: QuestionUseCase
    private let challengeUseCase: ChallengeUseCase
    private let disposeBag = DisposeBag()
    
    private let keyboardHeight = PublishRelay<CGFloat>()
    private let inputMode = BehaviorRelay<ChatInputMode>(value: .basics)
    private let isFunctionActive = BehaviorRelay<Bool>(value: false)
    
    private let chatCellHeightList = PublishSubject<[CGFloat]>()
    
    
    private let crtPageNoObserver = BehaviorRelay<Int>(value: -1)
    private let pageNo = PublishSubject<Int>()
    private let isLastPage = BehaviorRelay<Bool>(value: false)
    
    private let partnerNickname = PublishRelay<String>()
    private let partnerSignal = BehaviorRelay<Signal>(value: .init(type: .sexy))
    private let chatList = BehaviorRelay<[Chat]>(value: [])
    private let scrollToBottomCount = BehaviorRelay<Int>(value: 0)
    private let showTodayDivider = BehaviorRelay<Bool>(value: false)
    private let isPartnerInChat = BehaviorRelay<Bool>(value: false)
    
    private let isLoadingChatList = BehaviorRelay<Bool>(value: true)
    
    var input: Input
    var output: Output
    
    struct Input {
        let viewWillAppearObserver: Observable<Bool>
        let tapInputButton: Observable<Void>    // 채팅 전송, 보이스 녹음 버튼
        let messageText: Observable<String>
        let tapFunctionButton: Observable<Void> // +, X로 되어있는 이미지/카메라 뷰 표시 버튼
        let viewWillAppear: Observable<Bool>
        let tapDimmiedView: Observable<Void>    // 채팅 윗쪽 배경 회색 부분
        let tapChatRoomButton: Observable<Void> // 채팅 입장/나가기 버튼
        let chatFuncMenuButtonTapObserver: Observable<Void> // 질문/챌린지 공유 화면 이동 버튼
        let viewWillDisappear: Observable<Bool>
    }
    
    struct Output {
        let keyboardHeight: PublishRelay<CGFloat>
        let inputMode: BehaviorRelay<ChatInputMode>
        let isFunctionActive: BehaviorRelay<Bool>
        let partnerNickname: PublishRelay<String>
        let partnerSignal: BehaviorRelay<Signal>
        let chatList: BehaviorRelay<[Chat]>
        let scrollToBottomCount: BehaviorRelay<Int>
        let showTodayDivider: BehaviorRelay<Bool>
        let isLastPage: BehaviorRelay<Bool>
        let isLoadingChatList: BehaviorRelay<Bool>
        let isPartnerInChat: BehaviorRelay<Bool>
    }
    
    init(
        coordinator: ChatCoordinator?,
        userUseCase: UserUseCase,
        chatUseCase: ChatUseCase,
        signalUseCase: SignalUseCase,
        questionUseCase: QuestionUseCase,
        challengeUseCase: ChallengeUseCase
    ) {
        self.coordinator = coordinator
        self.userUseCase = userUseCase
        self.chatUseCase = chatUseCase
        self.signalUseCase = signalUseCase
        self.questionUseCase = questionUseCase
        self.challengeUseCase = challengeUseCase
        self.input = Input(
            viewWillAppearObserver: Observable<Bool>.empty(),
            tapInputButton: Observable<Void>.empty(),
            messageText: Observable<String>.empty(),
            tapFunctionButton: Observable<Void>.empty(),
            viewWillAppear: Observable<Bool>.empty(),
            tapDimmiedView: Observable<Void>.empty(),
            tapChatRoomButton: Observable<Void>.empty(),
            chatFuncMenuButtonTapObserver: Observable<Void>.empty(),
            viewWillDisappear: Observable<Bool>.empty()
        )
        self.output = Output(
            keyboardHeight: self.keyboardHeight,
            inputMode: self.inputMode,
            isFunctionActive: self.isFunctionActive,
            partnerNickname: self.partnerNickname,
            partnerSignal: self.partnerSignal,
            chatList: self.chatList,
            scrollToBottomCount: self.scrollToBottomCount,
            showTodayDivider: self.showTodayDivider,
            isLastPage: self.isLastPage,
            isLoadingChatList: self.isLoadingChatList,
            isPartnerInChat: self.isPartnerInChat
        )
        
        // initialize output values
        initOutputs()
    }
    
    private let lock = NSLock()
    private func synchronize(action: () -> Void) {
        if lock.lock(before: Date().addingTimeInterval(10)) {
            action()
            lock.unlock()
        } else {
            print("Took to long to lock, avoiding deadlock by ignoring the lock")
            action()
        }
    }
    
    private func getNoSecondDate(_ date: String?) -> String? {
        guard let date = date else { return date }
        let startIndex = date.startIndex
        guard let endIndex = date.lastIndex(of: ":") else {
            return date
        }
        return String(date[startIndex..<endIndex])
    }
    
    private func initOutputs() {
        userUseCase.getPartnerInfo()
            .withUnretained(self)
            .bind(onNext: { vm, partnerInfo in
                vm.partnerNickname.accept(partnerInfo.nickname)
            }).disposed(by: self.disposeBag)
        
        signalUseCase.getPartnerSignal()
            .withUnretained(self)
            .bind { vm, partnerSignal in
                vm.partnerSignal.accept(partnerSignal)
            }.disposed(by: self.disposeBag)
        
        chatUseCase.getLastPageNo()
            .withUnretained(self)
            .bind(onNext: { vm, pageNo in
                vm.isLoadingChatList.accept(true)
                vm.crtPageNoObserver.accept(pageNo)
            })
            .disposed(by: self.disposeBag)
        
        crtPageNoObserver
            .withUnretained(self)
            .bind { vm, pageNo in
                if !self.isLoadingChatList.value {
                    print("에러 발생으로 인한 crtPageNoObserver 값 수정은 처리 안 함")
                    return
                }
                
                let isLastPage = pageNo == 0
                self.isLastPage.accept(isLastPage)
                
                if pageNo < 0 {
                    self.isLoadingChatList.accept(false)
                    return
                }
                
                vm.chatUseCase.getChatList(pageNo: pageNo)
                    .withUnretained(self)
                    .subscribe(onNext: { vm, list in
                        if list.isEmpty && vm.chatList.value.isEmpty {
                            vm.showTodayDivider.accept(true)
                        } else {
                            vm.showTodayDivider.accept(false)
                        }
                        
                        Task {
                            var newList = await vm.loadChatProperties(chatList: list)
                            newList.sort { first, second in
                                if first.createAt == second.createAt {
                                    return first.index < second.index
                                } else {
                                    return first.createAt < second.createAt
                                }
                            }
                            vm.synchronize {
                                var updated = self.chatList.value
                                if var first = updated.first {
                                    let isBottomSame = first.isMine == newList.last?.isMine && vm.getNoSecondDate(first.createAt) == vm.getNoSecondDate(newList.last?.createAt)
                                    
                                    if isBottomSame {
                                        first.updateCount += 1
                                        updated[0] = first
                                    }
                                }
                                vm.chatList.accept(
                                    newList + updated
                                )
                            }
                            
                            vm.isLoadingChatList.accept(false)
                        }
                    }, onError: { error in
                        vm.isLoadingChatList.accept(false)
                        vm.crtPageNoObserver.accept(vm.crtPageNoObserver.value + 1)
                    })
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        FCMHandler.shared.chatObservable
            .asObservable()
            .withUnretained(self)
            .bind { vm, newChat in
                Task {
                    var newList: [Chat] = []
                    newList.append(newChat)
                    let withProperties = await vm.loadChatProperties(chatList: newList)
                    vm.synchronize {
                        var updated = self.chatList.value
                        if var last = updated.last {
                            let isTopSame = last.isMine == newChat.isMine && vm.getNoSecondDate(last.createAt) == vm.getNoSecondDate(newChat.createAt)
                            
                            if isTopSame {
                                last.updateCount += 1
                                updated[updated.count - 1] = last
                            }
                        }
                        vm.chatList.accept(updated + withProperties)
                    }
                }
            }.disposed(by: disposeBag)
        
        FCMHandler.shared.partnerChatRoomStatusObservable
            .asObservable()
            .withUnretained(self)
            .bind { vm, isInChat in
                print("isPartnerInChat: \(isInChat)")
                vm.isPartnerInChat.accept(isInChat)
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
            .bind { vm, appear in
                if appear {
                    Task {
                        await vm.changeChatRoomStatus(isInChat: true)
                    }
                }
            }.disposed(by: disposeBag)
        
        input.viewWillDisappear
            .withUnretained(self)
            .bind { vm, disappear in
                FCMHandler.shared.meIsInChatObsesrvable.accept(!disappear)
                if disappear {
                    Task {
                        await vm.changeChatRoomStatus(isInChat: false)
                    }                }
            }.disposed(by: disposeBag)
        
        // 전송/녹음 버튼
        input.tapInputButton
            .withLatestFrom(inputMode)
            .withUnretained(self)
            .bind { vm, mode in
                switch mode {
                case .basics:               // 기본 상태 (텍스트 입력칸 + 마이크 아이콘)
                    vm.inputMode.accept(.recordingDescription)
                    vm.isFunctionActive.accept(true)
                case .recordingDescription: // 텍스트 입력칸 제한 + 음성 녹음 설명
                    vm.inputMode.accept(.recording)
                    vm.isFunctionActive.accept(true)
                case .recording:            // 녹음 중 (Visualizer + 녹음 중지 버튼)
                    vm.inputMode.accept(.recorded)
                    vm.isFunctionActive.accept(true)
                case .recorded:             // 녹음 완료 (Visualizer + 보이스 채팅 전송 버튼)
                    vm.inputMode.accept(.basics)
                    vm.isFunctionActive.accept(false)
                    // TODO: send voice chat
                case .inputMessage:         // 텍스트 채팅 전송 버튼 (텍스트 입력시)
                    vm.inputMode.accept(.basics)
                    break
                }
            }.disposed(by: disposeBag)
        
        
//        // input button을 클릭했을 때, inputMode가 .inputMessage라면
//        // 텍스트 채팅 전송
//        input.tapInputButton
//            .withLatestFrom(inputMode)
//            .filter { $0 == .inputMessage }
//            .withLatestFrom(input.messageText)
//            .withUnretained(self)
//            .bind { vm, message in
//                Task {
//                    guard let newChat = try? await vm.sendTextChat(message: message)
//                    else { return }
//                    
//                    var newList: [Chat] = []
//                    newList.append(newChat)
//                    
//                    vm.synchronize {
//                        var updated = self.chatList.value
//                        if var last = updated.last {
//                            let isTopSame = last.isMine == newChat.isMine && vm.getNoSecondDate(last.createAt) == vm.getNoSecondDate(newChat.createAt)
//                            
//                            if isTopSame {
//                                last.updateCount += 1
//                                updated[updated.count - 1] = last
//                            }
//                        }
//                        vm.chatList.accept(updated + newList)
//                        
//                        // scroll to bottom after some delay (ui update delay)
//                    }
//                }
//            }.disposed(by: disposeBag)
        
        // 입력된 텍스트가 존재하면 inputMessage mode로 전환
        // 없으면 basic mode로 전환
        input.messageText
            .map { $0.isEmpty }
            .map { $0 ? ChatInputMode.basics : ChatInputMode.inputMessage }
            .distinctUntilChanged()
            .bind(to: inputMode)
            .disposed(by: disposeBag)
        
        
        // 카메라/이미지 선택창
        input.tapFunctionButton
            .withLatestFrom(isFunctionActive)
            .withUnretained(self)
            .bind { vm, isActive in
                vm.isFunctionActive.accept(!isActive)
            }.disposed(by: disposeBag)
//        input.tapFunctionButton
//            .withLatestFrom(isFunctionActive)
//            .scan(false) { lastState, newState in !lastState }
//            .bind(to: isFunctionActive)
//            .disposed(by: disposeBag)
        
        // 채팅 닫기
        Observable
            .merge(input.tapDimmiedView,
                   input.tapChatRoomButton)
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.finish()
            }.disposed(by: disposeBag)
        
        // 질문/챌린지 공유 페이지 띄우기
        input.chatFuncMenuButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showChatFuncMenuFlow()
            }.disposed(by: disposeBag)
        
        return self.output
    }
    
    func changeFunctionActive(isActive: Bool) {
        self.isFunctionActive.accept(isActive)
    }
    
    
    
    
    func loadNextPageChatList() {
        if self.isLastPage.value {
            return
        } else if self.isLoadingChatList.value {
            return
        } else {
            isLoadingChatList.accept(true)
            crtPageNoObserver.accept(crtPageNoObserver.value - 1)
        }
    }
    
    func loadChatProperties(chatList: [Chat]) async -> [Chat] {
        return await withTaskGroup(of: Chat.self, body: { [self] group in
            for chat in chatList {
                group.addTask {
                    do {
                        switch chat.type {
                        case .addChallengeChatting,
                                .challengeChatting,
                                .completeChallengeChatting:
                            var c = chat as! ChallengeChat
                            c.challenge = try await self.loadChallenge(challengeIndex: c.challengeIndex)
                            return c
                        case .answerChatting,
                                .questionChatting:
                            var c = chat as! QuestionChat
                            c.question = try await self.loadQuestion(questionIndex: c.questionIndex)
                            return c
                        case .voiceChatting:
                            var c = chat as! VoiceChat
                            c.voiceFile = try await self.loadVoiceData(url: c.voiceURL)
                            return c
                        case .imageChatting:
                            var c = chat as! ImageChat
                            c.uiImage = try await self.loadImage(url: c.imageURL)
                            return c
                        default:
                            return chat
                        }
                    } catch {
                        return chat
                    }
                }
            }
            
            var newList: [Chat] = []
            for await c in group {
                newList.append(c)
            }
            return newList
        })
    }
    
    func navigateToAnswer(questionIndex: Int) {
        print("미구현: navigateToAnswer()")
    }
    
    func navigateToChallenge(challengeIndex: Int) {
        print("미구현: navigateToChallenge()")
    }
    
    func navigateToImage(chat: ImageChat) {
        print("미구현: navigateToImage()")
    }
    
    func scrollToBottom() {
        scrollToBottomCount.accept(
            scrollToBottomCount.value + 1
        )
    }
}


// MARK: api implementations
extension ChatViewModel {
    func sendTextChat(message: String) async throws -> TextChat? {
        for try await textChat in chatUseCase.sendTextChat(text: message)
            .asObservable().values {
            return textChat
        }
        return nil
    }
    
    func loadQuestion(questionIndex: Int) async throws -> Question? {
        for try await question in questionUseCase
            .getQuestion(index: questionIndex)
            .asObservable()
            .values {
            return question
        }
        return nil
    }
    
    func loadChallenge(challengeIndex: Int) async throws -> Challenge? {
        for try await challenge in challengeUseCase
            .getChallenge(index: challengeIndex)
            .asObservable()
            .values {
            return challenge
        }
        return nil
    }
    
    func loadImage(url: String) async throws -> UIImage {
        return try await withCheckedThrowingContinuation({ continuation in
            Task {
                guard let url = URL(string: url) else {
                    continuation.resume(returning: UIImage())
                    return
                }
                let request = AF.request(url, method: .get)
                request.responseData { response in
                    switch response.result {
                    case .success(let data):
                        guard let image = UIImage(data: data) else {
                            continuation.resume(returning: UIImage())
                            return
                        }
                        continuation.resume(returning: image)
                    case .failure(_):
                        continuation.resume(returning: UIImage())
                    }
                }
            }
        })
    }
    
    func loadVoiceData(url: String) async throws -> Data? {
        return try await withCheckedThrowingContinuation({ continuation in
            Task {
                guard let url = URL(string: url) else {
                    continuation.resume(returning: nil)
                    return
                }
                let request = AF.request(url, method: .get)
                request.responseData { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(_):
                        continuation.resume(returning: nil)
                    }
                }
            }
        })
    }
    
    func resetPartnerPassword(chatIndex: Int) async throws -> Bool {
        return try await withCheckedThrowingContinuation({ continuation in
            Task {
                guard let url = URL(string: ClonectAPI.BASE_URL + "/api/v1/chatting-room/reset-password") else {
                    continuation.resume(throwing: NSError(domain: "URL parsing error", code: 200))
                    return
                }
                
                var request = URLRequest(url: url)
                request.method = .post
                request.headers = HTTPHeaders(["Content-Type": "application/json", "Accept": "application/json"])
                guard let urlRequest = try? JSONEncoding().encode(request, with: ["chattingMessageIndex": chatIndex]) else {
                    continuation.resume(throwing: NSError(domain: "Request json encoding error", code: 200))
                    return
                }
                
                AF.request(
                    urlRequest,
                    interceptor: DefaultRequestInterceptor()
                )
                .responseDecodable(of: BaseResponseDTO<ResetPartnerPasswordDTO?>.self) { response in
                    print("resetPartnerPassword(): \(response)")
                    switch response.result {
                    case .success(let data):
                        if let isExpired = data.data??.isExpired {
                            continuation.resume(returning: isExpired)
                        } else {
                            continuation.resume(throwing: NSError(domain: "isExpired is nil", code: 200))
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        })
    }
    
    func changeChatRoomStatus(isInChat: Bool) async -> Bool {
        return await withCheckedContinuation({ continuation in
            Task {
                guard let url = URL(string: ClonectAPI.BASE_URL + "/api/v1/member/chatting-room-status") else {
                    continuation.resume(returning: false)
                    return
                }
                
                var request = URLRequest(url: url)
                request.method = .put
                request.headers = HTTPHeaders(["Content-Type": "application/json", "Accept": "application/json"])
                guard let urlRequest = try? JSONEncoding().encode(request, with: ["isInChat": isInChat]) else {
                    continuation.resume(returning: false)
                    return
                }
                
                AF.request(
                    urlRequest,
                    interceptor: DefaultRequestInterceptor()
                )
                .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(_):
                        continuation.resume(returning: true)
                    case .failure(_):
                        continuation.resume(returning: false)
                    }
                }
            }
        })
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
        createAt: "2024-01-02T12:00:00",
        voiceURL: ""
    ),
    VoiceChat(
        index: 9,
        type: .voiceChatting,
        isRead: false,
        isMine: false,
        createAt: "2024-01-02T12:00:00",
        voiceURL: ""
    ),
    
    // image chat
    ImageChat(
        index: 10,
        type: .imageChatting,
        isRead: false,
        isMine: true,
        createAt: "2024-01-02T12:00:00",
        imageURL: "",
        uiImage: UIImage(named: "test1")
    ),
    ImageChat(
        index: 11,
        type: .imageChatting,
        isRead: false,
        isMine: false,
        createAt: "2024-01-02T12:00:00",
        imageURL: "",
        uiImage: UIImage(named: "test2")
    ),
    
    // challenge chat
    ChallengeChat(
        index: 12,
        type: .challengeChatting,
        isRead: false,
        isMine: true,
        createAt: "2024-01-02T12:00:00",
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
        createAt: "2024-01-02T12:00:00",
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
        createAt: "2024-01-02T12:00:00",
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
        createAt: "2024-01-02T12:00:00",
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
        createAt: "2024-01-02T12:00:00",
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
        createAt: "2024-01-02T12:00:00",
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
        createAt: "2024-01-03T12:00:00",
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
        createAt: "2024-01-03T12:00:00",
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
        createAt: "2024-01-03T12:00:00",
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
        createAt: "2024-01-03T12:00:00",
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
    
    // long text chat
    TextChat(
        index: 22,
        type: .textChatting,
        isRead: false,
        isMine: true,
        createAt: "2024-01-03T12:00:00",
        text: "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
    ),
    TextChat(
        index: 23,
        type: .textChatting,
        isRead: false,
        isMine: false,
        createAt: "2024-01-03T12:00:00",
        text: "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
    )
]
