//
//  DefaultLoginRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class DefaultLoginRepository: NSObject, LoginRepository {
    func autoLogin() -> Single<String> {
        return Single.create { observer -> Disposable in
            AF.request(
                LoginAPI.autoLogin,
                interceptor: DefaultRequestInterceptor())
                .responseDecodable(of: BaseResponseDTO<AutoLoginResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let autoLoginResponseDTO = responseDTO.data! else { return }
                            observer(.success(autoLoginResponseDTO.signUpState))
                        } else {
                            guard let message = responseDTO.message else { return }
                            debugPrint("[ERROR] LoginRepository - autoLogin responseDTO status fail.\n[ERROR MESSAGE]: \(message)")
                        }
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func login(_ data: SNSLogin01) -> Single<Token01>{
        Single.create { observer -> Disposable in
            print("Log In RequestDTO: \(data.toDTO())")
            AF.request(LoginAPI.login(data.toDTO()))
                .responseDecodable(of: BaseResponseDTO<LoginResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        print("Log In ResponseDTO: \(responseDTO)")
                        if responseDTO.status == "success" {
                            guard let loginResponseDTO = responseDTO.data! else { return }
                            observer(.success(loginResponseDTO.toDomain()))
                        } else {
                            guard let message = responseDTO.message else { return }
                            debugPrint("[ERROR]: LoginRepository - reLogin \n[ERROR MESSAGE]: \(message)")
                        }
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func reissuanceAccessToken(accessToken: String, refreshToken: String) -> Single<Token01> {
        Single.create { observer -> Disposable in
            AF.request(
                LoginAPI.reissuanceAccessToken(
                    requestDTO: AccessTokenReissuanceRequestDTO(
                        accessToken: accessToken,
                        refreshToken: refreshToken))
            ).responseDecodable(of: BaseResponseDTO<LoginResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let loginResponseDTO = responseDTO.data! else { return }
                        observer(.success(loginResponseDTO.toDomain()))
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
    
    func logout() -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(
                LoginAPI.logout,
                interceptor: DefaultRequestInterceptor()
            ).responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        observer(.success(true))
                    } else {
                        observer(.success(false))
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
}

// MARK: Data bindding
extension DefaultLoginRepository {
    func getReLoginResponseDTO(to responseDTO: BaseResponseDTO<ReLoginReseponseDTO?>) -> ReLoginReseponseDTO? {
        guard let reLoginResponseDTO = responseDTO.data else { return nil }
        
        return reLoginResponseDTO
    }
}
