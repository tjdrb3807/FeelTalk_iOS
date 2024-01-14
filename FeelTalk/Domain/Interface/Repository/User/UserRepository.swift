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
    func getInviteCode(accessToken: String) -> Single<String>
    
    func getMyInfo(accessToken: String) -> Single<MyInfo>
    
    func getPartnerInfo(accessToken: String) -> Single<PartnerInfo>
    
    func getUserState(accessToken: String) -> Single<UserState>
}
