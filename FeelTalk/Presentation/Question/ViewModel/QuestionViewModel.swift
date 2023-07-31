//
//  QuestionViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/30.
//

import Foundation
import RxSwift
import RxCocoa

final class QuestionViewModel {
    private let questionUseCase: QuestionUseCase
    private let disposeBag = DisposeBag()
    
    init(questionUseCase: QuestionUseCase) {
        self.questionUseCase = questionUseCase
    }
}
