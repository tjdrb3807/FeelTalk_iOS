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
    func getLastPageNo() -> Single<Int> {
        Single.create { observer -> Disposable in
            AF.request(
                ChatAPI.getLastPageNo,
                interceptor: DefaultRequestInterceptor())
            .responseDecodable(of: BaseResponseDTO<ChatPageNoResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let lastPageNoResponseDTO = responseDTO.data! else { return }
                        observer(.success(lastPageNoResponseDTO.pageNo))
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
    
    func getChatList(pageNo: Int) -> Single<[Chat]> {
        Single.create { observer -> Disposable in
            AF.request(
                ChatAPI.getChatList(pnageNo: pageNo),
                interceptor: DefaultRequestInterceptor()
            ).responseDecodable(of: BaseResponseDTO<ChatListResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let chatListResponseDTO = responseDTO.data! else { return }
                        print(chatListResponseDTO)
                    } else {
                        guard let message = responseDTO.message else { return }
                        
                    }
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
