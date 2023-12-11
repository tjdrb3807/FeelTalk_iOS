//
//  DefaultChatRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/14.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class DefaultChatRepository: ChatRepository {
    func getLastPageNo(accessToken: String) -> Single<Int> {
        Single.create { observer -> Disposable in
            AF.request(ChatAPI.getLastPageNo(accessToken: accessToken))
                .responseDecodable(of: BaseResponseDTO<ChatPageNoResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let lastPageNoResponseDTO = responseDTO.data! else { return }
                            print(lastPageNoResponseDTO)
                        } else {
                            guard let message = responseDTO.message else { return }
                            debugPrint("[ERROR] ChatRepository.getLastPageNo: \(message)")
                        }
                        
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func getChatList(accessToken: String, pageNo: Int) -> Single<[Chat]> {
        Single.create { observer -> Disposable in
            
            
            return Disposables.create()
        }
    }
}
