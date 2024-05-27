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

final class DefaultConfigurationRepository: ConfigurationRepository, RequestInterceptor {
    func getConfigurationInfo() -> Single<ConfigurationInfo> {
        print("[CALL]: ConfigurationRepository.getConfigurationInfo()")
        return Single.create { observer -> Disposable in
            AF.request(
                ConfigurationAPI.getConfigurationInfo,
                interceptor: DefaultRequestInterceptor())
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
    
    func comment(with data: InquiryOrSuggestions) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(
                ConfigurationAPI.comment(
                    data: CommentRequestDTO(title: data.title, body: data.body, email: data.email)),
                interceptor: DefaultRequestInterceptor())
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
    
    func getServiceDataTotalCount() -> Single<ServiceDataCount> {
        Single.create { observer -> Disposable in
            AF.request(
                ConfigurationAPI.getServiceDataTotalCount,
                interceptor: DefaultRequestInterceptor())
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
    
    func setLockNumber(requestDTO: LockNumberSettingsRequestDTO) -> Single<Bool> {
        Single.create { observer -> Disposable in
            print("Request: \(requestDTO)")
            AF.request(ConfigurationAPI.setLockNumber(dto: requestDTO),
                       interceptor: DefaultRequestInterceptor())
            .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    print("Success ResponseDTO: \(responseDTO)")
                    if responseDTO.status == "success" {
                        observer(.success(true))
                    } else {
                        guard let message = responseDTO.message else { return }
                        debugPrint(message)
                        observer(.success(false))
                    }
                case .failure(let error):
                    print("Failure ResponseDTO: \(error)")
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getLockNumber() -> Single<String> {
        Single.create { observer -> Disposable in
            AF.request(
                ConfigurationAPI.getLockNumber,
                interceptor: DefaultRequestInterceptor()
            ).responseDecodable(of: BaseResponseDTO<GetLockNumberResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let getLockNumberResponseDTO = responseDTO.data! else { return }
                        observer(.success(getLockNumberResponseDTO.lockNumber))
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
    
    func setUnlock() -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(
                ConfigurationAPI.setUnlock,
                interceptor: DefaultRequestInterceptor()
            ).responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        observer(.success(true))
                    } else {
                        guard let message = responseDTO.message else { return }
                        observer(.success(false))
                        print(message)
                    }
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func resetLockNumber(_ lockNumber: String) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(
                ConfigurationAPI.resetLockNumber(
                    dto: LockNumberResettingsRequestDTO(lockNumber: lockNumber)),
                interceptor: DefaultRequestInterceptor()
            ).responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        observer(.success(true))
                    } else {
                        guard let message = responseDTO.message else { return }
                        print(message)
                        observer(.success(false))
                    }
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getLockNumberHintType() -> Single<LockNumberHintType> {
        Single.create { observer -> Disposable in
            AF.request(
                ConfigurationAPI.getLockNumberHintType,
                interceptor: DefaultRequestInterceptor()
            ).responseDecodable(of: BaseResponseDTO<LockNumberHintTypeResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let lockNumberHintTypeResponseDTO = responseDTO.data! else { return }
                        observer(.success(LockNumberHintType(rawValue: lockNumberHintTypeResponseDTO.lockNumberHintType)!))
                    } else {
                        guard let message = responseDTO.message else { return }
                        print(message)
                    }
                case .failure(let error):
                    return observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
