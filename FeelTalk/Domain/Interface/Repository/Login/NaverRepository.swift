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
//    var refreshToken: PublishSubject<String> { get }
    var snsLoginInfo: PublishSubject<SNSLogin> { get }
    
    func login()
}
