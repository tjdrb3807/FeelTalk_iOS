//
//  WithdrawalDetailViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/08.
//

import Foundation
import RxSwift
import RxCocoa

final class WithdrawalDetailViewModel {
    let cellData = Observable<[WithdrawalReasonType]>.just([.breakUp, .noFunctionality, .bugOrError, .etc])
    private let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let cellData: Observable<[WithdrawalReasonType]>
    }
    
    init() {
        
    }
    
    func transfer(input: Input) -> Output {
        return Output(cellData: self.cellData)
    }
}
