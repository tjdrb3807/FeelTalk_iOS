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
    func registerInviteCode(inviteCode: String) -> Single<Bool>
}
