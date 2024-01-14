//
//  ChallengeButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeButton: UIButton {
    let typeObserver = PublishRelay<ChallengeDetailViewType>()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind (){
        typeObserver
            .withUnretained(self)
            .bind { v, type in
                v.setTitle(with: type)
                v.setBackgroundColor(with: type)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        titleLabel?.textColor = .white
        
        layer.cornerRadius = 59 / 2
        clipsToBounds = true
    }
}

extension ChallengeButton {
    private func setTitle(with type: ChallengeDetailViewType) {
        switch type {
        case .completed:
            rx.title().onNext("이미 완료된 챌린지예요")
        case .modify:
            rx.title().onNext("챌린지 수정")
        case .new:
            rx.title().onNext("챌린지 만들기")
        case .ongoing:
            rx.title().onNext("챌린지 완료")
        }
    }
    
    private func setBackgroundColor(with type: ChallengeDetailViewType) {
        switch type {
        case .completed:
            rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main400))
        case .modify:
            rx.backgroundColor.onNext(.black)
        case .new:
            rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main400))
        case .ongoing:
            rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500))
        }
    }
    
    private func setEnable(with type: ChallengeDetailViewType) {
//        switch type {
//        case .completed:
//            rx.isEnabled.onNext(false)
//        case .modify:
//            <#code#>
//        case .new:
//            <#code#>
//        case .ongoing:
//            <#code#>
//        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeButton_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: 59,
                   alignment: .center)
    }
    
    struct ChallengeButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeButton()
            v.typeObserver.accept(.new)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
