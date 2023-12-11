//
//  NewsAgnecyCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/10.
//

import Foundation
import RxSwift
import RxCocoa

protocol NewsAgencyCoordinator: Coordinator {
    var selectedNewsAgency: PublishRelay<NewsAgencyType> { get set }
    
    func dismiss()
}
