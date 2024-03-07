//
//  LockScreenSettingsViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import Foundation
import RxSwift
import RxCocoa

enum LockScreenSettingsViewToastMessageType: String {
    case settings = "암호를 설정했어요"
    case reset = "암호를 변경했어오"
}

final class LockScreenSettingsViewModel {
    weak var coordinator: LockScreenSettingsCoordinator?
    private let configurationUseCase: ConfigurationUseCase
    private let disposeBag = DisposeBag()
    
    private let sections = BehaviorRelay<[LockScreenSettingsSection]>(value: [])
    static let toastMessagePopObserver = PublishRelay<LockScreenSettingsViewToastMessageType>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let cellTapObsercer: ControlEvent<LockScreenSettingsSection.Item>
        let popButtonTapObserver: ControlEvent<Void>
    }
    
    struct Output {
        let sections = PublishRelay<[LockScreenSettingsSection]>()
        let popToastMessage = PublishRelay<String>()
    }
    
    init(coordinator: LockScreenSettingsCoordinator, configurationUseCase: ConfigurationUseCase) {
        self.coordinator = coordinator
        self.configurationUseCase = configurationUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .asObservable()
            .map { _ -> Bool in DefaultAppCoordinator.isLockScreenObserver.value }
            .withUnretained(self)
            .bind { vm, isLocked in
                switch isLocked {
                case true:
                    vm.sections.accept([LockScreenSettingsSection(items: [
                        SettingsModel(category: .lock, state: LockScreenState.on.rawValue, isArrowIconHidden: false),
                        SettingsModel(category: .changePassword, isArrowIconHidden: false)])])
                case false:
                    vm.sections.accept([LockScreenSettingsSection(items: [
                        SettingsModel(category: .lock, state: LockScreenState.off.rawValue, isArrowIconHidden: false)])])
                }
            }.disposed(by: disposeBag)
        
        input.cellTapObsercer
            .asObservable()
            .filter { $0.category == .lock }
            .compactMap { $0.state }
            .map { LockScreenState(rawValue: $0) }
            .withUnretained(self)
            .bind { vm, currentState in
                var currentSection = vm.sections.value
                switch currentState {
                case .on:
                    currentSection[0].items[0].state = LockScreenState.off.rawValue
                    currentSection[0].items.remove(at: 1)
                    vm.configurationUseCase.setUnlock() // 잠금 해제 설정
                    vm.sections.accept(currentSection)
                case .off:
                    let newItem = SettingsModel(category: .changePassword, isArrowIconHidden: false)
                    currentSection[0].items[0].state = LockScreenState.on.rawValue
                    currentSection[0].items.append(newItem)
                    vm.sections.accept(currentSection)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
                        vm.coordinator?.showLockNumberPadFlow(with: .newSettings)}
                default:
                    break
                }
            }.disposed(by: disposeBag)

        input.cellTapObsercer
            .asObservable()
            .filter { $0.category == .changePassword }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showLockNumberPadFlow(with: .changePassword)
            }.disposed(by: disposeBag)
        
        input.popButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        sections
            .skip(1)
            .bind(to: output.sections)
            .disposed(by: disposeBag)
        
        LockScreenSettingsViewModel.toastMessagePopObserver
            .map { $0.rawValue }
            .bind(to: output.popToastMessage)
            .disposed(by: disposeBag)
        
        return output
    }
}
