//
//  NaverRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/11.
//

import Foundation
import RxSwift
import RxCocoa

protocol NaverRepository {    
    var snsLoginInfo: PublishSubject<SNSLogin01> { get }
    
    func login()
}
