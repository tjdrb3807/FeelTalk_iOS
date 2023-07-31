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
    func getLatestQuestionPageNo(accessToken: String) -> Single<Int>
    func getTodayQuestion(accessToken: String) -> Single<Question>
}
