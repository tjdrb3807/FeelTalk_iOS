//
//  HomeViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import Foundation
import RxSwift
import RxCocoa

enum HomeModelReloadType {
    case signal
    case todayQuestion
}

final class HomeViewModel {
    private weak var coordinator: HomeCoordinator?
    private let questionUseCase: QuestionUseCase
    private let signalUseCase: SignalUseCase
    private let disposeBag = DisposeBag()
    let fcmHandeler = FCMHandler.shared
    
    let todayQuestion = PublishRelay<Question>()
    let mySignal = PublishRelay<Signal>()
    let partnerSignal = PublishRelay<Signal>()
    let reloadObservable = PublishRelay<HomeModelReloadType>()
    let showBottomSheet = PublishRelay<Void>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapAnswerButton: ControlEvent<Void>
        let tapMySignalButton: ControlEvent<Void>
        let tapChatRoomButton: ControlEvent<Void>
    }
    
    struct Output {
        let todayQuestion: PublishRelay<Question>
        let mySignal: PublishRelay<Signal>
        let partnerSignal: PublishRelay<Signal>
        let showBottomSheet: PublishRelay<Void>
    }
    
    init(coordinator: HomeCoordinator, qustionUseCase: QuestionUseCase, signalUseCase: SignalUseCase) {
        self.coordinator = coordinator
        self.questionUseCase = qustionUseCase
        self.signalUseCase = signalUseCase
    }
    
    func transfer(input: Input) -> Output {
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
        
        input.viewWillAppear
//            .take(1)
            .withUnretained(self)
            .bind { vm, _ in
                vm.questionUseCase.getTodayQuestion()
                    .asObservable()
                    .bind(to: vm.todayQuestion)
                    .disposed(by: vm.disposeBag)
                
                vm.signalUseCase.getMySignal()
                    .bind(to: vm.mySignal)
                    .disposed(by: vm.disposeBag)
                
                vm.signalUseCase.getPartnerSignal()
                    .bind(to: vm.partnerSignal)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.tapAnswerButton
            .asObservable()
            .withLatestFrom(todayQuestion)
            .withUnretained(self)
            .bind { vm, model in
                vm.coordinator?.showAnswerFlow()
                vm.coordinator?.model.accept(model)
            }.disposed(by: disposeBag)
        
        input.tapMySignalButton
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showSignalFlow()
            }.disposed(by: disposeBag)
        
        input.tapChatRoomButton
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showChatFlow()
            }.disposed(by: disposeBag)
        
        return Output(todayQuestion: self.todayQuestion,
                      mySignal: self.mySignal,
                      partnerSignal: self.partnerSignal,
                      showBottomSheet: self.showBottomSheet)
    }
}
