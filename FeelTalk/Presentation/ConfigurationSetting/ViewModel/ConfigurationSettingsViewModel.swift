//
//  ConfigurationSettingsViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import Foundation
import RxSwift
import RxCocoa

final class ConfigurationSettingsViewModel {
    private weak var coordinator: ConfigurationSettingsCoordinator?
    private let diseposeBag = DisposeBag()
    
    struct Input {
        let tapPopButton: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    init(coordinator: ConfigurationSettingsCoordinator) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        input.tapPopButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.finish()
            }.disposed(by: diseposeBag)
        
        return Output()
    }
}
