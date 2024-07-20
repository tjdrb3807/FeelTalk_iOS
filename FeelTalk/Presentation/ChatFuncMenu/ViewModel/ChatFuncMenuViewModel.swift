//
//  ChatFuncMenuViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/19.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class ChatFuncMenuViewModel {
    weak var coordinator: ChatFuncMenuCoordinator?
    private let questionUseCase: QuestionUseCase
    private let challengeUseCase: ChallengeUseCase
    private let disposeBag = DisposeBag()
    
    static let selectedQuestionModelObserver = BehaviorRelay<Question?>(value: nil)
    static let selectedChallengeModelObserver = BehaviorRelay<Challenge?>(value: nil)
    
    let displayCollectionViewCellRowObserver = BehaviorRelay<Int>(value: 0)
    let crtQuestionLatestPageNoObserver = BehaviorRelay<Int>(value: 0)
    let crtChallengeLatestPageNoObserver = BehaviorRelay<Int>(value: 0)
    let chatQuestionCellModelListObserver = BehaviorRelay<[ChatQuestionCellModel]>(value: [])
    let chatChallengeCellModelListObserver = BehaviorRelay<[ChatChallengeCellModel]>(value: [])
    let menuPageSectionObserver = BehaviorRelay<[ChatMenuSection]>(value: [
        ChatMenuSection(items: [ChatMenuSectionModel(cellModelList: [ChatQuestionSection(items: [])]),
                                ChatMenuSectionModel(cellModelList: [ChatChallengeSection(items: [])])])])
    
    struct Input {
        let viewWillAppearObserver: ControlEvent<Bool>
        let collectionViewContentOffsetObserver: ControlProperty<CGPoint>
        let shareButtonTapObserver: ControlEvent<Void>
        let dismissButtonTapObserver: ControlEvent<Void>
    }
    
    struct Output {
        let section = BehaviorRelay<[ChatMenuSection]>(value: [])
        let shareButtonState = PublishRelay<Bool>()
    }
    
    init(coordinator: ChatFuncMenuCoordinator, questionUseCase: QuestionUseCase, challengeUseCase: ChallengeUseCase) {
        self.coordinator = coordinator
        self.questionUseCase = questionUseCase
        self.challengeUseCase = challengeUseCase
    }
    
    typealias SelectedRow = (prevValue: Int?, crtValue: Int?)
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        crtQuestionLatestPageNoObserver
            .skip(1)
            .map { pageNo -> QuestionPage in QuestionPage(pageNo: pageNo) }
            .withUnretained(self)
            .bind { vm, event in
                vm.questionUseCase.getQuestionList(questionPage: event)
                    .map { list -> [ChatQuestionCellModel] in
                        var fetchModelList: [ChatQuestionCellModel] = []
                        list.forEach { question in fetchModelList.append(ChatQuestionCellModel(model: question, isTodayQuestion: false, isSelected: false)) }
                        return fetchModelList
                    }.bind(to: vm.chatQuestionCellModelListObserver)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)

        chatQuestionCellModelListObserver
            .skip(1)
            .withUnretained(self)
            .bind { vm, list in
                var prevPageSectionModelList = vm.menuPageSectionObserver.value
                guard var prevQuestionSectionModelList = prevPageSectionModelList[0].items[0].cellModelList as? [ChatQuestionSection] else { return }
                
                prevQuestionSectionModelList[0].items.append(contentsOf: list)
                prevQuestionSectionModelList[0].items[0].isTodayQuestion = true
                prevPageSectionModelList[0].items[0].cellModelList = prevQuestionSectionModelList
                
                vm.menuPageSectionObserver.accept(prevPageSectionModelList)
            }.disposed(by: disposeBag)
        
        chatQuestionCellModelListObserver
            .withLatestFrom(menuPageSectionObserver)
            .filter {
                guard let cell = $0[0].items[0].cellModelList[0] as? ChatQuestionSection else { return false }
                if cell.items.count <= 9 {
                    return true
                } else {
                    return false
                }
            }.withLatestFrom(crtQuestionLatestPageNoObserver)
            .filter { pageNo in pageNo > 0 }
            .map { crtPageNo in crtPageNo - 1 }
            .withUnretained(self)
            .bind { vm, pageNo in
                vm.crtQuestionLatestPageNoObserver.accept(pageNo)
            }.disposed(by: disposeBag)
        
        // 선택된 ChatQuestionCell 테두리 처리
        ChatFuncMenuViewModel.selectedQuestionModelObserver
            .skip(1)
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { vm, model in
                var prevPageSectionModelList = vm.menuPageSectionObserver.value
                guard var prevQuestionSectionModelList = prevPageSectionModelList[0].items[0].cellModelList as? [ChatQuestionSection] else { return }
                
                if model == nil {
                    for index in 0...prevQuestionSectionModelList[0].items.count - 1 {
                        if prevQuestionSectionModelList[0].items[index].isSelected {
                            prevQuestionSectionModelList[0].items[index].isSelected = false
                        }
                    }
                    ChatQuestionCVCell.selectedItemObserver.accept(nil)
                } else {
                    guard let indexPath = ChatQuestionCVCell.selectedItemObserver.value else { return }
                    for index in 0...prevQuestionSectionModelList[0].items.count - 1 {
                        if index == indexPath.row {
                            if prevQuestionSectionModelList[0].items[index].isSelected { // 이미 선택된 Cell을 Tap 했을 경우
                                prevQuestionSectionModelList[0].items[index].isSelected = false
                                ChatFuncMenuViewModel.selectedQuestionModelObserver.accept(nil)
                            } else { // 선택되지 않은 Cell을 Tap 했을 경우
                                prevQuestionSectionModelList[0].items[index].isSelected = true
                            }
                        } else { // 중복처리 방지
                            prevQuestionSectionModelList[0].items[index].isSelected = false
                        }
                    }
                }
                prevPageSectionModelList[0].items[0].cellModelList = prevQuestionSectionModelList
                vm.menuPageSectionObserver.accept(prevPageSectionModelList)
            }).disposed(by: disposeBag)
        
        crtChallengeLatestPageNoObserver
            .skip(1)
            .withUnretained(self)
            .bind { vm, event in
                vm.challengeUseCase.getChallengeList(type: .ongoing, pageNo: event)
                    .map { list -> [ChatChallengeCellModel] in
                        var fetchModelList: [ChatChallengeCellModel] = []
                        list.forEach { challenge in fetchModelList.append(ChatChallengeCellModel(model: challenge, isSelected: false)) }
                        return fetchModelList
                    }.bind(to: vm.chatChallengeCellModelListObserver)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        chatChallengeCellModelListObserver
            .skip(1)
            .withUnretained(self)
            .bind { vm, list in
                var prevPageSectionModelList = vm.menuPageSectionObserver.value
                guard var prevChallengeSectionModelList = prevPageSectionModelList[0].items[1].cellModelList as? [ChatChallengeSection] else { return }
                
                prevChallengeSectionModelList[0].items.append(contentsOf: list)
                prevPageSectionModelList[0].items[1].cellModelList = prevChallengeSectionModelList
                
                vm.menuPageSectionObserver.accept(prevPageSectionModelList)
            }.disposed(by: disposeBag)
        
        // 석택된 ChatChallengeCell 테두리 처리
        ChatFuncMenuViewModel.selectedChallengeModelObserver
            .skip(1)
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { vm, model in
                var prevPageSectionModelList = vm.menuPageSectionObserver.value
                guard var prevChallengeSectionModelList = prevPageSectionModelList[0].items[1].cellModelList as? [ChatChallengeSection] else { return }
                
                if prevChallengeSectionModelList[0].items.isEmpty { return } // 진행중인 챌린지가 없을경우
                
                if model == nil {
                    for index in 0...prevChallengeSectionModelList[0].items.count - 1 {
                        if prevChallengeSectionModelList[0].items[index].isSelected {
                            prevChallengeSectionModelList[0].items[index].isSelected = false
                        }
                    }
                    ChatChallengeCVCell.selectedItemObserver.accept(nil)
                } else {
                    guard let indexPath = ChatChallengeCVCell.selectedItemObserver.value else { return }
                    for index in 0...prevChallengeSectionModelList[0].items.count - 1 {
                        if index == indexPath.row {
                            if prevChallengeSectionModelList[0].items[index].isSelected { // 이미 선택된 Cell을 Tap 했을 경우
                                prevChallengeSectionModelList[0].items[index].isSelected = false
                                ChatFuncMenuViewModel.selectedChallengeModelObserver.accept(nil)
                            } else { // 선택되지 않은 Cell을 Tap 했을 경우
                                prevChallengeSectionModelList[0].items[index].isSelected = true
                            }
                        } else { // 중복선택 방지
                            prevChallengeSectionModelList[0].items[index].isSelected = false
                        }
                    }
                }
                prevPageSectionModelList[0].items[1].cellModelList = prevChallengeSectionModelList
                vm.menuPageSectionObserver.accept(prevPageSectionModelList)
            }).disposed(by: disposeBag)

        menuPageSectionObserver
            .skip(1)
            .bind(to: output.section)
            .disposed(by: disposeBag)
        
        ChatFuncMenuViewModel
            .selectedQuestionModelObserver
            .map { model -> Bool in model == nil ? false : true }
            .bind(to: output.shareButtonState)
            .disposed(by: disposeBag)
        
        ChatFuncMenuViewModel
            .selectedChallengeModelObserver
            .map { model -> Bool in model == nil ? false : true }
            .bind(to: output.shareButtonState)
            .disposed(by: disposeBag)
        
        input.viewWillAppearObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.questionUseCase.getLatestQuestionPageNo()
                    .map { model -> Int in model.pageNo }
                    .bind(to: vm.crtQuestionLatestPageNoObserver)
                    .disposed(by: vm.disposeBag)
                
                vm.challengeUseCase.getChallengeLatestPageNo(type: .ongoing)
                    .bind(to: vm.crtChallengeLatestPageNoObserver)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.collectionViewContentOffsetObserver
            .filter { offset in offset.x == 0.0 || offset.x == UIScreen.main.bounds.width }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { vm, event in
                switch event.x {
                case 0.0:
                    ChatFuncMenuViewModel.selectedChallengeModelObserver.accept(nil)
                    vm.displayCollectionViewCellRowObserver.accept(0)
                case UIScreen.main.bounds.width:
                    ChatFuncMenuViewModel.selectedQuestionModelObserver.accept(nil)
                    vm.displayCollectionViewCellRowObserver.accept(1)
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        input.shareButtonTapObserver
            .withLatestFrom(displayCollectionViewCellRowObserver)
            .withUnretained(self)
            .bind { vm, row in
                switch row {
                case 0:
                    guard let question = ChatFuncMenuViewModel.selectedQuestionModelObserver.value else { return }
                    print(question)
                    Task {
                        let questionChat = await vm.sendQuestionChat(question: question)
                        if questionChat != nil {
                            FCMHandler.shared.chatObservable.accept(questionChat!)
                            DispatchQueue.main.async {
                                vm.coordinator?.dismiss()
                            }
                        }
                    }
                case 1:
                    guard let challenge = ChatFuncMenuViewModel.selectedChallengeModelObserver.value else { return }
                    print(challenge)
                    Task {
                        let challengeChat = await vm.sendChallengeChat(challenge: challenge)
                        if challengeChat != nil {
                            FCMHandler.shared.chatObservable.accept(challengeChat!)
                            DispatchQueue.main.async {
                                vm.coordinator?.dismiss()
                            }
                        }
                    }
                default:
                    break
                }
            }.disposed(by: disposeBag)
        
        input.dismissButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
        
        return output
    }
}

