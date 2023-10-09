//
//  LockingHintSettingsViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/19.
//

import Foundation
import RxSwift
import RxCocoa

final class LockingHintSettingsViewModel {
    let viewMode = PublishRelay<LockingHintSettingsViewMode>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
    }
    
    struct Output {
        
    }
    
    func tranfer(input: Input) -> Output {
        
        return Output()
    }
}
