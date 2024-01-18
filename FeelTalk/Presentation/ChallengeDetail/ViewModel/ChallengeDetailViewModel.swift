//
//  ChallengeDetailViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard

final class ChallengeDetailViewModel {
    private weak var coordiantor: ChallengeDetailCoordinator?
    private let challengeUseCase: ChallengeUseCase
    private let disposeBag = DisposeBag()
    
    let modelObserver = ReplayRelay<Challenge?>.create(bufferSize: 1)
    let typeObserver = ReplayRelay<ChallengeDetailViewType>.create(bufferSize: 1)
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapNavigationButton: Observable<ChallengeDetailNavigationBarButtonType>
        let titleObserver: ControlProperty<String>
        let deadlineObserver: BehaviorRelay<Date>
        let contentObserver: ControlProperty<String>
        let alertRightButtonTapObserver: Observable<CustomAlertType>
        let challengeButtonTapObserver: Observable<Void>
        let tapToolbarButton: Observable<ChallengeDetailViewToolBarType>
    }
    
    struct Output {
        let keyboardHeight = BehaviorRelay<CGFloat>(value: 0.0)
        let type = PublishRelay<ChallengeDetailViewType>()
        let popUpAlerObserver = PublishRelay<CustomAlertType>()
        let isNewTypeChallengeButtonEnabled = PublishRelay<Bool>()
        let focusedInputView = PublishRelay<ChallengeDetailViewScrollDirection>()
        let title = PublishRelay<String>()
        let deadline = PublishRelay<String>()
        let content = PublishRelay<String>()
    }
    
    init(coordinator: ChallengeDetailCoordinator, challengeUseCase: ChallengeUseCase) {
        self.coordiantor = coordinator
        self.challengeUseCase = challengeUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        let inputInfoObserver = Observable
            .combineLatest(input.titleObserver.asObservable(),
                           input.deadlineObserver.asObservable(),
                           input.contentObserver.asObservable()) { (title: $0, deadline: $1, content: $2) }
        
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0.0 <= $0 }
            .bind(to: output.keyboardHeight)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .asObservable()
            .withLatestFrom(typeObserver)
            .withUnretained(self)
            .bind { vm, type in
                output.type.accept(type)
            }.disposed(by: disposeBag)
        
        input.tapNavigationButton
            .filter { $0 == .modify }
            .withUnretained(self)
            .bind { vm, _ in
                print("tap modify button")
            }.disposed(by: disposeBag)
        
        // 챌린지 추가 페이지에서 pop 버튼을 눌렀을 경우
        input.tapNavigationButton
            .filter { $0 == .pop }
            .withLatestFrom(typeObserver)
            .filter { $0 == .new }
            .withLatestFrom(input.deadlineObserver)
            .compactMap { Date.compareDate(target: $0, from: Date()) }
            .withLatestFrom(inputInfoObserver) { (title: $1.title, dateCompare: $0, content: $1.content) }
            .map { event -> Bool in
                !event.title.isEmpty ? true :
                event.dateCompare != .same ? true :
                event.content == ChallengeContentViewNameSpace.contentInputViewPlaceholder ? false :
                event.content.count > 0 ? true : false
            }.withUnretained(self)
            .bind { vm, event in
                if event {
                    output.popUpAlerObserver.accept(.deregisterChallenge)
                } else {
                    vm.coordiantor?.pop()
                }
            }.disposed(by: disposeBag)
    
        input.tapNavigationButton
            .filter { $0 == .remove }
            .withUnretained(self)
            .bind { vm, _ in
                print("tap remove button")
            }.disposed(by: disposeBag)
        
        input.alertRightButtonTapObserver
            .filter { $0 == .deregisterChallenge }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordiantor?.pop()
            }.disposed(by: disposeBag)
        
        // 챌린지 추가 페이지에서 Challenge 버튼 상태 처리
        inputInfoObserver
            .withLatestFrom(typeObserver) { (inputInfo: $0, type: $1) }
            .filter { $0.type == .new }
            .map { $0.inputInfo }
            .map { event -> Bool in
                !event.title.isEmpty &&
                event.content != ChallengeContentViewNameSpace.contentInputViewPlaceholder &&
                event.content.count > 0 ? true: false
            }.distinctUntilChanged()
            .bind(to: output.isNewTypeChallengeButtonEnabled)
            .disposed(by: disposeBag)
            
        // 챌린지 추가
        input.challengeButtonTapObserver
            .withLatestFrom(typeObserver)
            .filter { $0 == .new }
            .withLatestFrom(inputInfoObserver)
            .map { (title: $0.title, deadline: Date.dateToStr($0.deadline), content: $0.content) }
            .withUnretained(self)
            .bind { vm, model in
                vm.challengeUseCase.addChallenge(model: model)
                    .bind { challengeChat in
                        print(challengeChat)
                        print("채팅방으로 이동")
                    }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.tapToolbarButton
            .filter { $0 == .title || $0 == .deadline }
            .map { event -> ChallengeDetailViewScrollDirection in
                event == .title ? .deadline : .content
            }.bind(to: output.focusedInputView)
            .disposed(by: disposeBag)
        
        input.tapToolbarButton
            .filter { $0 == .content }
            .withLatestFrom(inputInfoObserver)
            .map { event -> String in event.title }
            .map { event -> ChallengeDetailViewScrollDirection in
                event.isEmpty ? .title : .none
            }.bind(to: output.focusedInputView)
            .disposed(by: disposeBag)

        return output
    }
}
