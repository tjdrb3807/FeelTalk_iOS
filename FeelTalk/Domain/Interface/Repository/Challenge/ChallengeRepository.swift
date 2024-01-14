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
    func completeChallenge(accessToken: String, index: Int) -> Single<Bool>
    
    func getChallenge(accessToken: String, index: Int) -> Single<Challenge>
    
    func getChallengeCount(accessToken: String) -> Single<ChallengeCount>
    
    func getChallengeLatestPageNo(accessToken: String, type: ChallengeState) -> Single<ChallengePage>
    
    func getChallengeList(accessToken: String, type: ChallengeState, requestDTO: ChallengeListRequestDTO) -> Single<[Challenge]>
    
    func removeChallenge(accessToken: String, index: Int) -> Single<Bool>
}
