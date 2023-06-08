//
//  UserInfoConsetnViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/09.
//

import Foundation
import RxSwift
import RxCocoa

final class UserInfoConsetnViewModel: ViewModelType {
    struct Input {
        let tapSensitiveInfoTotalCheckButton: Observable<Bool>
        let tapPersonalInfoTaotalCheckButton: Observable<Bool>
    }
    
    struct Output {
        let activeNextButton: Observable<Bool>
    }
    
    private let activeNextButton = PublishSubject<Bool>()
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        Observable<Bool>
            .combineLatest(input.tapSensitiveInfoTotalCheckButton, input.tapPersonalInfoTaotalCheckButton) {
                $0 && $1
            }.bind(to: activeNextButton)
            .disposed(by: disposeBag)
        
        return Output(activeNextButton: activeNextButton.asObserver())
    }
}
