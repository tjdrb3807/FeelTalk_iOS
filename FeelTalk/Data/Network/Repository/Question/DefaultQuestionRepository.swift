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
    func getLatestQuestionPageNo(accessToken: String) -> Single<Int> {
        return Single.create { observer -> Disposable in
            AF.request(QuestionAPI.getLatestQuestionPageNo(accessToken: accessToken))
                .responseDecodable(of: BaseResponseDTO<GetLatestQuestionPageNoResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let getLatestQuestionPageNoResponseDTO = responseDTO.data! else { return }
                            observer(.success(getLatestQuestionPageNoResponseDTO.pageNo))
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
                            guard let QuestionResponseDTO = responseDTO.data! else { return }
                            observer(.success(QuestionResponseDTO.toDomain()))
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
}
