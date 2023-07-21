//
//  TokenRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol TokenRepository {
    func renewAccessToken(refreshToken: String) -> Single<Token>
}
