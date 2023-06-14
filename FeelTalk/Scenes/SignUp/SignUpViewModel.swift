//
//  SignUpViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/13.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    struct Input {
        let tapKakaoButton: Observable<SocialLoginType>
        let tapNaverButton: Observable<SocialLoginType>
        let tapGoogleButton: Observable<SocialLoginType>
        let tapAppleButton: Observable<SocialLoginType>
    }
    
    struct Output {
        
    }
    
    var disposeBag = DisposeBag()
    
    private let tapSocialLoginButton = PublishSubject<SocialLoginType>()
    
    func transform(input: Input) -> Output {
        input.tapKakaoButton.bind(to: tapSocialLoginButton).disposed(by: disposeBag)
        input.tapNaverButton.bind(to: tapSocialLoginButton).disposed(by: disposeBag)
        input.tapGoogleButton.bind(to: tapSocialLoginButton).disposed(by: disposeBag)
        input.tapAppleButton.bind(to: tapSocialLoginButton).disposed(by: disposeBag)
        
        tapSocialLoginButton.bind(onNext: { [weak self] type in
            guard let self = self else { return }
            
            switch type {
            case .kakao:
                debugPrint("[TAPPED]: SignUpViewController - \(type)Button")
                KakaoRepository.shared.login()
                    .subscribe(onNext: { print($0) },
                               onError: { print($0) })
                    .disposed(by: disposeBag)
            case .naver:
                debugPrint("[TAPPED]: SignUpViewController - \(type)Button")
            case .google:
                debugPrint("[TAPPED]: SignUpViewController - \(type)Button")
            case .apple:
                debugPrint("[TAPPED]: SignUpViewController - \(type)Button")
            }
        }).disposed(by: disposeBag)
        
        
        
        return Output()
    }
    
}
