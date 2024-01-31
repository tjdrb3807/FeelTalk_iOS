//
//  LockScreenSettingsViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import Foundation
import RxSwift
import RxCocoa

final class LockScreenSettingsViewModel {
    weak var coordinator: LockScreenSettingsCoordinator?
    private let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init(coordinator: LockScreenSettingsCoordinator) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
