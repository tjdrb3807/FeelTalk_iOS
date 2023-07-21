//
//  DefaultTokenRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/20.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class DefaultTokenRepository: TokenRepository {
    func renewAccessToken(refreshToken: String) -> Single<Token> {
        return Single.create { observer -> Disposable in
            AF.request(TokenAPI.renewAccessToken(request: .init(refreshToken: refreshToken)))
                .responseDecodable(of: BaseResponseDTO<RenewAccessTokenResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let renewAccessTokenResponseDTO = responseDTO.data! else { return }
                            observer(.success(renewAccessTokenResponseDTO.toDomain()))
                        } else {
                            guard let message = responseDTO.message else { return }
                            debugPrint("[ERROR]: TokenRepository - responseDTO statius fail.\n[ERROR MESSAGE]: \(message)")
                        }
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
}
