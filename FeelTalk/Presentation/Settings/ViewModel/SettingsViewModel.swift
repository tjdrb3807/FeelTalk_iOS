//
//  SettingsViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/29.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingsViewModel {
    private weak var coordinator: SettingsCoordinator?
    private let configurationUseCase: ConfigurationUseCase
    private let disposeBag = DisposeBag()
    
    var sections = BehaviorRelay<[SettingsSection]>(value: [
        SettingsSection(header: "Settings_first",
                        items: [SettingsModel(category: .lock, state: nil, isArrowIconHidden: false)]),
        SettingsSection(header: "Settings_second",
                        items: [SettingsModel(category: .info, state: nil, isArrowIconHidden: false)])
    ])
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let viewDisDisappear: ControlEvent<Bool>
        let popButtonTabObserver: ControlEvent<Void>
        let selectedCellObserver: ControlEvent<SettingsSection.Item>
    }
    
    struct Output {
        let sectionObserver = PublishRelay<[SettingsSection]>()
    }
    
    init(coordinator: SettingsCoordinator, configurationUseCase: ConfigurationUseCase) {
        self.coordinator = coordinator
        self.configurationUseCase = configurationUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .take(1)
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.configurationUseCase.getConfigurationInfo()
                    .map { $0.isLock ? LockScreenState.on.rawValue : LockScreenState.off.rawValue }
                    .bind { state in
                        vm.updateIsLockCell(with: state)
                    }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.selectedCellObserver
            .map { $0.category }
            .filter { $0 == .lock }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showLockScreenSettingsFlow()
            }.disposed(by: disposeBag)
        
        input.selectedCellObserver
            .map { $0.category }
            .filter { $0 == .info }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showAccountInfoSettingsFlow()
            }.disposed(by: disposeBag)
        
//        Observable
//            .merge(input.viewDisDisappear.asObservable().map { _ in () },
//                   input.popButtonTabObserver.asObservable())
//            .withUnretained(self)
//            .bind { vm, _ in
//                vm.coordinator?.finish()
//            }.disposed(by: disposeBag)
        
        input.popButtonTabObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.finish()
            }.disposed(by: disposeBag)
        
        sections
            .skip(1)
            .bind(to: output.sectionObserver)
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SettingsViewModel {
    private func updateIsLockCell(with state: String) {
        var sections = self.sections.value
        let newSection = SettingsSection(header: "Settings_first",
                                         items: [SettingsModel(category: .lock, state: state, isArrowIconHidden: false)])
        
        sections[0] = newSection
        
        self.sections.accept(sections)
    }
}

