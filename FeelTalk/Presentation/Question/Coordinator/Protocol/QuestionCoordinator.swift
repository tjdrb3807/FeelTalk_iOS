//
//  QuestionCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import Foundation
import RxSwift
import RxCocoa

protocol QuestionCoordinator: Coordinator {
    var model: PublishRelay<Question> { get set }
    
    var questionViewController: QuestionViewController { get set }
    
    func showAnswerFlow()
    
    func showChatFlow()
}
