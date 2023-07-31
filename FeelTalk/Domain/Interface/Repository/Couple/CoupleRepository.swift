//
//  CoupleRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import Foundation
import RxSwift
import RxCocoa

protocol CoupleRepository {
    func getInviteCode(accessToken: String) -> Single<String>
    func registerInviteCode(accessToken: String, inviteCode: String) -> Single<Bool>
}
