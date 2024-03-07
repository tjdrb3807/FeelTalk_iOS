//
//  UserRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/14.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserRepository {
    func getInviteCode() -> Single<String>
    
    func getMyInfo() -> Single<MyInfo>
    
    func getPartnerInfo() -> Single<PartnerInfo>
    
    func getUserState() -> Single<UserState>
}
