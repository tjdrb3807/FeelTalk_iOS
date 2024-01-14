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
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            observer(.success(true))
                        } else {
                            guard let message = responseDTO.message else { return }
                            print("BUSSINESS ERROR: \(message)")
                            observer(.success(false))
                        }
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func signUp(_ requestDTO: SignUpRequestDTO) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(SignUpAPI.signUp(requestDTO))
                .responseDecodable(of: BaseResponseDTO<SignUpResponseDTO?>.self) { response in
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
}
