//
//  CustomButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum CustomButtonType {
    case register
}

final class CustomButton: UIButton {
    let isState = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    var type: CustomButtonType?
    var title: String?
    
    init(type: CustomButtonType, title: String) {
        self.type = type
        self.title = title
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset * CommonConstraintNameSpace.trailingInset),
                                                             height: CustomButtonNameSpace.height)))
        
        self.bind()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        isState
            .withUnretained(self)
            .bind { b, state in
                b.rx.isEnabled.onNext(state)
                b.updateBackgroundColor(state: state)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                  size: CustomButtonNameSpace.titleTextSize)
        setTextColor()
        layer.cornerRadius = CustomButtonNameSpace.cornerRadius
        clipsToBounds = true
    }
}

extension CustomButton {
    private func setTextColor() {
        switch type {
        case .register:
            setTitleColor(.white, for: .normal)
        case .none:
            break
        }
    }
}

extension CustomButton {
    private func updateBackgroundColor(state: Bool) {
        switch type {
        case .register:
            state ?
            self.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500)) :
            self.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main400))
        case .none:
            break
        }
    }
}

#if DEBUG

import SwiftUI

struct CutomButtonType_Previews: PreviewProvider {
    static var previews: some View {
        CutomButtonType_Presentable()
    }
    
    struct CutomButtonType_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomButton(type: .register, title: "제출하기")
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
