//
//  ChallengeViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/14.
//

import Foundation
import RxSwift
import RxCocoa

final class ChallengeViewModel {
    private weak var coordinator: ChallengeCoordinator?
    private let challengeUseCase: ChallengeUseCase
    private let disposeBag = DisposeBag()
    
//    private let totalCount = PublishRelay<ChallengeCount>()
//    private let tabBarModelList = PublishRelay<[ChallengeTabBarModel]>()
    
    private let onGoingChallengeModelList = PublishRelay<[Challenge]>()
    private let completedChallengeModelList = PublishRelay<[Challenge]>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapAddButton: ControlEvent<Void>
    }
    
//    struct Output {
//        let totalCount: PublishRelay<ChallengeCount>
//        let tabBarModelList: PublishRelay<[ChallengeTabBarModel]>
//        let challengeModelList: BehaviorRelay<[ChallengeListModel]>
//    }
    
    struct Output {
        let totalCount = PublishRelay<Int>()
        let tabBarModelList = PublishRelay<[ChallengeTabBarModel]>()
        let selectedTabBarItem = PublishRelay<ChallengeTabBarItemType>()
        let challengeModelList = PublishRelay<[ChallengeListModel]>()
    }
    
    init(coordinator: ChallengeCoordinator, challengeUseCase: ChallengeUseCase) {
        self.coordinator = coordinator
        self.challengeUseCase = challengeUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
//        input.viewWillAppear
//            .withUnretained(self)
//            .bind { vm, _ in
//                vm.challengeUseCase.getChallengeCount()
//                    .bind { count in
//                        vm.totalCount.accept(count)
//                        vm.tabBarModelList.accept([ChallengeTabBarModel(type: .onGoing, count: count.ongoingCount),
//                                                   ChallengeTabBarModel(type: .completed, count: count.completedCount)])
//                    }.disposed(by: vm.disposeBag)
//            }.disposed(by: disposeBag)
        
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
                    .bind { pageNo in
                        vm.challengeUseCase.getChallengeList(type: .ongoing, pageNo: pageNo)
                            .bind(to: vm.onGoingChallengeModelList)
                            .disposed(by: vm.disposeBag)
                    }.disposed(by: vm.disposeBag)
                
                vm.challengeUseCase.getChallengeLatestPageNo(type: .completed)
                    .bind { pageNo in
                        vm.challengeUseCase.getChallengeList(type: .completed, pageNo: pageNo)
                            .bind(to: vm.completedChallengeModelList)
                            .disposed(by: vm.disposeBag)
                    }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        Observable
            .combineLatest(onGoingChallengeModelList,
                           completedChallengeModelList) { [ChallengeListModel(state: .ongoing, list: $0),
                                                           ChallengeListModel(state: .completed, list: $1)] }
                           .bind(to: output.challengeModelList)
                           .disposed(by: disposeBag)
                           
        
        input.tapAddButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showChallengeDetailFlow()
                vm.coordinator?.challengeModel.accept(Challenge())
                vm.coordinator?.typeObserver.accept(.new)
            }.disposed(by: disposeBag)
        
        return output
        
//        return Output(totalCount: self.totalCount,
//                      tabBarModelList: self.tabBarModelList,
//                      challengeModelList: self.challengeModelList)
    }
}
