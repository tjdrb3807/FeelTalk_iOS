//
//  NewsAgencyViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/10.
//

import Foundation
import RxSwift
import RxCocoa

final class NewsAgencyViewModel {
    private weak var coordinator: NewsAgencyCoordinator?
    private let disposeBag = DisposeBag()
    
    struct Input {
        var tapNewsAgnecyButton = PublishSubject<NewsAgencyType>()
        var dismiss = PublishRelay<Bool>()
    }
    
    struct Output {
        
    }
    
    init(coordinator: NewsAgencyCoordinator) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        input.tapNewsAgnecyButton
            .delay(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .bind(to: coordinator!.selectedNewsAgency)
            .disposed(by: disposeBag)
        
        input.dismiss
            .filter { $0 == true }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
        
        return Output()
    }
}
