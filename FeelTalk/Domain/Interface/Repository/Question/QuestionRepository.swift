//
//  QuestionRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/26.
//

import Foundation
import RxSwift
import RxCocoa

protocol QuestionRepository {
    func answerQuestion(requestDTO: AnswerQuestionRequestDTO) -> Single<Bool>
    
    func getQuestion(index: Int) ->Single<Question>
    
    func getQuestionList(questionPage: QuestionPage) -> Single<[Question]>
    
    func getLatestQuestionPageNo() -> Single<QuestionPage>
    
    func getTodayQuestion() -> Single<Question>
    
    func pressForAnswer(_ requestDTO: PressForAnswerRequestDTO) -> Single<Chat>
}
