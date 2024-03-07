//
//  ChallengeRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/03.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChallengeRepository {
    func addChallenge(requestDTO: AddChallengeRequestDTO) -> Single<ChallengeChat>
    
    func completeChallenge(requestDTO: CompleteChallengeRequestDTO) -> Single<ChallengeChat>
    
    func getChallenge(index: Int) -> Single<Challenge>
    
    func getChallengeCount() -> Single<ChallengeCount>
    
    func getChallengeLatestPageNo(type: ChallengeState) -> Single<ChallengePage>
    
    func getChallengeList(type: ChallengeState, requestDTO: ChallengeListRequestDTO) -> Single<[Challenge]>
    
    func modifyChallenge(requestDTO: ModifyChallengeRequestDTO) -> Single<Bool>
    
    func removeChallenge(requestDTO: RemoveChallengeRequestDTO) -> Single<Bool>
}
