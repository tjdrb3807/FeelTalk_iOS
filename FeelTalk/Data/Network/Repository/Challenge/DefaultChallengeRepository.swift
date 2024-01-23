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
    func addChallenge(accessToken: String, requestDTO: AddChallengeRequestDTO) -> Single<ChallengeChat> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.addChallenge(accessToken: accessToken, requestDTO: requestDTO))
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
    
    func getChallengeCount(accessToken: String) -> Single<ChallengeCount> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.getChallengeCount(accessToken: accessToken))
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
    
    func getChallengeLatestPageNo(accessToken: String, type: ChallengeState) -> Single<ChallengePage> {
        let api = type == .ongoing ?
        ChallengeAPI.getOngoingChallengeLatestPageNo(accessToken: accessToken) :
        ChallengeAPI.getCompletedChallengeLatestPageNo(accessToken: accessToken)
        
        return Single.create { observer -> Disposable in
            AF.request(api)
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
    
    func getChallengeList(accessToken: String, type: ChallengeState, requestDTO: ChallengeListRequestDTO) -> Single<[Challenge]> {
        let api = type == .ongoing ?
        ChallengeAPI.getOngoingChallengeList(accessToken: accessToken, requestDTO: requestDTO) :
        ChallengeAPI.getCompletedChallengeList(accessToken: accessToken, requestDTO: requestDTO)
        
        return Single.create { observer -> Disposable in
            AF.request(api)
                .responseDecodable(of: BaseResponseDTO<ChallengeListResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let challengeListResponseDTO = responseDTO.data! else { return }
                            var challengeList: [Challenge] = []
                            
                            challengeListResponseDTO.challengeList.forEach { challengeList.append($0.toDomain()) }
                            
                            observer(.success(challengeList))
                        }

                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func modifyChallenge(accessToken: String, requestDTO: ModifyChallengeRequestDTO) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.modifyChallenge(accessToken: accessToken, requestDTO: requestDTO))
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
    
    func removeChallenge(accessToken: String, requestDTO: RemoveChallengeRequestDTO) -> Single<Bool> {
        Single.create { observer -> Disposable in
            AF.request(ChallengeAPI.removeChallenge(accessToken: accessToken, requestDTO: requestDTO))
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
