//
//  AccountInfoSettingsViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import Foundation
import RxSwift
import RxCocoa

final class AccountInfoSettingsViewModel {
    private weak var coordinator: AccountInfoSettingsCoordinator?
    private let disposeBag = DisposeBag()
    
    let sections = BehaviorRelay<[AccountInfoSettingsSection]>(value: [
        AccountInfoSettingsSection(items: [SettingsModel(category: .withdrawal, state: nil, isArrowIconHidden: true)])
    ])
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let popButtonTapObserver: ControlEvent<Void>
        let selectedCellObserver: ControlEvent<AccountInfoSettingsSection.Item>
    }
    
    struct Output {
        let sectionObserver = PublishRelay<[AccountInfoSettingsSection]>()
    }
    
    init(coordinator: AccountInfoSettingsCoordinator) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        // 화면 초기 설정
        input.viewWillAppear
            .take(1)
            .asObservable()
            .withLatestFrom(sections)
            .bind(to: output.sectionObserver)
            .disposed(by: disposeBag)
        
        // WithdrawalCoordiantor 화면 전환
        input.selectedCellObserver
            .asObservable()
            .filter { $0.category == .withdrawal }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showWithdrawalFlow()
            }.disposed(by: disposeBag)
        
        // NavigationController popVC
        input.popButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        return output
    }
}
