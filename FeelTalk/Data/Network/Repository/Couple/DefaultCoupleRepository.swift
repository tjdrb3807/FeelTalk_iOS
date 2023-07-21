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
    func getInviteCode(accessToken: String) -> Single<String> {
        return Single.create { observer -> Disposable in
            print(accessToken)
            AF.request(CoupleAPI.getInviteCode(accessToken: accessToken))
                .responseDecodable(of: BaseResponseDTO<InviteCodeResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            guard let inviteCodeResponseDTO = responseDTO.data! else { return }
                            observer(.success(inviteCodeResponseDTO.inviteCode))
                        } else {
                            guard let message = responseDTO.message else { return }
                            // TODO: 리팩토링 필요
                            debugPrint("[ERROR]: CoupleRepository - getInviteCode \n[ERROR MESSAGE]: \(message)")
                        }
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
}
