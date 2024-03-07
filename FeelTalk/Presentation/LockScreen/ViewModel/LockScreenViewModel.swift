//
//  LockScreenViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/03.
//

import Foundation
import RxSwift
import RxCocoa

final class LockScreenViewModel {
    private weak var coordinator: LockScreenCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: LockScreenCoordinator) {
        self.coordinator = coordinator
    }
}
