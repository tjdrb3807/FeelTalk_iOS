//
//  DefaultRequestInterceptor.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/13.
//

import Foundation
import Alamofire

final class DefaultRequestInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("[REQUEST]: \(urlRequest)")
        
//        accessToken 갱신됐을 때의 환경 재현
//        var urlRequest = urlRequest
//        urlRequest.setValue("", forHTTPHeaderField: "Authorization")
//        completion(.success(urlRequest))
//        return
        
        let crtDateStr = Date.toString(Date())
        guard let crtAccessToken = KeychainRepository.getItem(key: "accessToken") as? String,
              let crtExpiredTime = KeychainRepository.getItem(key: "expiredTime") as? String,
              let targetDate = Date.toDate(crtExpiredTime),
              let crtDate = Date.toDate(crtDateStr) else {
            completion(.success(urlRequest))
            return }

        if Int(targetDate.timeIntervalSince(crtDate)) <= 60 { // 토큰 만료 시간이 1분 이하인 경우(재발급)
            guard let crtRefreshToken = KeychainRepository.getItem(key: "refreshToken") as? String else {
                completion(.success(urlRequest))
                return
            }
            print("[REQUEST]: reissue token adapt()")

            AF.request(
                LoginAPI.reissuanceAccessToken(
                    requestDTO: AccessTokenReissuanceRequestDTO(
                        accessToken: crtAccessToken,
                        refreshToken: crtRefreshToken)))
            .responseDecodable(of: BaseResponseDTO<LoginResponseDTO?>.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    print("[RESPONSE]: Success to reissue \(responseDTO)")
                    let loginResponseDTO: LoginResponseDTO?? = responseDTO.data
                    guard let data_unwrap = loginResponseDTO else {
                        return
                    }
                    guard let data = data_unwrap else {
                        return
                    }

                    if KeychainRepository.addItem(value: data.accessToken, key: "accessToken") &&
                        KeychainRepository.addItem(value: data.refreshToken, key: "refreshToken") &&
                        KeychainRepository.addItem(value: KeychainRepository.setExpiredTime(), key: "expiredTime") {

                        print("재발급 토큰 업데이트 완료")
                    } else {
                        print("재발급 토큰 업데이트 실패")
                        return
                    }
                case .failure(let error):
                    print("[RESPONSE]: Fail to reissue \(error)")
                    print("토큰 재발급 실패")
                    print(error)
                }
            }

            guard let newAccessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return }
            
            var urlRequest = urlRequest
            urlRequest.setValue(newAccessToken, forHTTPHeaderField: "Authorization")
            completion(.success(urlRequest))
        } else { // 토큰 만료 시간이 여유 있는 경우(기존 토큰 사용)
            var urlRequest = urlRequest
            urlRequest.setValue(crtAccessToken, forHTTPHeaderField: "Authorization")
            completion(.success(urlRequest))
        }
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("call retry()")
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
    }
}


