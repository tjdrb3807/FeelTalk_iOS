//
//  ChallengeViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/14.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum ChallengeViewReloadType {
    case addChallenge
    case removeOngoingChallenge
    case removeCompletedChallenge
    case modifyChallenge
    case completedChallenge
    case none
}

final class ChallengeViewModel {
    static var isDetailViewPushed: Bool = true
    static let reloadObserver = PublishRelay<ChallengeViewReloadType>()
    private weak var coordinator: ChallengeCoordinator?
    private let challengeUseCase: ChallengeUseCase
    private let disposeBag = DisposeBag()
    
    private let currentOngoingChallengePageNo = PublishRelay<Int>()
    private let currentCompletedChallengePageNo = PublishRelay<Int>()
    private let ongoingChallengeModelList = BehaviorRelay<[Challenge]>(value: [])
    private let completedChallengeModelList = BehaviorRelay<[Challenge]>(value: [])
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapAddButton: ControlEvent<Void>
        let tapChallengeCell: Observable<Challenge>
        let isPagination: Observable<Bool>
    }
    
    struct Output {
        let totalCount = PublishRelay<Int>()
        let tabBarModelList = PublishRelay<[ChallengeTabBarModel]>()
        let selectedTabBarItem = PublishRelay<ChallengeTabBarItemType>()
        let ongoingModelList = BehaviorRelay<[Challenge]>(value: [])
        let completedModelList = BehaviorRelay<[Challenge]>(value: [])
        
        let addChallenge = PublishRelay<Void>()
        let removeChallenge = PublishRelay<ChallengeState>()
        let modifyChallenge = PublishRelay<Void>()
    }
    
    init(coordinator: ChallengeCoordinator, challengeUseCase: ChallengeUseCase) {
        self.coordinator = coordinator
        self.challengeUseCase = challengeUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()

        input.viewWillAppear
            .take(1)
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.challengeUseCase.getChallengeCount()
                    .bind { model in
                        output.totalCount.accept(model.totalCount)
                        output.tabBarModelList.accept([ChallengeTabBarModel(type: .ongoing, count: model.ongoingCount),
                                                       ChallengeTabBarModel(type: .completed, count: model.completedCount)])
                        output.selectedTabBarItem.accept(.ongoing)
                    }.disposed(by: vm.disposeBag)
                
                vm.challengeUseCase.getChallengeLatestPageNo(type: .ongoing)
                    .bind(to: vm.currentOngoingChallengePageNo)
                    .disposed(by: vm.disposeBag)

                vm.challengeUseCase.getChallengeLatestPageNo(type: .completed)
                    .bind(to: vm.currentCompletedChallengePageNo)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        currentOngoingChallengePageNo
            .withUnretained(self)
            .bind { vm, pageNo in
                vm.challengeUseCase.getChallengeList(type: .ongoing, pageNo: pageNo)
                    .bind(to: vm.ongoingChallengeModelList)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        currentCompletedChallengePageNo
            .withUnretained(self)
            .bind { vm, pageNo in
                vm.challengeUseCase.getChallengeList(type: .completed, pageNo: pageNo)
                    .bind(onNext: { newFetchModelList in
                        var preModelList = vm.completedChallengeModelList.value
                        newFetchModelList.forEach { preModelList.append($0) }
                        
                        vm.completedChallengeModelList.accept(preModelList)
                    }).disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.isPagination
            .distinctUntilChanged()
            .filter { $0 }
            .withLatestFrom(currentOngoingChallengePageNo)
            .filter { $0 > 0 }
            .map { $0 - 1 }
            .bind(to: currentOngoingChallengePageNo)
            .disposed(by: disposeBag)
        
        input.tapAddButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showChallengeDetailFlow()
                vm.coordinator?.challengeModel.accept(Challenge())
            }.disposed(by: disposeBag)
        
        input.tapChallengeCell
            .withUnretained(self)
            .bind { vm, model in
                if ChallengeViewModel.isDetailViewPushed {
                    vm.coordinator?.showChallengeDetailFlow()
                    vm.coordinator?.challengeModel.accept(model)
                    ChallengeViewModel.isDetailViewPushed = false
                } else {
                    return
                }
            }.disposed(by: disposeBag)
        
        ongoingChallengeModelList
            .skip(1)
            .filter { $0.count <= 4 }
            .withLatestFrom(currentOngoingChallengePageNo)
            .filter { $0 > 0 }
            .map { $0 - 1 }
            .bind(to: currentOngoingChallengePageNo)
            .disposed(by: disposeBag)
        
        completedChallengeModelList
            .skip(1)
            .filter { $0.count <= 4 }
            .withLatestFrom(currentCompletedChallengePageNo)
            .filter { $0 > 0 }
            .map { $0 - 1 }
            .bind(to: currentCompletedChallengePageNo)
            .disposed(by: disposeBag)
        
        ongoingChallengeModelList
            .bind(to: output.ongoingModelList)
            .disposed(by: disposeBag)
        
        completedChallengeModelList
            .bind(to: output.completedModelList)
            .disposed(by: disposeBag)
        
        ChallengeViewModel.reloadObserver
            .withUnretained(self)
            .bind { vm, type in
                switch type {
                case .addChallenge:
                    output.addChallenge.accept(())
                    vm.challengeUseCase.getChallengeLatestPageNo(type: .ongoing)
                        .bind(to: vm.currentOngoingChallengePageNo)
                        .disposed(by: vm.disposeBag)
                case .removeOngoingChallenge:
                    output.removeChallenge.accept(.ongoing)
                case .removeCompletedChallenge:
                    break
                case .modifyChallenge:
                    output.modifyChallenge.accept(())
                    vm.challengeUseCase.getChallengeLatestPageNo(type: .ongoing)
                        .bind(to: vm.currentOngoingChallengePageNo)
                        .disposed(by: vm.disposeBag)
                case .completedChallenge:
                    break
                case .none:
                    break
                }
            }.disposed(by: disposeBag)
        
        return output
    }
}
