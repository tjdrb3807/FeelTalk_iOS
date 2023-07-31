//
//  QuestionUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/26.
//

import Foundation
import RxSwift
import RxCocoa

protocol QuestionUseCase {
    
}

final class DefaultQuestionUseCase: QuestionUseCase {
    // MARK: Dependencies
    private let questionRepository: QuestionRepository
    
    private let disposbag = DisposeBag()
    
    init(questionRepository: QuestionRepository) {
        self.questionRepository = questionRepository
    }
    
//    func getLatestQuestionPageNo() {
//        guard let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else {
//            print("저장된 accessToken이 존재하지 않습니다.")
//        }
//        
//        questionRepository.getTodayQuestion(accessToken: accessToken)
//            .subscribe(onSuccess: <#T##((Int) -> Void)?##((Int) -> Void)?##(Int) -> Void#>, onFailure: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//    }
}
