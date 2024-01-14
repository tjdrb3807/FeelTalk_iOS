//
//  DefaultSignalRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/03.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class DefaultSignalRepository: SignalRepository {
    func getMySignal(accessToken: String) -> Single<Signal> {
        Single.create { observer -> Disposable in
            AF.request(SignalAPI.getMySignal(accessToken))
                .responseDecodable(of: BaseResponseDTO<GetMySignalResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let getMySignalResponseDTO = responseDTO.data! else { return }
                            observer(.success(getMySignalResponseDTO.toDomain()))
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
    
    func getPartnerSignal(accessToken: String) -> Single<Signal> {
        Single.create { observer -> Disposable in
            AF.request(SignalAPI.getPartnerSignal(accessToken))
                .responseDecodable(of: BaseResponseDTO<GetPartnerSignalResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let getPatnerSignalResponseDTO = responseDTO.data! else { return }
                            observer(.success(getPatnerSignalResponseDTO.toDomain()))
                        } else {
                            guard let messsge = responseDTO.message else { return }
                            debugPrint(messsge)
                        }
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func changeMySignal(accessToken: String, requestDTO: ChangeMySignalRequestDTO) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(SignalAPI.changeMySignal(accessToken: accessToken, dto: requestDTO))
                .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            observer(.success(true))
                        } else {
                            guard let message = responseDTO.message else { return }
                            debugPrint(message)
                            observer(.success(false))
                        }
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
}
