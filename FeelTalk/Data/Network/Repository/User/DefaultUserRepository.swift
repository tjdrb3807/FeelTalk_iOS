//
//  DefaultUserRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/14.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class DefaultUserRepository: UserRepository {
    func getInviteCode() -> Single<String> {
        return Single.create { observer -> Disposable in
            AF.request(
                UserAPI.getInviteCode,
                interceptor: DefaultRequestInterceptor())
            .responseDecodable(of: BaseResponseDTO<InviteCodeResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let inviteCodeResponseDTO = responseDTO.data! else { return }
                        observer(.success(inviteCodeResponseDTO.inviteCode))
                    } else {
                        guard let message = responseDTO.message else { return }
                        print(message)
                    }
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getMyInfo() -> Single<MyInfo> {
        Single.create { observer -> Disposable in
            AF.request(
                UserAPI.getMyInfo,
                interceptor: DefaultRequestInterceptor())
            .responseDecodable(of: BaseResponseDTO<GetMyInfoResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let getMyInfoResponseDTO = responseDTO.data! else { return }
                        observer(.success(getMyInfoResponseDTO.toDomain()))
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
    
    func getPartnerInfo() -> Single<PartnerInfo> {
        Single.create { observer -> Disposable in
            AF.request(
                UserAPI.getPartnerInfo,
                interceptor: DefaultRequestInterceptor())
            .responseDecodable(of: BaseResponseDTO<GetPartnerInfoResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let getPartnerInfoResponseDTO = responseDTO.data! else { return }
                        observer(.success(getPartnerInfoResponseDTO.toDomain()))
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
    
    func getUserState() ->Single<UserState> {
        Single.create { observer -> Disposable in
            AF.request(
                UserAPI.getUserState,
                interceptor: DefaultRequestInterceptor())
            .responseDecodable(of: BaseResponseDTO<UserStateResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let userStateResponseDTO = responseDTO.data! else { return }
                        observer(.success(UserState(rawValue: userStateResponseDTO.state)!))
                    }
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            
            
            return Disposables.create()
        }
    }
}
