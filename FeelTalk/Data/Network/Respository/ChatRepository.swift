//
//  ChatRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/29.
//

import Foundation
import Alamofire
import RxSwift

class ChatRepositroy {
    private let disposeBag = DisposeBag()
}

extension ChatRepositroy {
    func changeChatRoomStatus(isInChat: Bool) -> Observable<Result<BaseResponseDTO<Data?>, Error>> {
        return Observable.create { observer -> Disposable in
            AF.request(ChatAPI.changeChatRoomStatus(isInChat: isInChat))
                .responseDecodable(of: BaseResponseDTO<Data?>.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func getLastestChatPageNo() -> Observable<Result<BaseResponseDTO<GetLastestChatPageNoResponseDTO>, Error>> {
        return Observable.create { observer -> Disposable in
            AF.request(ChatAPI.getLastestChatPageNo)
                .responseDecodable(of: BaseResponseDTO<GetLastestChatPageNoResponseDTO>.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func loadChatList(pageNo: Int) -> Observable<Result<BaseResponseDTO<LoadChatListResponseDTO>, Error>> {
        return Observable.create { observer -> Disposable in
            AF.request(ChatAPI.loadChatList(pageNo: pageNo))
                .responseDecodable(of: BaseResponseDTO<LoadChatListResponseDTO>.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func sendEmoji(emoji: EmojiType.RawValue) -> Observable<Result<BaseResponseDTO<ChatBaseResponseDTO>, Error>> {
        return Observable.create { observer -> Disposable in
            AF.request(ChatAPI.sendEmoji(emoji: emoji))
                .responseDecodable(of: BaseResponseDTO<ChatBaseResponseDTO>.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func sendTextChat(message: String) -> Observable<Result<BaseResponseDTO<ChatBaseResponseDTO>, Error>> {
        return Observable.create { observer -> Disposable in
            AF.request(ChatAPI.sendTextChat(message: message))
                .responseDecodable(of: BaseResponseDTO<ChatBaseResponseDTO>.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func shareChallenge(index: Int) -> Observable<Result<BaseResponseDTO<ShareChallengeChatResponseDTO>, Error>> {
        return Observable.create { observer -> Disposable in
            AF.request(ChatAPI.shareChallenge(index: index))
                .responseDecodable(of: BaseResponseDTO<ShareChallengeChatResponseDTO>.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func shareQuestion(index: Int) -> Observable<Result<BaseResponseDTO<ShareQuestionChatResponseDTO>, Error>> {
        return Observable.create { observer -> Disposable in
            AF.request(ChatAPI.shareQuestion(index: index))
                .responseDecodable(of: BaseResponseDTO<ShareQuestionChatResponseDTO>.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
}
