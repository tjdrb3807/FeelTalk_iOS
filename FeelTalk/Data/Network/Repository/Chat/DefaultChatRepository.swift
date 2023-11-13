//
//  DefaultChatRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/18.
//

import Foundation
import Alamofire
import RxSwift
import RxSwift

final class DefaultChatRepository: ChatRepository {
    func sendTextChat(accessToken: String, message: String) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(ChatAPI.sendTextChat(accessToken: accessToken,
                                            SendTextChatRequestDTO(message: message)))
            .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        observer(.success(true))
                    }
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getLatestChatPageNo(accessToken: String) -> Single<Int> {
        Single.create { observer -> Disposable in
            AF.request(ChatAPI.getLatestChatPageNo(accessToken: accessToken))
                .responseDecodable(of: BaseResponseDTO<GetLatestChatPageNoResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let getLatestChatPageNoResponseDTO = responseDTO.data! else { return }
                            observer(.success(getLatestChatPageNoResponseDTO.pageNo))
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
