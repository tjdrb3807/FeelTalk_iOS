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
    
    let modelObserver = ReplayRelay<Challenge>.create(bufferSize: 1)
    private let viewTypeObserver = PublishRelay<ChallengeDetailViewType>()
    private let title = BehaviorRelay<String>(value: "")
    private let deadline = BehaviorRelay<String>(value: Date.dateToStr(Date()))
    private let content = BehaviorRelay<String>(value: ChallengeContentViewNameSpace.contentInputViewPlaceholder)
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let tapNavigationButton: Observable<ChallengeDetailNavigationBarButtonType>
        let titleObserver: ControlProperty<String>
        let deadlineObserver: BehaviorRelay<Date>
        let contentObserver: ControlProperty<String>
        let alertRightButtonTapObserver: Observable<CustomAlertType>
        let challengeButtonTapObserver: Observable<Void>
        let tapToolbarButton: Observable<ChallengeDetailViewToolBarType>
        let tapBottomSheetConfirmButton: Observable<Void>
    }
    
    struct Output {
        let keyboardHeight = BehaviorRelay<CGFloat>(value: 0.0)
        let type = PublishRelay<ChallengeDetailViewType>()
        let popUpAlerObserver = PublishRelay<CustomAlertType>()
        let popUpBottomSheetObserver = PublishRelay<Void>()
        let isNewTypeChallengeButtonEnabled = PublishRelay<Bool>()
        let focusedInputView = PublishRelay<ChallengeDetailViewScrollDirection>()
        let navigationType = PublishRelay<ChallengeDetailViewType>()
        let descriptionType = PublishRelay<ChallengeDetailViewType>()
        let titleModel = PublishRelay<String>()
        let deadlineModel = PublishRelay<String>()
        let contentModel = PublishRelay<String>()
    }
    
    init(coordinator: ChallengeDetailCoordinator, challengeUseCase: ChallengeUseCase) {
        self.coordiantor = coordinator
        self.challengeUseCase = challengeUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()

        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0.0 <= $0 }
            .bind(to: output.keyboardHeight)
            .disposed(by: disposeBag)
        
        viewTypeObserver
            .bind(to: output.type)
            .disposed(by: disposeBag)
        
        // 초기 화면 설정
        input.viewWillAppear
            .take(1)
            .withLatestFrom(modelObserver) { (title: $1.title,
                                              deadline: $1.deadline,
                                              content: $1.content,
                                              isCompleted: $1.isCompleted)
            }.withUnretained(self)
            .bind { vm, model in
                guard let title = model.title,
                      let deadline = model.deadline,
                      let content = model.content,
                      let isCompleted = model.isCompleted else { return vm.viewTypeObserver.accept(.new) }
                
                isCompleted ? vm.viewTypeObserver.accept(.completed) : vm.viewTypeObserver.accept(.ongoing)
                
                vm.title.accept(title) // TODO: ouput에 연결시 input에서 가져오지못함... 수동처리
                output.titleModel.accept(title)
                output.deadlineModel.accept(deadline)
                output.contentModel.accept(content)
                
                if isCompleted {
                    // MARK: Mixpanel Navigate Page
                    MixpanelRepository.shared.openCompletedChallengeDetail()
                }
            }.disposed(by: disposeBag)
        
        input.titleObserver
            .bind(to: title)
            .disposed(by: disposeBag)
        
        input.deadlineObserver
            .map { Date.dateToStr($0) }
            .bind(to: deadline)
            .disposed(by: disposeBag)
        
        input.contentObserver
            .bind(to: content)
            .disposed(by: disposeBag)
        
        // 진행, 완료 페이지에서 pop 버튼 눌렀을 경우
        // alert 없이 ChallengeView로 pop
        input.tapNavigationButton
            .filter { $0 == .pop }
            .withLatestFrom(viewTypeObserver)
            .filter { $0 == .ongoing || $0 == .completed }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordiantor?.pop()
            }.disposed(by: disposeBag)
        
        // 신규 페이지에서 pop 버튼 눌렀을 경우
        // 변경사항이 있다면 alert 띄우기
        // 변경사항이 없다면 ChallengeView로 pop
        input.tapNavigationButton
            .filter { $0 == .pop }
            .withLatestFrom(viewTypeObserver)
            .filter { $0 == .new }
            .withLatestFrom(input.deadlineObserver)
            .compactMap { Date.compareDate(target: $0, from: Date()) }
            .map { [weak self] dateCompare -> Bool in
                guard let self = self else { return false }
                
                return !self.title.value.isEmpty ? true :
                dateCompare != .same ? true :
                self.content.value == ChallengeContentViewNameSpace.contentInputViewPlaceholder ? false :
                self.content.value.count > 0 ? true : false
            }.withUnretained(self)
            .bind { vm, event in
                event ? output.popUpAlerObserver.accept(.deregisterChallenge) : vm.coordiantor?.pop()
            }.disposed(by: disposeBag)

        // 수정 페이지에서 pop버튼을 눌렀을 경우
        // 무조건 alert 띄우기
        input.tapNavigationButton
            .filter { $0 == .pop }
            .withLatestFrom(viewTypeObserver)
            .filter { $0 == .modify }
            .map { _ -> CustomAlertType in .cancelCellengeModifications }
            .bind(to: output.popUpAlerObserver)
            .disposed(by: disposeBag)
            
        // 수정 페이지 전환
        input.tapNavigationButton
            .filter { $0 == .modify }
            .map { _ in ChallengeDetailViewType.modify }
            .bind(to: viewTypeObserver)
            .disposed(by: disposeBag)
        
        input.tapNavigationButton
            .filter { $0 == .remove }
            .map { _ -> CustomAlertType in .removeChallnege }
            .bind(to: output.popUpAlerObserver)
            .disposed(by: disposeBag)
        
        // 챌린지 등록 취소
        input.alertRightButtonTapObserver
            .filter { $0 == .deregisterChallenge }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordiantor?.pop()
            }.disposed(by: disposeBag)
        
        // 챌린지 수정 취소
        input.alertRightButtonTapObserver
            .filter { $0 == .cancelCellengeModifications }
            .withLatestFrom(modelObserver)
            .withUnretained(self)
            .bind { vm, model in
                guard let title = model.title,
                      let deadline = model.deadline,
                      let content = model.content else { return }
                
                output.titleModel.accept(title)
                output.deadlineModel.accept(deadline)
                output.contentModel.accept(content)
                vm.title.accept(title) // TODO: ouput에 연결시 input에서 가져오지못함... 수동처리
                vm.viewTypeObserver.accept(.ongoing)
            }.disposed(by: disposeBag)
        
        // 챌린지 등록
        input.challengeButtonTapObserver
            .withLatestFrom(viewTypeObserver)
            .filter { $0 == .new }
            .withLatestFrom(title)
            .withLatestFrom(input.deadlineObserver) { (title: $0, deadline: Date.dateToStr($1)) }
            .withLatestFrom(input.contentObserver) { (title: $0.title, deadline: $0.deadline, content: $1) }
            .withUnretained(self)
            .bind { vm, model in
                vm.challengeUseCase.addChallenge(model: model)
                    .bind { challengeChat in
                        vm.coordiantor?.finish(challengeViewReloadType: .addChallenge)
                        // TODO: 채팅에 Opengraph 띄우기
                    }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        // 챌린지 삭제
        input.alertRightButtonTapObserver
            .filter { $0 == .removeChallnege }
            .withLatestFrom(modelObserver)
            .compactMap { $0.index }
            .withLatestFrom(viewTypeObserver) { (index: $0, type: $1) }
            .withUnretained(self)
            .bind { vm, event in
                vm.challengeUseCase.removeChallenge(index: event.index)
                    .filter { $0 }
                    .bind { _ in
                        if event.type == .ongoing {
                            vm.coordiantor?.finish(challengeViewReloadType: .removeOngoingChallenge)
                        } else if event.type == .completed {
                            vm.coordiantor?.finish(challengeViewReloadType: .removeCompletedChallenge)
                        }
                    }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
            
        // 챌린지 수정
        input.challengeButtonTapObserver
            .withLatestFrom(viewTypeObserver)
            .filter { $0 == .modify }
            .withLatestFrom(modelObserver)
            .map { [weak self] preModel -> Challenge in
                guard let self = self else { return preModel }
                
                return Challenge(index: preModel.index,
                                 pageNo: preModel.pageNo,
                                 title: self.title.value,
                                 deadline: self.deadline.value,
                                 content: self.content.value,
                                 creator: preModel.creator,
                                 isCompleted: preModel.isCompleted)
            }.withUnretained(self)
            .bind { vm, model in
                vm.challengeUseCase.modifyChallenge(model: (index: model.index!,
                                                            title: model.title!,
                                                            deadline: model.deadline!,
                                                            content: model.content!))
                .filter { $0 }
                .bind { _ in
                    vm.modelObserver.accept(model)
                    vm.viewTypeObserver.accept(.ongoing)
                    ChallengeViewModel.reloadObserver.accept(.modifyChallenge)
                }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        // 챌린지 완료
        input.challengeButtonTapObserver
            .withLatestFrom(viewTypeObserver)
            .filter { $0 == .ongoing }
            .withLatestFrom(modelObserver)
            .compactMap { $0.index }
            .withUnretained(self)
            .bind { vm, index in
                vm.challengeUseCase.completeChallenge(index: index)
                    .bind { challengeChat in
                        print(challengeChat)
                        FCMHandler.shared.chatObservable.accept(challengeChat)
                        ChallengeViewModel.reloadObserver.accept(.completedChallenge)
                        output.popUpBottomSheetObserver.accept(())
                    }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.tapBottomSheetConfirmButton
            .delay(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordiantor?.finish(challengeViewReloadType: .none)
            }.disposed(by: disposeBag)
        
        // 등록 페이지에서 ChallengeButton 상태 처리
        Observable
            .combineLatest(input.titleObserver,
                           input.contentObserver) { (title: $0, content: $1) }
            .withLatestFrom(viewTypeObserver) { (inputInfo: $0, type: $1) }
            .filter { $0.type == .new }
            .map { $0.inputInfo }
            .map { info -> Bool in
                !info.title.isEmpty &&
                info.content != ChallengeContentViewNameSpace.contentInputViewPlaceholder &&
                !info.content.isEmpty ? true : false
            }.distinctUntilChanged()
            .bind(to: output.isNewTypeChallengeButtonEnabled)
            .disposed(by: disposeBag)
        
        input.tapToolbarButton
            .filter { $0 == .title || $0 == .deadline }
            .map { event -> ChallengeDetailViewScrollDirection in
                event == .title ? .deadline : .content
            }.bind(to: output.focusedInputView)
            .disposed(by: disposeBag)
        
        input.tapToolbarButton
            .filter { $0 == .content }
            .withLatestFrom(title)
            .map { event -> ChallengeDetailViewScrollDirection in
                event.isEmpty ? .title : .none
            }.bind(to: output.focusedInputView)
            .disposed(by: disposeBag)
        
        return output
    }
}
