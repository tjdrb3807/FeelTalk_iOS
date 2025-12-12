//
//  HomeViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import Foundation
import RxSwift
import RxRelay

enum HomeModelReloadType {
    case signal
    case todayQuestion
}

final class HomeViewModel {
    // MARK: - Dependencies
    private weak var coordinator: HomeCoordinator?
    private let questionUseCase: QuestionUseCase
    private let signalUseCase: SignalUseCase
    private let disposeBag = DisposeBag()
    private let fcmHandeler = FCMHandler.shared
    
    // MARK: - Internal State (Output Sources)
    // UI 업데이트에 사용되는 내부 상태 스트림. 외부에서는 Observable 형태로만 노출됨.
    private let todayQuestion = PublishRelay<Question>()
    private let mySignal = PublishRelay<Signal>()
    private let partnerSignal = PublishRelay<Signal>()
    private let showBottomSheet = PublishRelay<Void>()
    
    // MARK: - External System Event Input
    // FCM, ChildCoordinator 등 외부 시스템에서 값을 주입하는 Input 스트림.
    // View Input과 성격이 다르므로 별도로 관리한다.
    let reloadObservable = PublishRelay<HomeModelReloadType>()
    
    // MARK: - Input / Output Definitions
    struct Input {
        let viewWillAppear: Observable<Bool>
        let tapAnswerButton: Observable<Void>
        let tapMySignalButton: Observable<Void>
        let tapChatRoomButton: Observable<Void>
    }
    
    struct Output {
        let todayQuestion: Observable<Question>
        let mySignal: Observable<Signal>
        let partnerSignal: Observable<Signal>
        let showBottomSheet: Observable<Void>
    }
    
    // MARK: - Initialization
    init(coordinator: HomeCoordinator, qustionUseCase: QuestionUseCase, signalUseCase: SignalUseCase) {
        self.coordinator = coordinator
        self.questionUseCase = qustionUseCase
        self.signalUseCase = signalUseCase
    }
    
    // MARK: - Transform (Core Business Logic)
    // Input 스트림을 기반으로 Output 스트림을 생성하는 핵심 처리 함수.
    func transform(input: Input) -> Output {
        // MARK: System-driven reload (e.g., FCM, ChildCoordinator Event)
        // 외부 시스템에서 들어오는 reload 이벤트에 따라 필요한 모델만 갱신한다.
        reloadObservable
            .withUnretained(self)
            .bind { vm, type in
                switch type {
                case .signal:
                    vm.signalUseCase.getMySignal()
                        .bind { model in
                            vm.mySignal.accept(model)
                            vm.showBottomSheet.accept(())
                        }.disposed(by: vm.disposeBag)
                case .todayQuestion:
                    vm.questionUseCase.getTodayQuestion()
                        .asObservable()
                        .bind(to: vm.todayQuestion)
                        .disposed(by: vm.disposeBag)
                }
            }.disposed(by: disposeBag)
        
//        input.viewWillAppear
////            .take(1)
//            .withUnretained(self)
//            .bind { vm, _ in
//                vm.questionUseCase.getTodayQuestion()
//                    .asObservable()
//                    .bind(to: vm.todayQuestion)
//                    .disposed(by: vm.disposeBag)
//                
//                vm.signalUseCase.getMySignal()
//                    .bind(to: vm.mySignal)
//                    .disposed(by: vm.disposeBag)
//                
//                vm.signalUseCase.getPartnerSignal()
//                    .bind(to: vm.partnerSignal)
//                    .disposed(by: vm.disposeBag)
//            }.disposed(by: disposeBag)
        
        // MARK: - View Input Handlers
                
        // 1. "답변하기" 버튼 탭 → Coordinator를 통해 Answer Flow 시작
        input.tapAnswerButton
            .asObservable()
            .withLatestFrom(todayQuestion)
            .withUnretained(self)
            .bind { vm, model in
                vm.coordinator?.showAnswerFlow()
                vm.coordinator?.model.accept(model)
            }.disposed(by: disposeBag)

        // 2. 내 시그널 버튼 탭 → Signal Flow 시작
        input.tapMySignalButton
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showSignalFlow()
            }.disposed(by: disposeBag)
        
        // 3. 채팅 탭 → Chat Flow 시작
        input.tapChatRoomButton
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showChatFlow()
            }.disposed(by: disposeBag)
        
        // MARK: Output 생성
        // 내부 Relay → 외부에서는 Observable 형태로만 제공하여 캡슐화 유지.
        return Output(todayQuestion: self.todayQuestion.asObservable(),
                      mySignal: self.mySignal.asObservable(),
                      partnerSignal: self.partnerSignal.asObservable(),
                      showBottomSheet: self.showBottomSheet.asObservable())
    }
}
