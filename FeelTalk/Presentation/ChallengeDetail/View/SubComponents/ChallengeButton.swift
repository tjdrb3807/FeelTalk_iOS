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
                v.setEnable(with: type)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        titleLabel?.textColor = .white
        
        layer.cornerRadius = ChallengeButtonNameSpace.cornerRadius
        clipsToBounds = true
    }
}

extension ChallengeButton {
    private func setTitle(with type: ChallengeDetailViewType) {
        switch type {
        case .completed:
            rx.title().onNext(ChallengeButtonNameSpace.completedTypeTitleText)
        case .modify:
            rx.title().onNext(ChallengeButtonNameSpace.modifyTypeTitleText)
        case .new:
            rx.title().onNext(ChallengeButtonNameSpace.newTypeTitleText)
        case .ongoing:
            rx.title().onNext(ChallengeButtonNameSpace.ongoingTypeText)
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
        switch type {
        case .completed:
            rx.isEnabled.onNext(false)
        case .modify:
            rx.isEnabled.onNext(true)
        case .new:
            rx.isEnabled.onNext(false)
        case .ongoing:
            rx.isEnabled.onNext(true)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeButton_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeButton_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: ChallengeButtonNameSpace.height,
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
