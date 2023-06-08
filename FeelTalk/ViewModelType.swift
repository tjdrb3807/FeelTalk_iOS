//
//  ViewModelType.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/09.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
