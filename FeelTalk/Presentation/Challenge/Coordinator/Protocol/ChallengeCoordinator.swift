//
//  ChallengeCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/14.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChallengeCoordinator: Coordinator {
    var challengeViewController: ChallengeViewController { get set }
    
    var challengeModel: PublishRelay<Challenge> { get set }
    
    var typeObserver: PublishRelay<ChallengeDetailViewType> { get set }
    
    func showChallengeDetailFlow()
}
