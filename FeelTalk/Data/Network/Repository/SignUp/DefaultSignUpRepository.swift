//
//  DefaultSignUpRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/06.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class DefaultSignUpRepository: SignUpRepository {    
    func signUp(snsType: SNSType,
                nickname: String,
                refreshToken: String?,
                authCode: String?,
                idToken: String?,
                state: String?,
                authorizationCode: String?,
                fcmToken: String,
                marketingConsent: Bool) -> Single<Token> {
        return Single.create { observer -> Disposable in
            AF.request(SignUpAPI.signUp(request: .init(snsType: snsType.rawValue,
                                                       nickname: nickname,
                                                       refreshToken: refreshToken,
                                                       authCode: authCode,
                                                       idToken: idToken,
                                                       state: state,
                                                       authorizationCode: authorizationCode,
                                                       fcmToken: fcmToken,
                                                       marketingConsent: marketingConsent)))
            .responseDecodable(of: BaseResponseDTO<SignUpResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let signUpResponseDTO = responseDTO.data! else { return }
                        observer(.success(signUpResponseDTO.toDomain()))
                    } else {
                        guard let message = responseDTO.message else { return }
                        // TODO: error 처리 리팩토링 필요
                        debugPrint("[ERROR]: SignUpRepository - responseDTO state fail.\n[ERROR MESSAGE]: \(message)")
                    }
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getAuthNumber(_ requestDTO: AuthNumberRequestDTO) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(SignUpAPI.getAuthNumber(requestDTO))
                .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            observer(.success(true))
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
    
    func getReAuthNumber(_ requestDTO: ReAuthNumberRequestDTO) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(SignUpAPI.getReAuthNumber(requestDTO))
                .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            observer(.success(true))
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
    
    func verifyAnAdult(_ requestDTO: VerificationRequestDTO) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(SignUpAPI.verification(requestDTO))
                .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                    
                }
            
            return Disposables.create()
        }
    }
}
