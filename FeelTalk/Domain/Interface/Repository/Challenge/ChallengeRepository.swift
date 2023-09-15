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
    func addChallenge(accessToken: String, challenge: Challenge) -> Single<Int>
    
    func modifiyChallenge(accessToken: String, challenge: Challenge) -> Single<Bool>
    
    func removeChallenge(accessToken: String, index: Int) -> Single<Bool>
    
    func getChallenge(accessToken: String, index: Int) -> Single<Challenge>
    
    func completeChallenge(accessToken: String, index: Int) -> Single<Bool>
    
    func getChallengeCount(accessToken: String) -> Single<ChallengeCount>
    
    func getOngoingChallengeList(accessToken: String, pageNo: ChallengePage) -> Single<[Challenge]>
    
    func getLatestOngoingChallengePageNo(accessToken: String) -> Single<ChallengePage>
    
    func getCompletedChallengeList(accessToken: String, pageNo: ChallengePage) -> Single<[Challenge]>
    
    func getLatestCompletedChallengePageNo(accessToken: String) -> Single<ChallengePage>
}
