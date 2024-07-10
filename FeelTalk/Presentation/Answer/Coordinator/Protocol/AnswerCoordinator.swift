//
//  AnswerCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import Foundation
import RxSwift
import RxCocoa

protocol AnswerCoordinator: Coordinator {
    var model: PublishRelay<Question> { get set }
    
    var answerViewController: AnswerViewController { get set}
    
    func dismiss()
    
    func dismissAndShowChatFlow()
}
