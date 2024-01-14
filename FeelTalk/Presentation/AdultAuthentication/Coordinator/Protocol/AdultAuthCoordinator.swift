//
//  AdultAuthCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/27.
//

import Foundation
import RxSwift
import RxCocoa

protocol AdultAuthCoordinator: Coordinator {
    var isFullConsented: PublishRelay<Bool> { get set }
    
    func showNewsAgencyFlow()
    
    func showAuthConsentFlow()
    
    func dismiss()
    
    func finish()
}