extension ChatFuncMenuViewModel {
    func sendQuestionChat(question: Question) async -> QuestionChat? {
        return try? await withCheckedThrowingContinuation { continuation in
            Task {
                guard let url = URL(string: ClonectAPI.BASE_URL + "/api/v1/chatting-message/question") else {
                    continuation.resume(throwing: NSError(domain: "URL parsing error", code: 400))
                    return
                }
                
                var request = URLRequest(url: url)
                request.method = .post
                request.headers = HTTPHeaders(["Content-Type": "application/json", "Accept": "application/json"])
                guard let urlRequest = try? JSONEncoding().encode(request, with: ["index": question.index]) else {
                    continuation.resume(throwing: NSError(domain: "Request json encoding error", code: 200))
                    return
                }
                
                AF.request(
                    urlRequest,
                    interceptor: DefaultRequestInterceptor()
                )
                .responseDecodable(of: BaseResponseDTO<SendQuestionChatResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.status == "success" {
                            guard let data = result.data! else {
                                continuation.resume(throwing: NSError(domain: "Response data is nil", code: 400))
                                return
                            }
                            
                            let chatType: ChatType
                            if data.coupleQuestion.partnerAnswer != nil
                                && data.coupleQuestion.selfAnswer != nil {
                                chatType = .questionChatting
                            } else {
                                chatType = .answerChatting
                            }
                            
                            continuation.resume(
                                returning: QuestionChat(
                                    index: data.index,
                                    type: chatType,
                                    isRead: data.isRead,
                                    isMine: true,
                                    createAt: data.createAt,
                                    questionIndex: data.coupleQuestion.index,
                                    question: Question(
                                        index: question.index,
                                        pageNo: question.pageNo,
                                        title: question.title,
                                        header: question.header,
                                        body: question.body,
                                        highlight: question.highlight,
                                        myAnser: data.coupleQuestion.selfAnswer,
                                        partnerAnser: data.coupleQuestion.partnerAnswer,
                                        isMyAnswer: data.coupleQuestion.selfAnswer != nil,
                                        isPartnerAnswer: data.coupleQuestion.partnerAnswer != nil,
                                        createAt: question.title
                                    )
                                )
                            )
                        } else {
                            continuation.resume(throwing: NSError(domain: "server error", code: 400))
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    func sendChallengeChat(challenge: Challenge) async -> ChallengeChat? {
        return try? await withCheckedThrowingContinuation { continuation in
            Task {
                guard let url = URL(string: ClonectAPI.BASE_URL + "/api/v1/chatting-message/challenge") else {
                    continuation.resume(throwing: NSError(domain: "URL parsing error", code: 400))
                    return
                }
                
                var request = URLRequest(url: url)
                request.method = .post
                request.headers = HTTPHeaders(["Content-Type": "application/json", "Accept": "application/json"])
                guard let urlRequest = try? JSONEncoding().encode(request, with: ["index": challenge.index]) else {
                    continuation.resume(throwing: NSError(domain: "Request json encoding error", code: 200))
                    return
                }
                
                AF.request(
                    urlRequest,
                    interceptor: DefaultRequestInterceptor()
                )
                .responseDecodable(of: BaseResponseDTO<SendChallengeChatResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.status == "success" {
                            guard let data = result.data! else {
                                continuation.resume(throwing: NSError(domain: "Response data is nil", code: 400))
                                return
                            }
                            
                            continuation.resume(
                                returning: ChallengeChat(
                                    index: data.index,
                                    type: .challengeChatting,
                                    isRead: data.isRead,
                                    isMine: true,
                                    createAt: data.createAt,
                                    challengeIndex: data.coupleChallenge.index,
                                    challengeTitle: data.coupleChallenge.title,
                                    challengeDeadline: data.coupleChallenge.deadline,
                                    challenge: Challenge(
                                        index: data.coupleChallenge.index,
                                        pageNo: challenge.pageNo,
                                        title: data.coupleChallenge.title,
                                        deadline: data.coupleChallenge.deadline,
                                        content: data.coupleChallenge.content,
                                        creator: data.coupleChallenge.creator,
                                        isCompleted: challenge.isCompleted,
                                        completeDate: challenge.completeDate
                                    )
                                )
                            )
                        } else {
                            continuation.resume(throwing: NSError(domain: "server error", code: 400))
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}
