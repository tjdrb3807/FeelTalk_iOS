//
//  NicknameCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/31.
//

import Foundation
import RxSwift
import RxCocoa

protocol NicknameCoordinator: Coordinator {
    var isMarketingConsented: PublishRelay<Bool> { get }
    
    func popViewController()
}
