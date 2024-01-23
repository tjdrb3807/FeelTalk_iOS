//
//  ChallengeDetailCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol ChallengeDetailCoordinator: Coordinator {
    var challengeDetailViewController: ChallengeDetailViewController { get set }
    
    var challengeModel: PublishRelay<Challenge> { get set }
    
    func pop()
}
