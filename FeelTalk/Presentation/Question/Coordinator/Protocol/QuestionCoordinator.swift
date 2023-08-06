//
//  QuestionCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import Foundation

protocol QuestionCoordinator: Coordinator {
    var questionViewController: QuestionViewController { get set }
    
    func showAnswerFlow(with question: Question)
}
