//
//  KakaoRePository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol KakaoRepository: AnyObject {
    func login() -> Single<SNSLogin01>
}
