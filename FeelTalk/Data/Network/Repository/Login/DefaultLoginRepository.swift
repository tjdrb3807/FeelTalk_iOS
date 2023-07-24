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
    func autoLogin(accessToken: String) -> Single<String> {
        return Single.create { observer -> Disposable in
            AF.request(LoginAPI.autoLogin(accessToken: accessToken))
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
    
    
    func reLogin(snsType: SNSType,
                 refreshToken: String?,
                 authCode: String?,
                 idToken: String?,
                 state: String?,
                 authorizationCode: String?) -> Single<Login> {
        return Single.create { observer -> Disposable in
            AF.request(LoginAPI.reLogin(request: .init(snsType: snsType.rawValue,
                                                       refreshToken: refreshToken,
                                                       authCode: authCode,
                                                       idToken: idToken,
                                                       state: state,
                                                       authorizationCode: authorizationCode)))
            .responseDecodable(of: BaseResponseDTO<ReLoginReseponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let reLoginResponseDTO = responseDTO.data! else { return }
                        observer(.success(reLoginResponseDTO.toDomain()))
                    } else {
                        guard let message = responseDTO.message else { return }
                        // TODO: 에러처리 리팩토링 필요
                        debugPrint("[ERROR]: LoginRepository - reLogin \n[ERROR MESSAGE]: \(message)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
}

enum KakaoLoginError: Error {
    case refreshTokenError
}

// MARK: Data bindding
extension DefaultLoginRepository {
    func getReLoginResponseDTO(to responseDTO: BaseResponseDTO<ReLoginReseponseDTO?>) -> ReLoginReseponseDTO? {
        guard let reLoginResponseDTO = responseDTO.data else { return nil }
        
        return reLoginResponseDTO
    }
}
