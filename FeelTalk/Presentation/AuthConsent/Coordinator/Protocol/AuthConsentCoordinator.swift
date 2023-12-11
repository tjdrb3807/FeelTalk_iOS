//
//  AuthConsentCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/10.
//

import Foundation
import RxSwift
import RxCocoa

protocol AuthConsentCoordinator: Coordinator {
    var isConsented: PublishRelay<Bool> { get set }
    
    func dismiss()
}
