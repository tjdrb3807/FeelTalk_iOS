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
    
    private let totalCount = PublishRelay<ChallengeCount>()
    private let tabBarModelList = PublishRelay<[ChallengeTabBarModel]>()
    private let challengeModelList = BehaviorRelay<[ChallengeListModel]>(
        value: [
            .init(state: .ongoing,
                  list: [.init(index: 0, pageNo: 0, title: "차가워진 눈빛을 바라보며 이병의 말을 전해들어요", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "아무 의미 없던 노래 가사가", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "파트너이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "아프게 귓가에 맴돌아요", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "다시 겨울이 시작되듯이 흩어지는 눈 사이로 그대 내 마음에 쌓여만 가네", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "떠나지 말라는 그런 말도 하지 못 하고", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "파트너이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "고개를 떨구던 뒷모습만", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "그대 내게 오지 말아요 두 번 다시 이런 사랑하지 마요", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "그댈 추억하기보단 기다리는 게 부서진 내 마음이 더 아파와", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "피트너이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "다시 누군가를 만나서", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "결국 우리 사랑 지워내도", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "행복했던 것만 기억에 남아", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "나를 천천히 잊어주기를", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "아무것도 마음대로 안 돼요", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "아픔은 그저 나를 따라와", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "밤새도록 커져 버린 그리움", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "언제쯤 익숙해져 가나요", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "많은 날들이 떠오르네요", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "우리가 나눴던 날들", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "애써 감추고 돌아서네요", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "떠나지 말라는", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false)]),
            .init(state: .completed,
                  list: [.init(index: 0, pageNo: 0, title: "그런 말도 하지 못하고", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "고개를 떨구던 뒷모습만", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "그대 내게 오지 말아요", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
                         .init(index: 0, pageNo: 0, title: "두 번 다시 이런 사랑하지 마요", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
//                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
//                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
//                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
//                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
//                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false),
//                         .init(index: 0, pageNo: 0, title: "hello", deadline: "2023-11-11", content: "My name is Seong gyu", creator: "내이름", isCompleted: false)
                  ])
        ])
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapAddButton: ControlEvent<Void>
    }
    
    struct Output {
        let totalCount: PublishRelay<ChallengeCount>
        let tabBarModelList: PublishRelay<[ChallengeTabBarModel]>
        let challengeModelList: BehaviorRelay<[ChallengeListModel]>
    }
    
    init(coordinator: ChallengeCoordinator, challengeUseCase: ChallengeUseCase) {
        self.coordinator = coordinator
        self.challengeUseCase = challengeUseCase
    }
    
    func transfer(input: Input) -> Output {
        input.viewWillAppear
            .withUnretained(self)
            .bind { vm, _ in
                vm.challengeUseCase.getChallengeCount()
                    .bind { count in
                        vm.totalCount.accept(count)
                        vm.tabBarModelList.accept([ChallengeTabBarModel(type: .onGoing, count: count.ongoingCount),
                                                   ChallengeTabBarModel(type: .completed, count: count.completedCount)])
                    }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.tapAddButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showChallengeDetailFlow()
                vm.coordinator?.challengeModel.accept(Challenge())
            }.disposed(by: disposeBag)
        
        return Output(totalCount: self.totalCount,
                      tabBarModelList: self.tabBarModelList,
                      challengeModelList: self.challengeModelList)
    }
}
