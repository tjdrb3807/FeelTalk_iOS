//
//  DefaultChallengeRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/16.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class DefaultChallengeRepository: ChallengeRepository {
    func addChallenge(requestDTO: AddChallengeRequestDTO) -> Single<ChallengeChat> {
        Single.create { observer -> Disposable in
            AF.request(
                ChallengeAPI.addChallenge(requestDTO: requestDTO),
                interceptor: DefaultRequestInterceptor())
            .responseDecodable(of: BaseResponseDTO<AddChallengeResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let addChallengeResponseDTO = responseDTO.data! else { return }
                        observer(.success(addChallengeResponseDTO.toDomain()))
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
    
    func completeChallenge(requestDTO: CompleteChallengeRequestDTO) -> Single<ChallengeChat> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.completeChallenge(requestDTO: requestDTO),
                       interceptor: DefaultRequestInterceptor())
            .responseDecodable(of: BaseResponseDTO<CompleteChallengeResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let completeChallengeResponseDTO = responseDTO.data! else { return }
                        observer(.success(completeChallengeResponseDTO.toDomain()))
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
    
    func getChallenge(index: Int) -> Single<Challenge> {
        Single.create { observer -> Disposable in
            AF.request(
                ChallengeAPI.getChallenge(index: index),
                interceptor: DefaultRequestInterceptor())
            .responseDecodable(of: BaseResponseDTO<ChallengeBaseResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let challengeBaseResponseDTO = responseDTO.data! else { return }
                        observer(.success(challengeBaseResponseDTO.toDomain()))
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
    
    func getChallengeCount() -> Single<ChallengeCount> {
        Single.create { observer -> Disposable in
            AF.request(
                ChallengeAPI.getChallengeCount,
                interceptor: DefaultRequestInterceptor())
            .responseDecodable(of: BaseResponseDTO<ChallengeCountResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let getChallengeCountResponseDTO = responseDTO.data! else { return }
                        observer(.success(getChallengeCountResponseDTO.toDomain()))
                    }
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getChallengeLatestPageNo(type: ChallengeState) -> Single<ChallengePage> {
        let api = type == .ongoing ?
        ChallengeAPI.getOngoingChallengeLatestPageNo :
        ChallengeAPI.getCompletedChallengeLatestPageNo
        
        return Single.create { observer -> Disposable in
            AF.request(
                api,
                interceptor: DefaultRequestInterceptor())
            .responseDecodable(of: BaseResponseDTO<ChallengeLatestPageNoResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let challengeLatestPageNoResponseDTO = responseDTO.data! else { return }
                        observer(.success(challengeLatestPageNoResponseDTO.toDomain()))
                    } else {
                        guard let message = responseDTO.message else { return }
                        debugPrint(message)
                    }
                    break
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getChallengeList(type: ChallengeState, requestDTO: ChallengeListRequestDTO) -> Single<[Challenge]> {
        let api = type == .ongoing ?
        ChallengeAPI.getOngoingChallengeList(requestDTO: requestDTO) :
        ChallengeAPI.getCompletedChallengeList(requestDTO: requestDTO)
        
        return Single.create { observer -> Disposable in
            AF.request(
                api,
                interceptor: DefaultRequestInterceptor())
            .responseDecodable(of: BaseResponseDTO<ChallengeListResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        guard let challengeListResponseDTO = responseDTO.data! else { return }
                        var challengeList: [Challenge] = []
                        
                        challengeListResponseDTO.challengeList.forEach { challengeList.append($0.toDomain()) }
                        
                        observer(.success(challengeList))
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
    
    func modifyChallenge(requestDTO: ModifyChallengeRequestDTO) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(
                ChallengeAPI.modifyChallenge(requestDTO: requestDTO),
                interceptor: DefaultRequestInterceptor())
            .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    if responseDTO.status == "success" {
                        observer(.success(true))
                    } else {
                        guard let message = responseDTO.message else { return }
                        observer(.success(false))
                        debugPrint(message)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func removeChallenge(requestDTO: RemoveChallengeRequestDTO) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(
                ChallengeAPI.removeChallenge(requestDTO: requestDTO),
                interceptor: DefaultRequestInterceptor())
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
