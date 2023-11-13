//
//  HomeCoordinator.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeCoordinator: Coordinator {
    var homeViewController: HomeViewController { get set }
    
    var signalModel: PublishRelay<Signal> { get set }
    
    var reloadData: PublishSubject<Void> { get set }
    
    func showSignalFlow()
}
