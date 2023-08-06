//
//  DefaultQuestionRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/26.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class DefaultQuestionRepository: QuestionRepository {
    func getLatestQuestionPageNo(accessToken: String) -> Single<QuestionPage> {
        return Single.create { observer -> Disposable in
            AF.request(QuestionAPI.getLatestQuestionPageNo(accessToken: accessToken))
                .responseDecodable(of: BaseResponseDTO<GetLatestQuestionPageNoResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let getLatestQuestionPageNoResponseDTO = responseDTO.data! else { return }
                            observer(.success(getLatestQuestionPageNoResponseDTO.toDomain()))
                        } else {
                            guard let message = responseDTO.message else { return }
                            debugPrint(message)
                        }
                        
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func getTodayQuestion(accessToken: String) -> Single<Question> {
        return Single.create { observer -> Disposable in
            AF.request(QuestionAPI.getTodayQuestion(accessToken: accessToken))
                .responseDecodable(of: BaseResponseDTO<QuestionBaseResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let questionResponseDTO = responseDTO.data! else { return }
                            observer(.success(questionResponseDTO.toDomain()))
                        } else {
                            guard let message = responseDTO.message else { return }
                            debugPrint(message)
                        }
                    case .failure(let error):
                        print("QuesitonRepository.todayQuesiton error: \(error.localizedDescription)")
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func getQuestionList(accessToken: String, questionPage: QuestionPage) -> Single<[Question]> {
        return Single.create { observer -> Disposable in
            AF.request(QuestionAPI.getQuestionList(accessToken: accessToken, questionPage: questionPage))
                .responseDecodable(of: BaseResponseDTO<QuestionListResponseDTO?>.self) { reseponse in
                    switch reseponse.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let questionListResponseDTO = responseDTO.data! else { return }
                            observer(.success(questionListResponseDTO.questions.map { question in
                                question.toDomain()
                            }))
                        } else {
                            guard let message = responseDTO.message else { return }
                            print(message)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func getQuestion(accessToken: String, index: Int) -> Single<Question> {
        return Single.create { observer -> Disposable in
            AF.request(QuestionAPI.getQuestion(accessToken: accessToken, index: index))
                .responseDecodable(of: BaseResponseDTO<QuestionBaseResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let questionResponseDTO = responseDTO.data! else { return }
                            observer(.success(questionResponseDTO.toDomain()))
                        } else {
                            guard let message = responseDTO.message else { return }
                            print(message)
                        }                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        print(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func answerQuestion(accessToken: String, answer: QuestionAnswer) -> Single<Bool> {
        return Single.create { observer -> Disposable in
            AF.request(QuestionAPI.answerQuestion(accessToken: accessToken, answer: answer))
                .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            observer(.success(true))
                        } else {
                            guard let message = responseDTO.message else { return }
                            print(message)
                            observer(.success(false))
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            return Disposables.create()
        }
    }
}
