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
    func answerQuestion(accessToken: String, requestDTO: AnswerQuestionRequestDTO) -> Single<Bool>
    
    func getQuestion(accessToken: String, index: Int) ->Single<Question>
    
    func getQuestionList(accessToken: String, questionPage: QuestionPage) -> Single<[Question]>
    
    func getLatestQuestionPageNo(accessToken: String) -> Single<QuestionPage>
    
    func getTodayQuestion(accessToken: String) -> Single<Question>
    
    func pressForAnswer(_ accessToken: String, _ requestDTO: PressForAnswerRequestDTO) -> Single<Chat>
}
