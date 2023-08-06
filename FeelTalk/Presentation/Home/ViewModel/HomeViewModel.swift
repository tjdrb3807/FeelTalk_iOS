//
//  HomeViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    private weak var coordinator: HomeCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
}
