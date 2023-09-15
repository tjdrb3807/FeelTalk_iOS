//
//  MyPageViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageViewModel {
    private weak var coordinator: MyPageCoordinator?
    private let userUseCase: UserUseCase
    private let disposeBag = DisposeBag()
    
    private let userInfo = PublishRelay<MyInfo>()
    private let partnerInfo = PublishRelay<PartnerInfo>()
    private let typeList: [MyPageTableViewCellType] = [.notice, .customerService, .suggestion]
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapPushConfigurationSettingsButton: ControlEvent<Void>
        let tapMyProfileButton: ControlEvent<Void>
        let tapPartnerInfoButton: ControlEvent<Void>
        let tapTableViewCell: ControlEvent<MyPageTableViewCellType>
    }
    
    struct Output {
        let userInfo: PublishRelay<MyInfo>
        let partnerInfo: PublishRelay<PartnerInfo>
        let cellData: Driver<[MyPageTableViewCellType]>
    }
    
    init(coordinator: MyPageCoordinator, userUseCase: UserUseCase) {
        self.coordinator = coordinator
        self.userUseCase = userUseCase
    }
    
    func transfer(input: Input) -> Output {
        /// 나의 정보 가져기
        /// 파트너 정보 가져오기
        input.viewWillAppear
            .withUnretained(self)
            .bind { vm, _ in
                vm.userUseCase.getMyInfo()
                    .bind(to: vm.userInfo)
                    .disposed(by: vm.disposeBag)
                vm.userUseCase.getPartnerInfo()
                    .bind(to: vm.partnerInfo)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.tapPushConfigurationSettingsButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showConfigurationSettingsFlow()
            }.disposed(by: disposeBag)
        
        input.tapMyProfileButton
            .withUnretained(self)
            .bind { vm, _ in
                print("tapMyProfileInfoButton")
            }.disposed(by: disposeBag)
        
        input.tapPartnerInfoButton
            .withUnretained(self)
            .bind { vm, _ in
                print("tapPartnerInfoButton")
            }.disposed(by: disposeBag)
        
        /// CellType에 따른 화면 전환
        input.tapTableViewCell
            .withUnretained(self)
            .bind { vc, type in
                print(type)
            }.disposed(by: disposeBag)
        
        return Output(userInfo: self.userInfo,
                      partnerInfo: self.partnerInfo,
                      cellData: Driver.just(typeList))
    }
}
