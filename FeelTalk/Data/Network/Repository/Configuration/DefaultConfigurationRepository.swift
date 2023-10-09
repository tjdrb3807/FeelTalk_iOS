//
//  DefaultConfigurationRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/15.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class DefaultConfigurationRepository: ConfigurationRepository {
    func getConfigurationInfo(accessToken: String) -> Single<ConfigurationInfo> {
        Single.create { observer -> Disposable in
            AF.request(ConfigurationAPI.getConfigurationInfo(accessToken: accessToken))
                .responseDecodable(of: BaseResponseDTO<GetConfigurationInfoResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let getConfigurationInfoResponseDTO = responseDTO.data! else { return }
                            observer(.success(getConfigurationInfoResponseDTO.toDomain()))
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
    
    func comment(accessToken: String, with data: InquiryOrSuggestions) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(ConfigurationAPI.comment(accessToken: accessToken,
                                                data: CommentRequestDTO(title: data.title,
                                                                        body: data.body,
                                                                        email: data.email)))
            .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        observer(.success(true))
                    } else {
                        guard let message = responseDTO.message  else { return }
                        debugPrint(message)
                    }
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getServiceDataTotalCount(accessToken: String) -> Single<ServiceDataCount> {
        Single.create { observer -> Disposable in
            AF.request(ConfigurationAPI.getServiceDataTotalCount(accessToken: accessToken))
                .responseDecodable(of: BaseResponseDTO<GetServiceDataTotalCountResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let getServiceDataTotalCountResponseDTO = responseDTO.data! else { return }
                            observer(.success(getServiceDataTotalCountResponseDTO.toDomain()))
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
