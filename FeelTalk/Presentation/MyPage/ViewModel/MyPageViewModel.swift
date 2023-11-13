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
    private let typeList: [MyPageTableViewCellType] = [.configurationSettings, .inquiry, .questionSuggestions]
    let showBottomSheet = PublishRelay<CustomBottomSheetType>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapPartnerInfoButton: ControlEvent<Void>
        let tapTableViewCell: ControlEvent<MyPageTableViewCellType>
        let tapChatRoomButton: ControlEvent<Void>
    }
    
    struct Output {
        let userInfo: PublishRelay<MyInfo>
        let partnerInfo: PublishRelay<PartnerInfo>
        let cellData: Driver<[MyPageTableViewCellType]>
        let showBottomSheet: PublishRelay<CustomBottomSheetType>
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
        
        input.tapChatRoomButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showChatFlow()
            }.disposed(by: disposeBag)
        
        /// PartnerInfoCoordinator 화면 전환
        input.tapPartnerInfoButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showPartnerInfoFlow()
            }.disposed(by: disposeBag)
        
        /// ConfigurationCoordiantor 화면 전환
        input.tapTableViewCell
            .filter { $0 == .configurationSettings }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showSettingListFlow()
            }.disposed(by: disposeBag)
        
        /// InquiryCoordinator 화면 전환
        input.tapTableViewCell
            .filter { $0 == .inquiry }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showInquiryFlow()
            }.disposed(by: disposeBag)
        
        /// SuggestionsCoordiantor 화면 전환
        input.tapTableViewCell
            .filter { $0 == .questionSuggestions }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showSuggestionsFlow()                
            }.disposed(by: disposeBag)
        
        return Output(userInfo: self.userInfo,
                      partnerInfo: self.partnerInfo,
                      cellData: Driver.just(typeList),
                      showBottomSheet: self.showBottomSheet)
    }
}
