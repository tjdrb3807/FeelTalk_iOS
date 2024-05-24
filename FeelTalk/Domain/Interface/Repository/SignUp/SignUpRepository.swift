//
//  SignUpRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/06.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignUpRepository {
    func getAuthNumber(_ requestDTO: AuthNumberRequestDTO) -> Single<String>
    
    func getReAuthNumber(_ requestDTO: ReAuthNumberRequestDTO) -> Single<Bool>
    
    func verifyAnAdult(_ requestDTO: VerificationRequestDTO) -> Single<Bool>
    
    func signUp(_ requestDTO: SignUpRequestDTO) -> Single<Bool>
}
