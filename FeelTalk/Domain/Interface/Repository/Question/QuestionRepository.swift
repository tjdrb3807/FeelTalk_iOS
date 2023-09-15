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
    func getLatestQuestionPageNo(accessToken: String) -> Single<QuestionPage>
    func getTodayQuestion(accessToken: String) -> Single<Question>
    func getQuestionList(accessToken: String, questionPage: QuestionPage) -> Single<[Question]>
    func getQuestion(accessToken: String, index: Int) ->Single<Question>
    func answerQuestion(accessToken: String, answer: QuestionAnswer) -> Single<Bool>
    func preseForAnswer(accessToken: String, index: Int) -> Single<Bool>
}
