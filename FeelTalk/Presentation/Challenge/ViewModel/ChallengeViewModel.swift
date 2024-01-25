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
    
    private let currentDisplayCell = BehaviorRelay<ChallengeState>(value: .ongoing)
    private let initOngoingPageNo = PublishRelay<Int>()     // 가장 상단 pageNo
    private let initCompletedPageNo = PublishRelay<Int>()   // 가장 상단 pageNo
    private let currentOngoingChallengePageNo = PublishRelay<Int>()     // 최신 PageNo
    private let currentCompletedChallengePageNo = PublishRelay<Int>()   // 최신 PageNo
    private let ongoingChallengeModelList = BehaviorRelay<[Challenge]>(value: [])
    private let completedChallengeModelList = BehaviorRelay<[Challenge]>(value: [])
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapAddButton: ControlEvent<Void>
        let tapChallengeCell: Observable<Challenge>
        let isPagination: Observable<Bool>
        let currentDisplayCell: PublishRelay<ChallengeState>
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
        let completeChallenge = PublishRelay<Void>()
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
                    .bind { pageNo in
                        vm.initOngoingPageNo.accept(pageNo)
                        vm.currentOngoingChallengePageNo.accept(pageNo)
                    }.disposed(by: vm.disposeBag)

                vm.challengeUseCase.getChallengeLatestPageNo(type: .completed)
                    .bind { pageNo in
                        vm.initCompletedPageNo.accept(pageNo)
                        vm.currentCompletedChallengePageNo.accept(pageNo)
                    }.disposed(by: vm.disposeBag)
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
                    .bind(to: vm.completedChallengeModelList)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
//        input.isPagination
//            .distinctUntilChanged()
//            .filter { $0 }
//            .withLatestFrom(currentOngoingChallengePageNo)
//            .filter { $0 > 0 }
//            .map { $0 - 1 }
//            .bind(to: currentOngoingChallengePageNo)
//            .disposed(by: disposeBag)
        
        input.isPagination
            .distinctUntilChanged()
            .filter { $0 }
            .withLatestFrom(currentDisplayCell)
            .filter { $0 == .ongoing }
            .withLatestFrom(currentOngoingChallengePageNo)
            .filter { $0 > 0 }
            .map { $0 - 1 }
            .bind(to: currentOngoingChallengePageNo)
            .disposed(by: disposeBag)
        
        input.isPagination
            .distinctUntilChanged()
            .filter { $0 }
            .withLatestFrom(currentDisplayCell)
            .filter { $0 == .completed }
            .withLatestFrom(currentCompletedChallengePageNo)
            .filter { $0 > 0 }
            .map { $0 - 1 }
            .bind(to: currentCompletedChallengePageNo)
            .disposed(by: disposeBag)
        
        input.currentDisplayCell
            .bind(to: currentDisplayCell)
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
        
//        ongoingChallengeModelList
//            .skip(1)    // initValue [] 무시
//            .filter { $0.count <= 4 }   // page 최대 개수
//            .withLatestFrom(currentOngoingChallengePageNo)
//            .filter { $0 > 0 }
//            .map { $0 - 1 }
//            .bind(to: currentOngoingChallengePageNo)
//            .disposed(by: disposeBag)
        
        ongoingChallengeModelList
            .skip(1)
            .map { $0.count }
            .filter { $0 <= 4 }
            .withLatestFrom(initOngoingPageNo)
            .withLatestFrom(currentOngoingChallengePageNo) { (initNo: $0, currentNo: $1) }
            .filter { $0.initNo == $0.currentNo }
            .filter { $0.currentNo > 0 }
            .map { $0.currentNo - 1 }
            .bind(to: currentOngoingChallengePageNo)
            .disposed(by: disposeBag)
        
        completedChallengeModelList
            .skip(1)
            .map { $0.count }
            .filter { $0 <= 4 }
            .withLatestFrom(initCompletedPageNo)
            .withLatestFrom(currentCompletedChallengePageNo) { (initNo: $0, currentNo: $1) }
            .filter { $0.initNo == $0.currentNo }
            .filter { $0.currentNo > 0 }
            .map { $0.currentNo - 1 }
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
                        .bind { pageNo in
                            vm.initOngoingPageNo.accept(pageNo)
                            vm.currentOngoingChallengePageNo.accept(pageNo)
                        }.disposed(by: vm.disposeBag)
                case .removeOngoingChallenge:
                    output.removeChallenge.accept(.ongoing)
                case .removeCompletedChallenge:
                    output.removeChallenge.accept(.completed)
                case .modifyChallenge:
                    output.modifyChallenge.accept(())
                    vm.challengeUseCase.getChallengeLatestPageNo(type: .ongoing)
                        .bind(to: vm.currentOngoingChallengePageNo)
                        .disposed(by: vm.disposeBag)
                case .completedChallenge:
                    output.completeChallenge.accept(())
                    vm.challengeUseCase.getChallengeLatestPageNo(type: .completed)
                        .bind { pageNo in
                            vm.initCompletedPageNo.accept(pageNo)
                            vm.currentCompletedChallengePageNo.accept(pageNo)
                        }.disposed(by: vm.disposeBag)
                case .none:
                    break
                }
            }.disposed(by: disposeBag)
        
        return output
    }
}
