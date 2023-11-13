//
//  HomeViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    private weak var coordinator: HomeCoordinator?
    private let questionUseCase: QuestionUseCase
    private let disposeBag = DisposeBag()
    
    let todayQuestion = PublishRelay<Question>()
    let partnerSignalModel = BehaviorRelay<Signal>(value: Signal(type: .ambiguous))     // TODO: PublishRelay로 변경
    let mySignalModel = BehaviorRelay<Signal>(value: Signal(type: .refuse))             // TODO: PublishRelay로 변경
    let popUpToastMessage = PublishRelay<Void>()
    let showBottomSheet = PublishRelay<Void>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapAnswerButton: ControlEvent<Void>
        let tapMySignalButton: ControlEvent<Void>
    }
    
    struct Output {
        let todayQuestion: PublishRelay<Question>
        let partenrSignalModel: BehaviorRelay<Signal>   // TODO: PublishRelay로 변경
        let mySignalModel: BehaviorRelay<Signal>        // TODO: PublishRelay로 변경
        let popUpToastMessage: PublishRelay<Void>
        let showBottomSheet: PublishRelay<Void>
    }
    
    init(coordinator: HomeCoordinator, qustionUseCase: QuestionUseCase) {
        self.coordinator = coordinator
        self.questionUseCase = qustionUseCase
    }
    
    func transfer(input: Input) -> Output {
        input.viewWillAppear
            .withUnretained(self)
            .bind { vm, _ in
                vm.questionUseCase.getTodayQuestion()
                    .asObservable()
                    .bind(to: vm.todayQuestion)
                    .disposed(by: vm.disposeBag)
                vm.coordinator?.signalModel.accept(Signal(type: .sexy))
                // TODO: 내 시그널 가져오기
                // TODO: 파트너 시그널 가져오기
            }.disposed(by: disposeBag)
        
        coordinator?.signalModel
            .bind(to: mySignalModel)
            .disposed(by: disposeBag)
        
        coordinator?.reloadData
            .withUnretained(self)
            .bind { vm, _ in
                print("다시 서버 호출")
            }.disposed(by: disposeBag)
        
        input.tapAnswerButton
            .asObservable()
            .withLatestFrom(todayQuestion)
            .map { (isMyAnswer: $0.isMyAnswer, isPartnerAnswer: $0.isPartnerAnswer) }
            .filter { $0.isMyAnswer && !$0.isPartnerAnswer }
            .withUnretained(self)
            .bind { vm, _ in
                vm.popUpToastMessage.accept(())
            }.disposed(by: disposeBag)
        
        input.tapMySignalButton
            .asObservable()
            .withLatestFrom(mySignalModel)
            .withUnretained(self)
            .bind { vm, signal in
                vm.coordinator?.showSignalFlow()
                vm.coordinator?.signalModel.accept(signal)
            }.disposed(by: disposeBag)
        
        return Output(todayQuestion: self.todayQuestion,
                      partenrSignalModel: self.partnerSignalModel,
                      mySignalModel: self.mySignalModel,
                      popUpToastMessage: self.popUpToastMessage,
                      showBottomSheet: self.showBottomSheet)
    }
}
