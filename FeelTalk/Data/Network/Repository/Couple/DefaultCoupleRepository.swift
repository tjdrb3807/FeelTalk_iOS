//
//  DefaultCoupleRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class DefaultCoupleRepository: CoupleRepository {
    func registerInviteCode(inviteCode: String) -> Single<Bool> {
        return Single.create { observer -> Disposable in
            AF.request(
                CoupleAPI.registerInviteCode(inviteCode: inviteCode),
                interceptor: DefaultRequestInterceptor())
                .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "fail" {
                            guard let message = responseDTO.message else { return }
                            print(message)
                            observer(.success(false))
                        } else {
                            observer(.success(true))
                        }
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                    }
                }
            
            return Disposables.create()
        }
    }
}
