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
    func addChallenge(accessToken: String, challenge: Challenge) -> Single<Int> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.addChallenge(accessToken: accessToken, challenge: challenge))
                .responseDecodable(of: BaseResponseDTO<AddChallengeResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let addChallnegeResponseDTO = responseDTO.data! else { return }
                            observer(.success(addChallnegeResponseDTO.index))
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
    
    func modifiyChallenge(accessToken: String, challenge: Challenge) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.modifiyChallenge(accessToken: accessToken, challenge: challenge))
                .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            observer(.success(true))
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
    
    func removeChallenge(accessToken: String, index: Int) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.removeChallenge(accessToken: accessToken, index: index))
                .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            observer(.success(true))
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
    
    func getChallenge(accessToken: String, index: Int) -> Single<Challenge> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.getChallenge(accessToken: accessToken, index: index))
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
    
    func completeChallenge(accessToken: String, index: Int) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.completeChallenge(accessToken: accessToken, index: index))
                .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            observer(.success(true))
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
    
    func getChallengeCount(accessToken: String) -> Single<ChallengeCount> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.getChallengeCount(accessToken: accessToken))
                .responseDecodable(of: BaseResponseDTO<GetChallengeCountResponseDTO?>.self) { response in
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
    
    func getOngoingChallengeList(accessToken: String, pageNo: ChallengePage) -> Single<[Challenge]> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.getOngoingChallengeList(accessToken: accessToken, pageNo: pageNo))
                .responseDecodable(of: BaseResponseDTO<ChallengeListResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let challengeListResponseDTO = responseDTO.data! else { return }
                            observer(.success(challengeListResponseDTO.challenges.map { challenge in
                                challenge.toDomain()
                            }))
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
    
    func getLatestOngoingChallengePageNo(accessToken: String) -> Single<ChallengePage> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.getLatestOngingChallengePageNo(accessToken: accessToken))
                .responseDecodable(of: BaseResponseDTO<GetLatestChallengePageNoResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let latestChallengePageNoResponseDTO = responseDTO.data! else { return }
                            observer(.success(latestChallengePageNoResponseDTO.toDomain()))
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
    
    func getCompletedChallengeList(accessToken: String, pageNo: ChallengePage) -> Single<[Challenge]> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.getCompletedChallengeList(accessToken: accessToken, pageNo: pageNo))
                .responseDecodable(of: BaseResponseDTO<ChallengeListResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let challengeListResponseDTO = responseDTO.data! else { return }
                            observer(.success(challengeListResponseDTO.challenges.map { challenge in
                                challenge.toDomain()
                            }))
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
    
    func getLatestCompletedChallengePageNo(accessToken: String) -> Single<ChallengePage> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.getLatestCompletedChallengePageNo(accessToken: accessToken))
                .responseDecodable(of: BaseResponseDTO<GetLatestChallengePageNoResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let latestChallengePageNoResponseDTO = responseDTO.data! else { return }
                            observer(.success(latestChallengePageNoResponseDTO.toDomain()))
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
