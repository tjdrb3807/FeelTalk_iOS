//
//  GoogleRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol GoogleRepository {
    func login() -> Single<SNSLogin>
    func logOut()
}
