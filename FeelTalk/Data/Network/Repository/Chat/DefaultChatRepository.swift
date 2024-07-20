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
                print(response.debugDescription)
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let chatListResponseDTO = responseDTO.data! else { return }
                        observer(.success(
                            chatListResponseDTO.chatList
                                .compactMap({ chatDTO in
                                    chatDTO.toDomain()
                                })
                        ))
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
    
    func sendTextChat(text: String) -> Single<TextChat> {
        print("request: \(ChatAPI.sendTextChat(text: text))")
        return Single.create { observer -> Disposable in
            AF.request(
                ChatAPI.sendTextChat(text: text),
                interceptor: DefaultRequestInterceptor()
            ).responseDecodable(of: BaseResponseDTO<SendChatResponseDTO?>.self) { response in
                print("response: \(response.debugDescription)")
                
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let sendChatDTO = responseDTO.data! else { return }
                        print(sendChatDTO)
                        observer(.success(
                            TextChat(
                                index: sendChatDTO.index,
                                type: .textChatting,
                                isRead: sendChatDTO.isRead,
                                isMine: true,
                                createAt: sendChatDTO.createAt,
                                text: text)
                        ))
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
    
    func sendImageChat(image: UIImage) -> Single<ImageChat> {
        Single.create { observer -> Disposable in
            AF.upload(
                multipartFormData: { multipart in
                    multipart.append(
                        image.pngData()!,
                        withName: "imageFile",
                        fileName: nil,
                        mimeType: "image/png"
                    )
                },
                with: ChatAPI.sendImageChat(image: image),
                usingThreshold: UInt64.init(),
                interceptor: DefaultRequestInterceptor()
            ).responseDecodable(of: BaseResponseDTO<SendChatResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let sendChatDTO = responseDTO.data! else { return }
                        print(sendChatDTO)
                        observer(.success(
                            ImageChat(
                                index: sendChatDTO.index,
                                type: .imageChatting,
                                isRead: sendChatDTO.isRead,
                                isMine: true,
                                createAt: sendChatDTO.createAt,
                                imageURL: "url 서버에서 안 보내주는데 이거 어캄 망함")
                        ))
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
    
    func sendVoiceChat(audio: Data) -> Single<VoiceChat> {
            Single.create { observer -> Disposable in
                AF.upload(
                    multipartFormData: { multipart in
                        multipart.append(
                            audio,
                            withName: "voiceFile",
                            fileName: nil,
                            mimeType: "audio/*"
                        )
                    },
                    with: ChatAPI.sendVoiceChat(audio: audio),
                    usingThreshold: UInt64.init(),
                    interceptor: DefaultRequestInterceptor()
                ).responseDecodable(of: BaseResponseDTO<SendChatResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let sendChatDTO = responseDTO.data! else { return }
                            print(sendChatDTO)
                            observer(.success(
                                VoiceChat(
                                    index: sendChatDTO.index,
                                    type: .imageChatting,
                                    isRead: sendChatDTO.isRead,
                                    isMine: true,
                                    createAt: sendChatDTO.createAt,
                                    voiceURL: "url 서버에서 안 보내주는데 이거 어캄 망함2")
                            ))
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
